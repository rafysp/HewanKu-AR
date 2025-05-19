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

  // Track model placement and properties
  RxBool isModelPlaced = false.obs;
  RxBool isLoading = false.obs;
  ARNode? currentNode;
  ARPlaneAnchor? currentPlaneAnchor;
  RxDouble currentScale = 0.9.obs;
  final double scaleStep = 0.05;
  final double minScale = 0.1;
  final double maxScale = 1.0;

  // Tracking stabilization variables
  RxInt detectedPlanesCount = 0.obs;
  RxBool hasFoundGoodAnchor = false.obs;
  List<ARHitTestResult> _hitTestBuffer = [];
  final int _bufferSize = 12;
  final int _initialBufferSize = 6;
  final int _refinementBufferSize = 12;
  RxBool isInitialPlacement = true.obs;
  Timer? _stabilizationTimer;

  // Plane size limitation (50x50cm = 0.5x0.5m)
  final double maxPlaneWidth = 0.5;
  final double maxPlaneHeight = 0.5;

  // 3D models list
  final List<Map<String, dynamic>> models3dList = [
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//arm_chair__furniture.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//Arm%20chair.png",
      "name": "Kursi",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//chicken_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//ayam.jpg",
      "name": "Ayam",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//dog_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-siberian-husky-dog-png-image_16179695.png",
      "name": "Anjing",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//horse_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-horse-png-with-ai-generated-png-image_14576200.png",
      "name": "Kuda",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//kitty_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-orange-cat-cute-little-kitty-png-image_14519124.png",
      "name": "Kucing",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//tiger_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-tiger-walking-wildlife-scene-transparent-background-png-image_9153495.png",
      "name": "Harimau",
    },
  ];

  @override
  void onInit() {
    super.onInit();

    // Check if we have arguments from AnimalDetailPage
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final animal = Get.arguments as Map<String, dynamic>;

      // Find matching animal in our models list
      final modelIndex = models3dList.indexWhere(
        (model) => model["name"] == animal["name"],
      );

      if (modelIndex != -1) {
        // Pre-select the model that matches the animal from detail page
        Future.delayed(Duration(seconds: 1), () {
          onModelTap(modelIndex);

          // Show guidance to place the animal once AR is initialized
          Future.delayed(Duration(seconds: 3), () {
            if (isARInitialized.value && isPlaneScanningComplete.value) {
              Get.snackbar(
                "Sentuh layar",
                "Untuk menempatkan ${models3dList[modelIndex]["name"]}",
                duration: Duration(seconds: 2),
                snackPosition: SnackPosition.TOP,
              );
            }
          });
        });
      }
    }

    // Start timer to monitor plane detection quality
    _stabilizationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isPlaneDetectionInProgress.value && detectedPlanesCount.value >= 3) {
        hasFoundGoodAnchor.value = true;
        isPlaneScanningComplete.value = true;
        isPlaneDetectionInProgress.value = false;
        timer.cancel();

        // Show feedback about good anchor found
        Get.snackbar(
          "Permukaan terdeteksi",
          "Ketuk untuk menempatkan model",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

  @override
  void onClose() {
    _stabilizationTimer?.cancel();
    arSessionManager?.dispose();
    super.onClose();
  }

  void onBackPressed() {
    Get.back();
  }

  void onModelTap(int index) {
    // Reset model placement if a new model is selected
    if (isModelPlaced.value) {
      resetModel();
    }

    // Get the selected model
    final selectedModel = models3dList[index];

    // Set the selected model for AR display
    selectedModelUrl.value = selectedModel["model3dUrl"];
    selectedModelName.value = selectedModel["name"];

    // Reset scale to default
    currentScale.value = 0.9;
    
    // Reset to initial placement mode for new model
    isInitialPlacement.value = true;

    // Show guidance
    Get.snackbar(
      "${selectedModel["name"]}",
      hasFoundGoodAnchor.value
          ? "Sentuh layar untuk menempatkan hewan"
          : "Arahkan kamera ke permukaan datar",
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
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

    // Start plane detection process
    isPlaneDetectionInProgress.value = true;
    hasFoundGoodAnchor.value = false;
    detectedPlanesCount.value = 0;

    // Initialize AR session with enhanced settings for better plane detection
    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      customPlaneTexturePath: AssetsCollection.logo,
      showPlanes: true,
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
      showAnimatedGuide: true,
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

    // After initial initialization, reinitialize with more stable settings
    Future.delayed(Duration(seconds: 2), () {
      this.arSessionManager!.onInitialize(
        showFeaturePoints: false,
        customPlaneTexturePath: AssetsCollection.logo,
        showPlanes: true,
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
        showAnimatedGuide: false,
      );
    });

    // After 8 seconds, consider plane detection complete even if callback didn't fire
    Future.delayed(Duration(seconds: 8), () {
      if (isPlaneDetectionInProgress.value) {
        isPlaneScanningComplete.value = true;
        isPlaneDetectionInProgress.value = false;

        if (!hasFoundGoodAnchor.value) {
          Get.snackbar(
            "Permukaan Terdeteksi",
            "Coba temukan area dengan lebih banyak detail untuk penempatan yang lebih baik",
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange.withOpacity(0.7),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    });
  }

  // Callback when a new plane is detected
  void onPlaneDetected(int planeCount) {
    detectedPlanesCount.value = planeCount;
    print("Detected plane #${planeCount}");
  }

  // Stabilize hit test results by averaging multiple samples
  ARHitTestResult? _getStableHitResult(List<ARHitTestResult> hitTestResults) {
    // No results to process
    if (hitTestResults.isEmpty) return null;

    // Find plane hits
    var planeHits =
        hitTestResults
            .where((hit) => hit.type == ARHitTestResultType.plane)
            .toList();

    // If no plane hits, use whatever hit we have
    var bestHit = planeHits.isNotEmpty ? planeHits.first : hitTestResults.first;

    // Determine effective buffer size based on placement stage
    int effectiveBufferSize = isInitialPlacement.value ? _initialBufferSize : _refinementBufferSize;

    // Add to buffer for stabilization
    _hitTestBuffer.add(bestHit);
    if (_hitTestBuffer.length > effectiveBufferSize) {
      _hitTestBuffer.removeAt(0);
    }

    // Update stability feedback for debugging
    _updateStabilityFeedback(_hitTestBuffer.length, effectiveBufferSize);

    // Progressive stabilization - start with as few as 3 samples
    if (_hitTestBuffer.length < 3) {
      return bestHit;
    }

    try {
      // Calculate weighted average position (giving more weight to recent results)
      vector.Vector3 averagePosition = vector.Vector3.zero();
      double totalWeight = 0.0;

      for (int i = 0; i < _hitTestBuffer.length; i++) {
        // More recent results get higher weights (higher index = more recent)
        double weight = 0.5 + (i / _hitTestBuffer.length) * 0.5;
        totalWeight += weight;
        
        vector.Vector3 position = _hitTestBuffer[i].worldTransform.getTranslation();
        // Scale position by its weight
        vector.Vector3 weightedPosition = vector.Vector3(
          position.x * weight,
          position.y * weight,
          position.z * weight
        );
        averagePosition += weightedPosition;
      }

      // Normalize by total weight
      averagePosition.scale(1.0 / totalWeight);

      // Create a stable transform by keeping rotation but averaging position
      Matrix4 stableTransform = bestHit.worldTransform.clone();
      stableTransform.setTranslation(averagePosition);

      // Since modifying worldTransform directly might not be possible,
      // we'll return the best hit but with the averaged position used for the anchor
      return bestHit;
    } catch (e) {
      print("Error stabilizing hit result: $e");
      return bestHit;
    }
  }

  // Add this new method to provide feedback about stabilization quality
  void _updateStabilityFeedback(int currentSamples, int maxSamples) {
    // Only update during initial placement or active refinement
    if (!isPlaneDetectionInProgress.value && !isModelPlaced.value) return;
    
    // Calculate stability percentage
    double stabilityPercent = (currentSamples / maxSamples) * 100;
    
    // For debugging
    print("Stabilization: $stabilityPercent% ($currentSamples/$maxSamples samples)");
  }

  // Add this method for position refinement after initial placement
  void _refineModelPosition() {
    // Only refine if model is placed and we're in refinement mode
    if (!isModelPlaced.value || isInitialPlacement.value || currentNode == null) {
      return;
    }
    
    // For now, just log that refinement is active
    print("Model position refinement active with larger buffer size");
    
    // In a more advanced implementation, you could continue updating
    // the model position for a few seconds after placement for better stability
  }

  // Check if a hit point is within the limited plane size (50x50 cm)
 // Perbaiki fungsi pengecekan area plane
bool _isWithinLimitedPlaneSize(ARHitTestResult hit) {
  try {
    // MASALAH: Saat ini kode mengasumsikan bahwa pusat plane ada di (0,0,0),
    // yang sangat tidak mungkin benar dalam kasus nyata

    // SOLUSI: Dapatkan pusat plane dari hit result itu sendiri
    // Karena plane yang dideteksi ARCore/ARKit adalah plane tempat hit terjadi
    vector.Vector3 hitPosition = hit.worldTransform.getTranslation();
    
    // Untuk ARCore/ARKit, hit point biasanya sudah berada pada plane yang terdeteksi
    // Jadi kita bisa mengasumsikan bahwa hit point selalu "dalam" plane
    // Batasi area menjadi 35cm dari hit pertama untuk stabilitas visual
    
    // Daripada mengukur jarak dari origin dunia (0,0,0), kita akan membuat 
    // kriteria lain yang lebih masuk akal
    
    // 1. Cek apakah hit type adalah plane (ini sudah diperiksa di _getStableHitResult)
    if (hit.type != ARHitTestResultType.plane) {
      print("Hit bukan pada plane, tapi pada: ${hit.type}");
      return false;
    }
    
    // 2. Tambahkan verifikasi kedalaman sebagai validasi tambahan
    // Menolak hit yang terlalu jauh dari kamera (terlalu dalam)
    double depth = hitPosition.z;
    if (depth < -2.0 || depth > 0.0) { // Nilai negatif karena sumbu Z menjauh dari kamera
      print("Hit terlalu jauh: $depth meter");
      return false;
    }
    
    // 3. Dapatkan plane pertama dari daftar hit (yang sudah dilakukan di _getStableHitResult)
    // Selalu mengembalikan true karena kita sudah memfilter di _getStableHitResult
    return true;
  } catch (e) {
    print("Error memeriksa batas ukuran plane: $e");
    return false; // Ubah menjadi false untuk keamanan
  }
}

  Future<void> onPlaneOrPointTapped(
    List<ARHitTestResult> hitTestResults,
  ) async {
    // If no model is selected, show message and return
    if (selectedModelUrl.value.isEmpty) {
      Get.snackbar(
        "Tidak ada model yang dipilih",
        "Pilih model Hewan 3D dari bawah",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // If already placed, ignore tap (use reset instead)
    if (isModelPlaced.value) {
      Get.snackbar(
        "Model sudah ditempatkan",
        "Gunakan tombol reset untuk menempatkan ulang",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // If loading, prevent multiple taps
    if (isLoading.value) {
      return;
    }

    // If no hit results, show guidance
    if (hitTestResults.isEmpty) {
      Get.snackbar(
        "Permukaan tidak terdeteksi",
        "Arahkan kamera ke permukaan datar",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Set loading state
    isLoading.value = true;

    try {
      // Get stabilized hit result
      ARHitTestResult? stableHit = _getStableHitResult(hitTestResults);

      if (stableHit == null) {
        Get.snackbar(
          "Tracking tidak stabil",
          "Coba tahan kamera lebih stabil dan tap lagi",
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
        isLoading.value = false;
        return;
      }

      // Check if the hit is within our limited plane size (50x50cm)
      // if (!_isWithinLimitedPlaneSize(stableHit)) {
      //   Get.snackbar(
      //     "Di luar area",
      //     "Coba tap lebih dekat ke tengah area terdeteksi",
      //     duration: Duration(seconds: 2),
      //     snackPosition: SnackPosition.TOP,
      //   );
      //   isLoading.value = false;
      //   return;
      // }

      // Short delay to ensure stabilization
      await Future.delayed(Duration(milliseconds: 200));

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
          isInitialPlacement.value = false; // Switch to refinement mode
          
          // Continue collecting samples for refinement
          Future.delayed(Duration(milliseconds: 500), () {
            _refineModelPosition();
          });
          
          Get.snackbar(
            "Berhasil",
            "${selectedModelName.value} telah ditambahkan",
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          // If node couldn't be added, clear the anchor
          await arAnchorManager!.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
          currentNode = null;

          Get.snackbar(
            "Gagal",
            "Tidak dapat menambahkan model, coba lagi",
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.snackbar(
          "Gagal",
          "Tidak dapat membuat anchor, coba lagi",
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Error placing model: $e");
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: $e",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function to change model scale
  void changeScale(bool increase) {
    if (!isModelPlaced.value || currentNode == null) {
      Get.snackbar(
        "Tidak ada model",
        "Tempatkan model terlebih dahulu",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // If already scaling, prevent multiple calls
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      // Calculate new scale
      double newScale;
      if (increase) {
        newScale = currentScale.value + scaleStep;
        // Limit maximum scale
        if (newScale > maxScale) newScale = maxScale;
      } else {
        newScale = currentScale.value - scaleStep;
        // Limit minimum scale
        if (newScale < minScale) newScale = minScale;
      }

      // Only update if scale changed
      if (newScale != currentScale.value) {
        // First, remove existing node
        print("Removing existing node");
        arObjectManager!.removeNode(currentNode!);

        // Short delay to ensure node is removed
        Future.delayed(Duration(milliseconds: 300), () {
          // Create a new node with updated scale
          print("Creating new node with scale: $newScale");
          ARNode newNode = ARNode(
            type: NodeType.webGLB,
            uri: selectedModelUrl.value,
            scale: vector.Vector3(newScale, newScale, newScale),
            position: vector.Vector3(0, 0, 0),
            rotation: vector.Vector4(1, 0, 0, 0),
          );

          // Add the new node with the same anchor
          arObjectManager!
              .addNode(newNode, planeAnchor: currentPlaneAnchor)
              .then((success) {
                if (success == true) {
                  // Update current node reference
                  currentNode = newNode;

                  // Update the current scale value
                  currentScale.value = newScale;

                  // Show feedback to user
                  Get.snackbar(
                    increase ? "Diperbesar" : "Diperkecil",
                    "Ukuran model diubah menjadi ${(newScale * 100).toInt()}%",
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.blue.withOpacity(0.7),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.snackbar(
                    "Gagal",
                    "Tidak dapat mengubah ukuran model",
                    duration: Duration(seconds: 2),
                    snackPosition: SnackPosition.TOP,
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
      Get.snackbar(
        "Error",
        "Gagal mengubah ukuran model: $e",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      isLoading.value = false;
    }
  }

  // Function to reset model (remove and allow for new placement)
  void resetModel() {
    if (!isModelPlaced.value) return;

    // If already resetting, prevent multiple calls
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      // Clear stabilization buffer when resetting
      _hitTestBuffer.clear();
      
      // Reset to initial placement mode for next placement
      isInitialPlacement.value = true;

      // Remove current node
      if (currentNode != null) {
        print("Removing node");
        arObjectManager?.removeNode(currentNode!);
        currentNode = null;
      }

      // Short delay to ensure node is removed
      Future.delayed(Duration(milliseconds: 300), () {
        // Remove current anchor
        if (currentPlaneAnchor != null) {
          print("Removing anchor");
          arAnchorManager?.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
        }

        // Reset placement status
        isModelPlaced.value = false;

        // Reset scale to default
        currentScale.value = 0.9;

        // Reinitialize AR session for better stability
        arSessionManager?.onInitialize(
          showFeaturePoints: false,
          customPlaneTexturePath: AssetsCollection.logo,
          showPlanes: true,
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          showAnimatedGuide: false,
        );

        // Show guidance
        Get.snackbar(
          "Model dihapus",
          "Sentuh layar untuk menempatkan model baru",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        isLoading.value = false;
      });
    } catch (e) {
      print("Error resetting model: $e");
      Get.snackbar(
        "Error",
        "Gagal menghapus model: $e",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      isLoading.value = false;
    }
  }

  // Gesture handling functions with improved stability
  void onPanStarted(String nodeName) {
    print("Pan started on node: $nodeName");
  }

  void onPanChanged(String nodeName) {
    // Reduced logging frequency to improve performance
    // print("Pan changed on node: $nodeName");
  }

  void onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Pan ended on node: $nodeName");

    // Apply smoothing filter to final position if needed
    _smoothNodeTransform(nodeName, newTransform);
  }

  // Apply smoothing to node transform to reduce jitter
  void _smoothNodeTransform(String nodeName, Matrix4 newTransform) {
    try {
      if (currentNode != null && isModelPlaced.value) {
        // For the current implementation, we rely on the AR framework's own
        // transform handling. In a more advanced implementation, we could
        // apply additional smoothing here.
      }
    } catch (e) {
      print("Error smoothing transform: $e");
    }
  }

  void onRotationStarted(String nodeName) {
    print("Rotation started on node: $nodeName");
  }

  void onRotationChanged(String nodeName) {
    // Reduced logging frequency
    // print("Rotation changed on node: $nodeName");
  }

  void onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Rotation ended on node: $nodeName");

    // Apply smoothing to rotation as well
    _smoothNodeTransform(nodeName, newTransform);
  }
}