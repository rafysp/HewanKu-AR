import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class KidFriendlyARController extends GetxController {
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
  RxBool isPlaneDetectionActive = true.obs;

  // Track model placement and properties
  RxBool isModelPlaced = false.obs;
  RxBool isLoading = false.obs;
  ARNode? currentNode;
  ARPlaneAnchor? currentPlaneAnchor;
  RxDouble currentScale = 0.4.obs; // Smaller default for kids
  final double scaleStep = 0.1; // Bigger steps for easier control
  final double minScale = 0.2; // Larger minimum for visibility
  final double maxScale = 0.8; // Smaller maximum to avoid overwhelming

  // Kid-friendly tracking optimization
  RxInt detectedPlanesCount = 0.obs;
  RxBool hasFoundGoodAnchor = false.obs;
  List<ARHitTestResult> _hitTestBuffer = [];
  final int _initialBufferSize = 2; // Very fast initial placement
  final int _refinementBufferSize = 3; // Quick refinement
  RxBool isInitialPlacement = true.obs;
  Timer? _stabilizationTimer;
  Timer? _planeDetectionTimeoutTimer;
  Timer? _guidanceTimer;

  // Kid-friendly performance variables
  final int minPlanesForGoodTracking = 1; // Just need 1 plane for simplicity
  final int maxPlaneDetectionTime = 8; // Longer timeout for patience
  RxString currentGuidanceMessage = "".obs;
  RxString currentGuidanceIcon = "🔍".obs;
  RxBool showVisualHelper = true.obs;

  // Visual feedback for kids
  RxDouble detectionProgress = 0.0.obs;
  RxString detectionStatus = "Mencari permukaan...".obs;
  Rx<Color> currentStatusColor = Colors.blue.obs;

  // Reference to the AnimalController
  final AnimalController animalController = Get.find<AnimalController>();

  // More forgiving plane size for kids
  final double maxPlaneWidth = 0.4; // Slightly larger area
  final double maxPlaneHeight = 0.4;

  // Combined animals list from AnimalController
  List<Map<String, dynamic>> get allAnimals {
    List<Map<String, dynamic>> combined = [];
    combined.addAll(animalController.vertebrateAnimals);
    combined.addAll(animalController.invertebrateAnimals);
    return combined;
  }

  List<Map<String, dynamic>> get models3dList => allAnimals;

  @override
  void onInit() {
    super.onInit();
    _initializeKidFriendlySettings();
    _setupInitialAnimalSelection();
    _startKidFriendlyGuidance();
  }

  void _initializeKidFriendlySettings() {
    // Enable haptic feedback for better interaction
    SystemChannels.platform.invokeMethod('HapticFeedback.lightImpact');
    
    // Set initial guidance
    currentGuidanceMessage.value = "Mari cari permukaan datar! 📱";
    currentGuidanceIcon.value = "🔍";
  }

  void _setupInitialAnimalSelection() {
    // Auto-select animal if coming from detail page
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final animal = Get.arguments as Map<String, dynamic>;
      final modelIndex = allAnimals.indexWhere(
        (model) => model["name"] == animal["name"],
      );

      if (modelIndex != -1) {
        Future.delayed(Duration(milliseconds: 800), () {
          onModelTap(modelIndex);
        });
      }
    }
  }

  void _startKidFriendlyGuidance() {
    // Progressive guidance system for kids
    _guidanceTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!isARInitialized.value) {
        _updateGuidanceMessage("Menyiapkan kamera... 📷", "⏳");
      } else if (isPlaneDetectionInProgress.value) {
        if (detectedPlanesCount.value == 0) {
          _updateGuidanceMessage("Arahkan kamera ke meja atau lantai 📱", "👀");
        } else {
          _updateGuidanceMessage("Bagus! Terus gerakkan kamera perlahan 👍", "🎯");
        }
      } else if (isPlaneScanningComplete.value && selectedModelUrl.value.isNotEmpty) {
        _updateGuidanceMessage("Sentuh layar untuk menempatkan hewan! 👆", "✨");
        timer.cancel();
      }
    });

    // Quick plane detection monitor for kids
    _stabilizationTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (isPlaneDetectionInProgress.value && detectedPlanesCount.value >= minPlanesForGoodTracking) {
        hasFoundGoodAnchor.value = true;
        isPlaneScanningComplete.value = true;
        isPlaneDetectionInProgress.value = false;
        detectionProgress.value = 1.0;
        detectionStatus.value = "Permukaan ditemukan! ✅";
        currentStatusColor.value = Colors.green;
        
        // Haptic feedback for success
        SystemChannels.platform.invokeMethod('HapticFeedback.mediumImpact');
        
        timer.cancel();
        _showSuccessAnimation();
      } else if (isPlaneDetectionInProgress.value) {
        // Update progress gradually for visual feedback
        detectionProgress.value = min(detectedPlanesCount.value / 3.0, 0.8);
      }
    });

    // Kid-friendly timeout
    _planeDetectionTimeoutTimer = Timer(Duration(seconds: maxPlaneDetectionTime), () {
      if (isPlaneDetectionInProgress.value) {
        isPlaneScanningComplete.value = true;
        isPlaneDetectionInProgress.value = false;
        detectionProgress.value = 0.6;
        detectionStatus.value = "Coba sentuh layar ya! 😊";
        currentStatusColor.value = Colors.orange;
        
        _updateGuidanceMessage("Tidak apa-apa, coba tap layar sekarang! 😊", "👆");
      }
    });
  }

  void _updateGuidanceMessage(String message, String icon) {
    currentGuidanceMessage.value = message;
    currentGuidanceIcon.value = icon;
  }

  void _showSuccessAnimation() {
    // Show exciting success message for kids
    Get.snackbar(
      "🎉 Berhasil!",
      "Sekarang pilih hewan dan sentuh layar! 🐸🦋🐠",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 15,
      margin: EdgeInsets.all(10),
    );
  }

  @override
  void onClose() {
    _stabilizationTimer?.cancel();
    _planeDetectionTimeoutTimer?.cancel();
    _guidanceTimer?.cancel();
    arSessionManager?.dispose();
    super.onClose();
  }

  void onBackPressed() {
    Get.back();
  }

  void onModelTap(int index) {
    // Enhanced validation with kid-friendly messages
    if (index < 0 || index >= allAnimals.length) {
      _showKidFriendlyError("Ups! Hewan tidak ditemukan 😅", "Coba pilih hewan yang lain ya!");
      return;
    }

    // Reset with positive reinforcement
    if (isModelPlaced.value) {
      resetModel();
    }

    final selectedModel = allAnimals[index];
    selectedModelUrl.value = selectedModel["model3dUrl"];
    selectedModelName.value = selectedModel["name"];
    currentScale.value = 0.4; // Kid-friendly default size

    isInitialPlacement.value = true;

    // Exciting feedback for kids
    SystemChannels.platform.invokeMethod('HapticFeedback.selectionClick');
    
    Get.snackbar(
      "🎉 ${selectedModel["name"]} dipilih!",
      hasFoundGoodAnchor.value
          ? "Sekarang sentuh layar untuk menempatkan hewan! 👆"
          : "Arahkan kamera ke permukaan datar dulu ya! 📱",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.purple.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 15,
    );
  }

  void _showKidFriendlyError(String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 15,
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

  String getCategoryName(int categoryIndex) {
    switch (categoryIndex) {
      case 0:
        return "🦴 Vertebrata";
      case 1:
        return "🐛 Invertebrata";
      default:
        return "🌟 Semua Hewan";
    }
  }

  // Simplified plane detection stop/start for kids
  void _stopPlaneDetection() {
    if (isPlaneDetectionActive.value) {
      isPlaneDetectionActive.value = false;
      showVisualHelper.value = false;
      
      arSessionManager?.onInitialize(
        showFeaturePoints: false,
        customPlaneTexturePath: AssetsCollection.logo,
        showPlanes: false, // Hide plane visualization for cleaner view
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
        showAnimatedGuide: false,
        handleTaps: true,
      );
      
      print("Plane detection stopped for kid-friendly mode");
    }
  }

  void _restartPlaneDetection() {
    if (!isPlaneDetectionActive.value) {
      isPlaneDetectionActive.value = true;
      isPlaneDetectionInProgress.value = true;
      hasFoundGoodAnchor.value = false;
      detectedPlanesCount.value = 0;
      showVisualHelper.value = true;
      detectionProgress.value = 0.0;
      detectionStatus.value = "Mencari permukaan...";
      currentStatusColor.value = Colors.blue;
      
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
      
      _startKidFriendlyGuidance();
      print("Plane detection restarted for kids");
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

    // Kid-friendly AR initialization
    isPlaneDetectionInProgress.value = true;
    isPlaneDetectionActive.value = true;
    hasFoundGoodAnchor.value = false;
    detectedPlanesCount.value = 0;

    // Optimized settings for kids (simpler, more forgiving)
    this.arSessionManager!.onInitialize(
      showFeaturePoints: false, // Keep disabled for less confusion
      customPlaneTexturePath: AssetsCollection.logo,
      showPlanes: true,
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
      showAnimatedGuide: true, // Show guide to help kids
      handleTaps: true,
    );

    this.arObjectManager!.onInitialize();

    // Set up callbacks
    this.arSessionManager!.onPlaneDetected = onPlaneDetected;
    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;

    // Simplified gesture handling for kids
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationEnd = onRotationEnded;

    isARInitialized.value = true;
    currentGuidanceMessage.value = "Kamera siap! Cari permukaan datar 📱";
    currentGuidanceIcon.value = "📱";

    // Quick second initialization for stability
    Future.delayed(Duration(seconds: 1), () {
      if (isPlaneDetectionActive.value) {
        this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          customPlaneTexturePath: AssetsCollection.logo,
          showPlanes: true,
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          showAnimatedGuide: false, // Disable after initial help
          handleTaps: true,
        );
      }
    });
  }

  // Kid-friendly plane detection callback
  void onPlaneDetected(int planeCount) {
    if (!isPlaneDetectionActive.value) return;
    
    detectedPlanesCount.value = planeCount;
    
    print("Kid mode: Detected plane #${planeCount}");
    
    // Progressive encouragement for kids
    if (planeCount == 1) {
      _updateGuidanceMessage("Bagus! Satu permukaan ditemukan! 👍", "🎯");
      detectionStatus.value = "Permukaan terdeteksi...";
      currentStatusColor.value = Colors.green;
      
      // Light haptic feedback
      SystemChannels.platform.invokeMethod('HapticFeedback.lightImpact');
    }
  }

  // Super simplified hit result processing for kids
  ARHitTestResult? _getKidFriendlyHitResult(List<ARHitTestResult> hitTestResults) {
    if (hitTestResults.isEmpty) return null;

    // Just take the first good hit for simplicity
    var planeHits = hitTestResults
        .where((hit) => hit.type == ARHitTestResultType.plane)
        .toList();

    var bestHit = planeHits.isNotEmpty ? planeHits.first : hitTestResults.first;

    // Very minimal buffering for immediate response
    _hitTestBuffer.add(bestHit);
    if (_hitTestBuffer.length > 2) {
      _hitTestBuffer.removeAt(0);
    }

    // Accept placement immediately for better kid experience
    return bestHit;
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    // Kid-friendly validation messages
    if (selectedModelUrl.value.isEmpty) {
      _showKidFriendlyError(
        "🐾 Pilih hewan dulu ya!",
        "Tap pada gambar hewan di bawah 👇"
      );
      return;
    }

    if (isModelPlaced.value) {
      _showKidFriendlyError(
        "🎯 Hewan sudah ada!",
        "Pakai tombol reset kalau mau ganti tempat 🔄"
      );
      return;
    }

    if (isLoading.value) return;

    if (hitTestResults.isEmpty) {
      _showKidFriendlyError(
        "🔍 Belum ketemu permukaan",
        "Coba arahkan kamera ke meja atau lantai 📱"
      );
      return;
    }

    isLoading.value = true;

    try {
      // Kid-friendly hit processing
      ARHitTestResult? stableHit = _getKidFriendlyHitResult(hitTestResults);

      if (stableHit == null) {
        _showKidFriendlyError(
          "📱 Kamera perlu lebih stabil",
          "Pegang kamera dengan kedua tangan ya! 🙌"
        );
        isLoading.value = false;
        return;
      }

      // Very quick placement for instant gratification
      await Future.delayed(Duration(milliseconds: 50));

      // Create anchor
      currentPlaneAnchor = ARPlaneAnchor(transformation: stableHit.worldTransform);
      bool? anchorAdded = await arAnchorManager!.addAnchor(currentPlaneAnchor!);

      if (anchorAdded == true) {
        // Create kid-friendly sized model
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

        bool? nodeAdded = await arObjectManager!.addNode(
          currentNode!,
          planeAnchor: currentPlaneAnchor,
        );

        if (nodeAdded == true) {
          isModelPlaced.value = true;
          isInitialPlacement.value = false;
          
          _stopPlaneDetection();
          _stabilizationTimer?.cancel();
          _planeDetectionTimeoutTimer?.cancel();
          _guidanceTimer?.cancel();

          // Exciting success for kids!
          SystemChannels.platform.invokeMethod('HapticFeedback.heavyImpact');
          
          Get.snackbar(
            "🎉 Wah Keren!",
            "${selectedModelName.value} berhasil ditempatkan! Coba geser atau putar hewannya! 👏",
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green.withOpacity(0.9),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            borderRadius: 15,
            margin: EdgeInsets.all(10),
          );

          _updateGuidanceMessage("Berhasil! Sekarang bisa main dengan hewannya! 🎮", "🎉");
        } else {
          await arAnchorManager!.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
          currentNode = null;
          _showKidFriendlyError("😅 Ups, coba lagi ya!", "Sentuh layar sekali lagi");
        }
      } else {
        _showKidFriendlyError("😅 Belum berhasil", "Coba sentuh layar lagi");
      }
    } catch (e) {
      print("Kid-friendly error: $e");
      _showKidFriendlyError("😅 Ada masalah kecil", "Coba lagi ya!");
    } finally {
      isLoading.value = false;
    }
  }

  // Kid-friendly scaling with bigger steps
  void changeScale(bool increase) {
    if (!isModelPlaced.value || currentNode == null) {
      _showKidFriendlyError("🐾 Belum ada hewan", "Tempatkan hewan dulu ya!");
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

        Future.delayed(Duration(milliseconds: 150), () {
          ARNode newNode = ARNode(
            type: NodeType.webGLB,
            uri: selectedModelUrl.value,
            scale: vector.Vector3(newScale, newScale, newScale),
            position: vector.Vector3(0, 0, 0),
            rotation: vector.Vector4(1, 0, 0, 0),
          );

          arObjectManager!.addNode(newNode, planeAnchor: currentPlaneAnchor).then((success) {
            if (success == true) {
              currentNode = newNode;
              currentScale.value = newScale;

              // Fun feedback for kids
              SystemChannels.platform.invokeMethod('HapticFeedback.selectionClick');
              
              Get.snackbar(
                increase ? "🔍 Lebih Besar!" : "🔍 Lebih Kecil!",
                "Ukuran: ${(newScale * 100).toInt()}%",
                duration: Duration(milliseconds: 1000),
                backgroundColor: Colors.blue.withOpacity(0.8),
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                borderRadius: 15,
              );
            }
            isLoading.value = false;
          });
        });
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      print("Scale error: $e");
      isLoading.value = false;
    }
  }

  // Kid-friendly reset with encouraging message
  void resetModel() {
    if (!isModelPlaced.value) return;
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      _hitTestBuffer.clear();
      isInitialPlacement.value = true;

      if (currentNode != null) {
        arObjectManager?.removeNode(currentNode!);
        currentNode = null;
      }

      Future.delayed(Duration(milliseconds: 150), () {
        if (currentPlaneAnchor != null) {
          arAnchorManager?.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
        }

        isModelPlaced.value = false;
        currentScale.value = 0.4;
        
        _restartPlaneDetection();

        // Encouraging reset message
        Get.snackbar(
          "🔄 Siap Coba Lagi!",
          "Sekarang cari tempat baru untuk hewannya! 🎯",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          borderRadius: 15,
        );

        _updateGuidanceMessage("Ayo cari tempat baru! 📱", "🔍");
        isLoading.value = false;
      });
    } catch (e) {
      print("Reset error: $e");
      isLoading.value = false;
    }
  }

  // Simplified gesture handling for kids
  void onPanStarted(String nodeName) {
    print("Kid started moving: $nodeName");
    SystemChannels.platform.invokeMethod('HapticFeedback.lightImpact');
    
    Get.snackbar(
      "👆 Geser Hewan!",
      "Seret untuk memindahkan posisi",
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.purple.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Kid finished moving: $nodeName");
    SystemChannels.platform.invokeMethod('HapticFeedback.mediumImpact');
  }

  void onRotationStarted(String nodeName) {
    print("Kid started rotating: $nodeName");
    SystemChannels.platform.invokeMethod('HapticFeedback.lightImpact');
    
    Get.snackbar(
      "🔄 Putar Hewan!",
      "Putar dengan dua jari",
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Kid finished rotating: $nodeName");
    SystemChannels.platform.invokeMethod('HapticFeedback.mediumImpact');
  }
}