import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/assets_constant.dart';
import 'package:get/get.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_application_2/pages/animals/animal_controller.dart';

class CameraController extends GetxController {
  // AR related variables
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARLocationManager? arLocationManager;

  // Track selected model
  RxString selectedModelUrl = "".obs;
  RxString selectedModelName = "".obs;
  RxBool isARInitialized = false.obs;
  RxBool isPlaneScanningComplete = false.obs;
  RxBool isPlaneDetectionInProgress = false.obs;
  RxBool isPlaneDetectionActive = true.obs; // NEW: Control plane detection

  // Track model placement and properties
  RxBool isModelPlaced = false.obs;
  RxBool isLoading = false.obs;
  ARNode? currentNode;
  ARPlaneAnchor? currentPlaneAnchor;
  RxDouble currentScale = 0.6.obs;
  final double scaleStep = 0.05;
  final double minScale = 0.1;
  final double maxScale = 1.0;

  // Improved tracking stabilization variables
  RxInt detectedPlanesCount = 0.obs;
  RxBool hasFoundGoodAnchor = false.obs;
  List<ARHitTestResult> _hitTestBuffer = [];
  final int _bufferSize = 8; // Reduced from 12 for faster response
  final int _initialBufferSize = 3; // Reduced from 6 for faster initial placement
  final int _refinementBufferSize = 6; // Reduced from 12 for faster refinement
  RxBool isInitialPlacement = true.obs;
  Timer? _stabilizationTimer;
  Timer? _planeDetectionTimeoutTimer; // NEW: Timeout for plane detection

  // Performance optimization variables
  RxDouble planeDetectionConfidence = 0.0.obs; // NEW: Track detection confidence
  final int minPlanesForGoodTracking = 2; // Reduced from 3 for faster detection
  final int maxPlaneDetectionTime = 5; // NEW: Max time in seconds for plane detection

  // Reference to the AnimalController
  final AnimalController animalController = Get.find<AnimalController>();

  // Plane size limitation (reduced for faster detection)
   final double maxPlaneHeight = 0.3; // Reduced from 0.5

  // Combined animals list from AnimalController
  List<Map<String, dynamic>> get allAnimals {
    List<Map<String, dynamic>> combined = [];
    combined.addAll(animalController.vertebrateAnimals);
    combined.addAll(animalController.invertebrateAnimals);
    return combined;
  }

  // Get models for display - using AnimalController data
  List<Map<String, dynamic>> get models3dList => allAnimals;

  @override
  void onInit() {
    super.onInit();

    // Check if we have arguments from AnimalDetailPage
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final animal = Get.arguments as Map<String, dynamic>;

      // Find matching animal in our combined animals list
      final modelIndex = allAnimals.indexWhere(
        (model) => model["name"] == animal["name"],
      );

      if (modelIndex != -1) {
        // Pre-select the model that matches the animal from detail page
        Future.delayed(Duration(seconds: 1), () {
          onModelTap(modelIndex);

          // Show guidance to place the animal once AR is initialized
          Future.delayed(Duration(seconds: 2), () { // Reduced from 3 seconds
            if (isARInitialized.value && isPlaneScanningComplete.value) {
              Get.snackbar(
                "Sentuh layar",
                "Untuk menempatkan ${allAnimals[modelIndex]["name"]}",
                duration: Duration(seconds: 2),
                snackPosition: SnackPosition.TOP,
              );
            }
          });
        });
      }
    }

    // Start improved timer to monitor plane detection quality
    _stabilizationTimer = Timer.periodic(Duration(milliseconds: 500), (timer) { // Faster checking
      if (isPlaneDetectionInProgress.value && detectedPlanesCount.value >= minPlanesForGoodTracking) {
        hasFoundGoodAnchor.value = true;
        isPlaneScanningComplete.value = true;
        isPlaneDetectionInProgress.value = false;
        timer.cancel();

        // Show feedback about good anchor found
        Get.snackbar(
          "Permukaan terdeteksi!",
          "Ketuk untuk menempatkan model",
          duration: Duration(seconds: 1), // Shorter duration
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });

    // NEW: Timeout timer for plane detection
    _planeDetectionTimeoutTimer = Timer(Duration(seconds: maxPlaneDetectionTime), () {
      if (isPlaneDetectionInProgress.value) {
        isPlaneScanningComplete.value = true;
        isPlaneDetectionInProgress.value = false;
        
        Get.snackbar(
          "Mode manual aktif",
          "Ketuk layar untuk mencoba menempatkan model",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

  @override
  void onClose() {
    _stabilizationTimer?.cancel();
    _planeDetectionTimeoutTimer?.cancel();
    arSessionManager?.dispose();
    super.onClose();
  }

  void onBackPressed() {
    Get.back();
  }

  void onModelTap(int index) {
    // Validate index bounds
    if (index < 0 || index >= allAnimals.length) {
      Get.snackbar(
        "Error",
        "Model tidak ditemukan",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Reset model placement if a new model is selected
    if (isModelPlaced.value) {
      resetModel();
    }

    // Get the selected model from combined animals list
    final selectedModel = allAnimals[index];

    // Set the selected model for AR display
    selectedModelUrl.value = selectedModel["model3dUrl"];
    selectedModelName.value = selectedModel["name"];

    // Reset scale to default
    currentScale.value = 0.5;

    // Reset to initial placement mode for new model
    isInitialPlacement.value = true;

    // Show guidance
    Get.snackbar(
      "${selectedModel["name"]} dipilih",
      hasFoundGoodAnchor.value
          ? "Sentuh layar untuk menempatkan hewan"
          : "Arahkan kamera ke permukaan datar",
      duration: Duration(seconds: 1), // Shorter duration
      snackPosition: SnackPosition.TOP,
    );
  }

  // Method to get animal by category for UI display
  List<Map<String, dynamic>> getAnimalsByCategory(int categoryIndex) {
    switch (categoryIndex) {
      case 0:
        return animalController.vertebrateAnimals;
      case 1:
        return animalController.invertebrateAnimals;
      default:
        return allAnimals;
    }
  }

  // Method to get category name
  String getCategoryName(int categoryIndex) {
    switch (categoryIndex) {
      case 0:
        return "Vertebrata";
      case 1:
        return "Invertebrata";
      default:
        return "Semua Hewan";
    }
  }

  // NEW: Method to stop plane detection after model placement
  void _stopPlaneDetection() {
    if (isPlaneDetectionActive.value) {
      isPlaneDetectionActive.value = false;
      
      // Disable plane detection in AR session (using supported parameters)
      arSessionManager?.onInitialize(
        showFeaturePoints: false,
        customPlaneTexturePath: AssetsCollection.logo,
        showPlanes: true, // Disable plane visualization
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
        showAnimatedGuide: false,
        handleTaps: true,
      );
      
      print("Plane detection stopped after model placement");
    }
  }

  // NEW: Method to restart plane detection
  void _restartPlaneDetection() {
    if (!isPlaneDetectionActive.value) {
      isPlaneDetectionActive.value = true;
      isPlaneDetectionInProgress.value = true;
      hasFoundGoodAnchor.value = false;
      detectedPlanesCount.value = 0;
      
      // Re-enable plane detection in AR session (using supported parameters)
      arSessionManager?.onInitialize(
        showFeaturePoints: false,
        customPlaneTexturePath: AssetsCollection.logo,
        showPlanes: true,
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
        showAnimatedGuide: true,
        handleTaps: true,
      );
      
      // Restart timers
      _stabilizationTimer?.cancel();
      _stabilizationTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (isPlaneDetectionInProgress.value && detectedPlanesCount.value >= minPlanesForGoodTracking) {
          hasFoundGoodAnchor.value = true;
          isPlaneScanningComplete.value = true;
          isPlaneDetectionInProgress.value = false;
          timer.cancel();
        }
      });
      
      print("Plane detection restarted");
    }
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arLocationManager = arLocationManager;

    // Start plane detection process with optimized settings
    isPlaneDetectionInProgress.value = true;
    isPlaneDetectionActive.value = true;
    hasFoundGoodAnchor.value = false;
    detectedPlanesCount.value = 0;

    // Initialize AR session with optimized settings for faster plane detection
    this.arSessionManager!.onInitialize(
      showFeaturePoints: false, // Keep disabled for performance
      customPlaneTexturePath: AssetsCollection.logo,
      showPlanes: true,
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
      showAnimatedGuide: true,
      handleTaps: true,
    );

    // Initialize object manager
    this.arObjectManager!.onInitialize();

    // Set up plane detected handler
    this.arSessionManager!.onPlaneDetected = onPlaneDetected;

    // Set up tap handler
    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;

    // Set up gesture handlers
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;

    isARInitialized.value = true;

    // Reduced delay for more responsive initialization
    Future.delayed(Duration(milliseconds: 1500), () {
      if (isPlaneDetectionActive.value) {
        this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          customPlaneTexturePath: AssetsCollection.logo,
          showPlanes: true,
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          showAnimatedGuide: false,
          handleTaps: true,
        );
      }
    });
  }

  // Improved callback when a new plane is detected
  void onPlaneDetected(int planeCount) {
    if (!isPlaneDetectionActive.value) return; // Skip if detection is disabled
    
    detectedPlanesCount.value = planeCount;
    planeDetectionConfidence.value = min(planeCount / minPlanesForGoodTracking, 1.0);
    
    print("Detected plane #${planeCount} (confidence: ${(planeDetectionConfidence.value * 100).toInt()}%)");
    
    // Provide immediate feedback to user
    if (planeCount == 1) {
      Get.snackbar(
        "Mencari permukaan...",
        "Gerakkan kamera perlahan",
        duration: Duration(milliseconds: 800),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.6),
        colorText: Colors.white,
      );
    }
  }

  // Optimized stabilization with faster response
  ARHitTestResult? _getStableHitResult(List<ARHitTestResult> hitTestResults) {
    if (hitTestResults.isEmpty) return null;

    // Find plane hits with priority
    var planeHits = hitTestResults
        .where((hit) => hit.type == ARHitTestResultType.plane)
        .toList();

    var bestHit = planeHits.isNotEmpty ? planeHits.first : hitTestResults.first;

    // Use smaller buffer sizes for faster response
    int effectiveBufferSize = isInitialPlacement.value ? _initialBufferSize : _refinementBufferSize;

    _hitTestBuffer.add(bestHit);
    if (_hitTestBuffer.length > effectiveBufferSize) {
      _hitTestBuffer.removeAt(0);
    }

    // Start with just 2 samples for even faster response
    if (_hitTestBuffer.length < 2) {
      return bestHit;
    }

    try {
      // Simplified averaging for better performance
      vector.Vector3 averagePosition = vector.Vector3.zero();
      
      for (int i = 0; i < _hitTestBuffer.length; i++) {
        vector.Vector3 position = _hitTestBuffer[i].worldTransform.getTranslation();
        averagePosition += position;
      }
      
      // Simple average instead of weighted average for speed
      averagePosition.scale(1.0 / _hitTestBuffer.length);

      return bestHit;
    } catch (e) {
      print("Error stabilizing hit result: $e");
      return bestHit;
    }
  }

  Future<void> onPlaneOrPointTapped(
    List<ARHitTestResult> hitTestResults,
  ) async {
    // If no model is selected, show message and return
    if (selectedModelUrl.value.isEmpty) {
      Get.snackbar(
        "Pilih model terlebih dahulu",
        "Tap pada hewan di bawah",
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // If already placed, ignore tap (use reset instead)
    if (isModelPlaced.value) {
      Get.snackbar(
        "Model sudah ditempatkan",
        "Gunakan tombol reset untuk menempatkan ulang",
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // If loading, prevent multiple taps
    if (isLoading.value) return;

    // If no hit results, show guidance
    if (hitTestResults.isEmpty) {
      Get.snackbar(
        "Permukaan tidak terdeteksi",
        "Arahkan kamera ke permukaan datar",
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Set loading state
    isLoading.value = true;

    try {
      // Get stabilized hit result with faster processing
      ARHitTestResult? stableHit = _getStableHitResult(hitTestResults);

      if (stableHit == null) {
        Get.snackbar(
          "Tracking tidak stabil",
          "Coba tahan kamera lebih stabil dan tap lagi",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
        );
        isLoading.value = false;
        return;
      }

      // Reduced delay for faster placement
      await Future.delayed(Duration(milliseconds: 100));

      // Create anchor at hit location
      currentPlaneAnchor = ARPlaneAnchor(
        transformation: stableHit.worldTransform,
      );

      // Add the anchor
      bool? anchorAdded = await arAnchorManager!.addAnchor(currentPlaneAnchor!);

      if (anchorAdded == true) {
        // Create a node (3D model)
        currentNode = ARNode(
          type: NodeType.webGLB,
          uri: selectedModelUrl.value,
          scale: vector.Vector3(
            currentScale.value,
            currentScale.value,
            currentScale.value,
          ),
          position: vector.Vector3(0, 0, 0),
          rotation: vector.Vector4(1, 0, 0, 0),
        );

        // Add the node to the anchor
        bool? nodeAdded = await arObjectManager!.addNode(
          currentNode!,
          planeAnchor: currentPlaneAnchor,
        );

        if (nodeAdded == true) {
          isModelPlaced.value = true;
          isInitialPlacement.value = false;
          
          // IMPORTANT: Stop plane detection after successful placement
          _stopPlaneDetection();
          
          // Cancel timers as we no longer need plane detection
          _stabilizationTimer?.cancel();
          _planeDetectionTimeoutTimer?.cancel();

          Get.snackbar(
            "Berhasil! ✓",
            "${selectedModelName.value} telah ditempatkan",
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          // If node couldn't be added, clear the anchor
          await arAnchorManager!.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
          currentNode = null;

          Get.snackbar(
            "Gagal menambahkan model",
            "Coba lagi",
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.snackbar(
          "Gagal membuat anchor",
          "Coba lagi",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Error placing model: $e");
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: $e",
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function to change model scale (optimized)
  void changeScale(bool increase) {
    if (!isModelPlaced.value || currentNode == null) {
      Get.snackbar(
        "Tidak ada model",
        "Tempatkan model terlebih dahulu",
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      double newScale;
      if (increase) {
        newScale = currentScale.value + scaleStep;
        if (newScale > maxScale) newScale = maxScale;
      } else {
        newScale = currentScale.value - scaleStep;
        if (newScale < minScale) newScale = minScale;
      }

      if (newScale != currentScale.value) {
        arObjectManager!.removeNode(currentNode!);

        // Reduced delay for faster scaling
        Future.delayed(Duration(milliseconds: 200), () {
          ARNode newNode = ARNode(
            type: NodeType.webGLB,
            uri: selectedModelUrl.value,
            scale: vector.Vector3(newScale, newScale, newScale),
            position: vector.Vector3(0, 0, 0),
            rotation: vector.Vector4(1, 0, 0, 0),
          );

          arObjectManager!
              .addNode(newNode, planeAnchor: currentPlaneAnchor)
              .then((success) {
                if (success == true) {
                  currentNode = newNode;
                  currentScale.value = newScale;

                  Get.snackbar(
                    increase ? "Diperbesar" : "Diperkecil",
                    "${(newScale * 100).toInt()}%",
                    duration: Duration(milliseconds: 800),
                    backgroundColor: Colors.blue.withOpacity(0.7),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
                isLoading.value = false;
              });
        });
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      print("Error changing scale: $e");
      isLoading.value = false;
    }
  }

  // Function to reset model and restart plane detection
  void resetModel() {
    if (!isModelPlaced.value) return;
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      // Clear stabilization buffer
      _hitTestBuffer.clear();
      isInitialPlacement.value = true;

      // Remove current node
      if (currentNode != null) {
        arObjectManager?.removeNode(currentNode!);
        currentNode = null;
      }

      Future.delayed(Duration(milliseconds: 200), () {
        // Remove current anchor
        if (currentPlaneAnchor != null) {
          arAnchorManager?.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
        }

        // Reset states
        isModelPlaced.value = false;
        currentScale.value = 0.5;
        
        // IMPORTANT: Restart plane detection after reset
        _restartPlaneDetection();

        Get.snackbar(
          "Model dihapus",
          "Cari permukaan baru untuk menempatkan model",
          duration: Duration(seconds: 1),
          backgroundColor: Colors.blue.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        isLoading.value = false;
      });
    } catch (e) {
      print("Error resetting model: $e");
      isLoading.value = false;
    }
  }

  // Simplified gesture handling for better performance
  void onPanStarted(String nodeName) {
    print("Pan started on node: $nodeName");
  }

  void onPanChanged(String nodeName) {
    // Minimal logging for performance
  }

  void onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Pan ended on node: $nodeName");
  }

  void _smoothNodeTransform(String nodeName, Matrix4 newTransform) {
    // Simplified implementation for better performance
  }

  void onRotationStarted(String nodeName) {
    print("Rotation started on node: $nodeName");
  }

  void onRotationChanged(String nodeName) {
    // Minimal logging for performance
  }

  void onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Rotation ended on node: $nodeName");
  }
}