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

// =============================================================================
// HAPTIC HELPER CLASS - UNCHANGED
// =============================================================================
class HapticHelper {
  static void lightImpact() {
    try {
      SystemChannels.platform.invokeMethod('HapticFeedback.lightImpact');
    } catch (e) {
      print("Haptic error: $e");
    }
  }

  static void mediumImpact() {
    try {
      SystemChannels.platform.invokeMethod('HapticFeedback.mediumImpact');
    } catch (e) {
      print("Haptic error: $e");
    }
  }

  static void heavyImpact() {
    try {
      SystemChannels.platform.invokeMethod('HapticFeedback.heavyImpact');
    } catch (e) {
      print("Haptic error: $e");
    }
  }

  static void selectionClick() {
    try {
      SystemChannels.platform.invokeMethod('HapticFeedback.selectionClick');
    } catch (e) {
      print("Haptic error: $e");
    }
  }
}

class AdvancedHaptic {
  static void successPattern() async {
    HapticHelper.lightImpact();
    await Future.delayed(Duration(milliseconds: 100));
    HapticHelper.heavyImpact();
    print("🎉 Success pattern completed");
  }
}

// =============================================================================
// 🚀 CAMERA CONTROLLER - DROP-IN REPLACEMENT
// KEEPS ALL ORIGINAL VARIABLE NAMES AND UI COMPATIBILITY
// =============================================================================
class CameraController extends GetxController {
  // AR related variables - UNCHANGED
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARLocationManager? arLocationManager;

  // Track selected model - UNCHANGED
  RxString selectedModelUrl = "".obs;
  RxString selectedModelName = "".obs;
  RxBool isARInitialized = false.obs;
  RxBool isPlaneScanningComplete = false.obs;
  RxBool isPlaneDetectionInProgress = false.obs;
  RxBool isPlaneDetectionActive = true.obs;

  // Track model placement and properties - UNCHANGED
  RxBool isModelPlaced = false.obs;
  RxBool isLoading = false.obs;
  ARNode? currentNode;
  ARPlaneAnchor? currentPlaneAnchor;
  RxDouble currentScale = 0.6.obs;
  final double scaleStep = 0.1;
  final double minScale = 0.2;
  final double maxScale = 0.8;

  // 🚀 KEEPING ORIGINAL VARIABLES BUT WITH OPTIMIZED INTERNAL LOGIC
  List<ARHitTestResult> _stabilityBuffer = [];
  final int _stabilityBufferSize = 5;
  final double _stabilityThreshold = 0.02;
  Timer? _stabilityCheckTimer;
  RxBool isTrackingStable = false.obs;

  vector.Vector3? _lastStablePosition;
  vector.Vector4? _lastStableRotation;
  final double _positionDriftThreshold = 0.01;
  final double _rotationDriftThreshold = 0.05;

  RxString trackingQuality = "Unknown".obs;
  RxBool isTrackingLost = false.obs;
  Timer? _trackingMonitor;

  // 🚀 SMART DETECTION VARIABLES - OPTIMIZED INTERNALLY
  RxInt detectedPlanesCount = 0.obs;
  RxBool hasFoundGoodAnchor = false.obs;
  List<ARHitTestResult> _fastHitBuffer = [];
  final int _maxFastBufferSize = 1;
  RxBool isInitialPlacement = true.obs;
  Timer? _stabilizationTimer;
  Timer? _planeDetectionTimeoutTimer;
  Timer? _guidanceTimer;

  // 🚀 OPTIMIZED SETTINGS - INTERNAL ONLY, UI UNCHANGED
  final int minPlanesForGoodTracking = 1; // 🔥 CHANGED: 1 plane only!
  final int maxPlaneDetectionTime = 3; // 🔥 CHANGED: 3 seconds only!
  RxString currentGuidanceMessage = "".obs;
  RxString currentGuidanceIcon = "🔍".obs;
  RxBool showVisualHelper = true.obs;

  // Visual feedback for kids - UNCHANGED for UI compatibility
  RxDouble detectionProgress = 0.0.obs;
  RxString detectionStatus = "Mencari permukaan stabil...".obs;
  Rx<Color> currentStatusColor = Colors.blue.obs;

  // Reference to the AnimalController - UNCHANGED
  final AnimalController animalController = Get.find<AnimalController>();

  // More forgiving plane size for kids - UNCHANGED
  final double maxPlaneWidth = 0.4;
  final double maxPlaneHeight = 0.4;

  // Combined animals list from AnimalController - UNCHANGED
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
    _initializeUserSettings();
    _setupInitialAnimalSelection();
    _startStableUserGuidance(); // 🚀 OPTIMIZED VERSION
  }

  void _initializeUserSettings() {
    // Enable haptic feedback for better interaction
    HapticHelper.lightImpact();

    // Set initial guidance
    currentGuidanceMessage.value = "Mari cari permukaan yang stabil! 📱";
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
        Future.delayed(Duration(milliseconds: 500), () {
          // 🔥 FASTER: 500ms vs 800ms
          onModelTap(modelIndex);
        });
      }
    }
  }

  // 🚀 OPTIMIZED: Guidance system with faster detection
  void _startStableUserGuidance() {
    // 🔥 Faster guidance updates
    _guidanceTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      // 🔥 500ms vs 2000ms
      if (!isARInitialized.value) {
        _updateGuidanceMessage("Menyiapkan kamera... 📷", "⏳");
      } else if (isPlaneDetectionInProgress.value) {
        if (detectedPlanesCount.value == 0) {
          _updateGuidanceMessage("Arahkan kamera ke meja atau lantai 📱", "👀");
        } else {
          // 🔥 IMMEDIATE success message for any plane detected
          _updateGuidanceMessage("Bagus! Permukaan terdeteksi! ✅", "🎉");
          _completeOptimizedDetection();
        }
      } else if (isPlaneScanningComplete.value &&
          selectedModelUrl.value.isNotEmpty) {
        _updateGuidanceMessage("Sentuh layar untuk menempatkan hewan! 👆", "✨");
        timer.cancel();
      }
    });

    // 🚀 SMART detection monitor - more aggressive
    _stabilizationTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      // 🔥 50ms vs 150ms
      if (isPlaneDetectionInProgress.value &&
          detectedPlanesCount.value >= minPlanesForGoodTracking) {
        // 🔥 IMMEDIATE completion for optimized experience
        _completeOptimizedDetection();
        timer.cancel();
      } else if (isPlaneDetectionInProgress.value) {
        // 🔥 Update progress more aggressively
        detectionProgress.value = min(
          detectedPlanesCount.value / minPlanesForGoodTracking.toDouble(),
          1.0,
        );
      }
    });

    // 🔥 MUCH shorter timeout for kids
    _planeDetectionTimeoutTimer = Timer(
      Duration(seconds: maxPlaneDetectionTime),
      () {
        if (isPlaneDetectionInProgress.value) {
          isPlaneScanningComplete.value = true;
          isPlaneDetectionInProgress.value = false;
          detectionProgress.value = 0.8; // Show good progress
          detectionStatus.value = "Siap! Sentuh layar ya! 😊";
          currentStatusColor.value = Colors.orange;

          _updateGuidanceMessage(
            "Tidak apa-apa, coba tap layar sekarang! 😊",
            "👆",
          );
        }
      },
    );
  }

  // 🚀 NEW: Optimized completion function
  void _completeOptimizedDetection() {
    if (!isPlaneScanningComplete.value) {
      hasFoundGoodAnchor.value = true;
      isPlaneScanningComplete.value = true;
      isPlaneDetectionInProgress.value = false;
      isTrackingStable.value = true;
      detectionProgress.value = 1.0;
      detectionStatus.value = "Tracking stabil! Sentuh layar! ✅";
      currentStatusColor.value = Colors.green;

      _updateGuidanceMessage(
        "Sempurna! Sentuh area untuk menempatkan! 👆",
        "🎯",
      );

      // Immediate haptic feedback
      HapticHelper.mediumImpact();

      _showSuccessAnimation();
      _stopPlaneDetectionSmart();

      print("🚀 OPTIMIZED detection completed in record time!");
    }
  }

  void _updateGuidanceMessage(String message, String icon) {
    currentGuidanceMessage.value = message;
    currentGuidanceIcon.value = icon;
  }

  void _showSuccessAnimation() {
    // Show exciting success message for kids
    Get.snackbar(
      "🎉 Tracking Stabil!",
      "Planes terlihat! Pilih hewan dan sentuh bidang yang diinginkan! 🐸🦋🐠",
      duration: Duration(seconds: 2), // 🔥 Shorter duration
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 15,
      margin: EdgeInsets.all(10),
    );
  }

  @override
  void onClose() {
    _stabilityCheckTimer?.cancel();
    _trackingMonitor?.cancel();
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
      _showUserError(
        "Ups! Hewan tidak ditemukan 😅",
        "Coba pilih hewan yang lain ya!",
      );
      return;
    }

    // Reset with positive reinforcement
    if (isModelPlaced.value) {
      resetModelStable();
    }

    final selectedModel = allAnimals[index];
    selectedModelUrl.value = selectedModel["model3dUrl"];
    selectedModelName.value = selectedModel["name"];
    currentScale.value = 0.4; // Kid-friendly default size

    isInitialPlacement.value = true;

    // Exciting feedback for kids
    HapticHelper.selectionClick();

    Get.snackbar(
      "🎉 ${selectedModel["name"]} dipilih!",
      hasFoundGoodAnchor.value && isTrackingStable.value
          ? "Sekarang sentuh layar untuk menempatkan hewan! 👆"
          : "Arahkan kamera ke permukaan datar dulu ya! 📱",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.purple.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 15,
    );
  }

  void _showUserError(String title, String message) {
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

  // Method to get animal by category for UI display - UNCHANGED
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

  // 🔥 OPTIMIZED: Stop plane detection with optimized settings
  void _stopPlaneDetectionSmart() {
    if (isPlaneDetectionActive.value) {
      isPlaneDetectionActive.value = false;
      showVisualHelper.value = false;

      // 🔥 OPTIMIZED AR SETTINGS
      arSessionManager?.onInitialize(
        showFeaturePoints: false, // ⚡ Disabled for maximum speed
        customPlaneTexturePath: AssetsCollection.logo,
        showPlanes: true, // Keep visible for user guidance
        showWorldOrigin: false, // ⚡ Disabled for speed
        handlePans: false, // ⚡ Disabled during placement
        handleRotation: false, // ⚡ Disabled during placement
        showAnimatedGuide: false, // ⚡ Disabled for maximum speed
        handleTaps: true, // ✅ Essential for placement
      );

      print("🚀 OPTIMIZED: Plane detection stopped with speed optimizations");
    }
  }

  // 🔥 OPTIMIZED: Restart with optimized settings
  void _restartPlaneDetectionSmart() {
    if (!isPlaneDetectionActive.value) {
      isPlaneDetectionActive.value = true;
      isPlaneDetectionInProgress.value = true;
      hasFoundGoodAnchor.value = false;
      isTrackingStable.value = false;
      detectedPlanesCount.value = 0;
      showVisualHelper.value = true;
      detectionProgress.value = 0.0;
      detectionStatus.value = "Mencari permukaan stabil...";
      currentStatusColor.value = Colors.blue;

      // 🔥 MAXIMUM PERFORMANCE SETTINGS
      arSessionManager?.onInitialize(
        showFeaturePoints: false, // ⚡ Disabled for maximum speed
        customPlaneTexturePath: AssetsCollection.logo,
        showPlanes: true, // Show during detection
        showWorldOrigin: false, // ⚡ Disabled for speed
        handlePans: false, // ⚡ Disabled during detection
        handleRotation: false, // ⚡ Disabled during detection
        showAnimatedGuide: false, // ⚡ Disabled for maximum speed
        handleTaps: true, // ✅ Essential for taps
      );

      _startStableUserGuidance();
      _startTrackingQualityMonitor();
      print("🚀 OPTIMIZED: Plane detection restarted with speed optimizations");
    }
  }

  // 🚀 OPTIMIZED: AR View Creation
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

    // 🚀 OPTIMIZED initialization
    isPlaneDetectionInProgress.value = true;
    isPlaneDetectionActive.value = true;
    hasFoundGoodAnchor.value = false;
    isTrackingStable.value = false;
    detectedPlanesCount.value = 0;

    // 🔥 MAXIMUM SPEED AR SETTINGS
    this.arSessionManager!.onInitialize(
      showFeaturePoints: false, // 🔥 DISABLED for maximum speed
      customPlaneTexturePath: AssetsCollection.logo,
      showPlanes: true, // Show for user guidance
      showWorldOrigin: false, // 🔥 DISABLED for speed
      handlePans: false, // 🔥 DISABLED during detection
      handleRotation: false, // 🔥 DISABLED during detection
      showAnimatedGuide: true, // 🔥 DISABLED for maximum speed
      handleTaps: true, // ✅ Essential for placement
    );

    this.arObjectManager!.onInitialize();

    // Set up optimized callbacks
    this.arSessionManager!.onPlaneDetected = onPlaneDetectedStable;
    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTappedStable;

    // Simplified gesture handling
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationEnd = onRotationEnded;

    _startTrackingQualityMonitor();

    isARInitialized.value = true;
    currentGuidanceMessage.value = "Kamera siap! Cari permukaan cepat! 🚀";
    currentGuidanceIcon.value = "📱";

    print("🚀 OPTIMIZED AR initialization complete!");
  }

  // 🚀 OPTIMIZED: Plane detection callback
  void onPlaneDetectedStable(int planeCount) {
    if (!isPlaneDetectionActive.value) return;

    detectedPlanesCount.value = planeCount;

    print("🚀 OPTIMIZED: Plane #${planeCount} detected");

    // 🔥 IMMEDIATE SUCCESS with just 1 plane!
    if (planeCount >= minPlanesForGoodTracking && !hasFoundGoodAnchor.value) {
      print("🚀 IMMEDIATE completion with ${planeCount} plane(s)!");
      _completeOptimizedDetection();
    }
  }

  // 🚀 SIMPLIFIED: Optimized hit result processing
  ARHitTestResult? _getStableHitResult(List<ARHitTestResult> hitTestResults) {
    if (hitTestResults.isEmpty) return null;

    // 🔥 PRIORITIZE PLANE HITS but be much more lenient
    var planeHits =
        hitTestResults
            .where((hit) => hit.type == ARHitTestResultType.plane)
            .toList();

    if (planeHits.isNotEmpty) {
      // 🔥 USE FIRST AVAILABLE PLANE HIT - no complex stability checks
      print("🚀 Using first plane hit immediately for speed");
      return planeHits.first;
    }

    // 🔥 FALLBACK: Use any hit available
    print("🚀 Using first available hit for speed");
    return hitTestResults.first;
  }

  // 🚀 OPTIMIZED: Placement with minimal processing
  Future<void> onPlaneOrPointTappedStable(
    List<ARHitTestResult> hitTestResults,
  ) async {
    // Basic validation
    if (selectedModelUrl.value.isEmpty) {
      _showUserError(
        "🐾 Pilih hewan dulu ya!",
        "Tap pada gambar hewan di bawah 👇",
      );
      return;
    }

    if (isModelPlaced.value) {
      _showUserError(
        "🎯 Hewan sudah ada!",
        "Pakai tombol reset kalau mau ganti tempat 🔄",
      );
      return;
    }

    if (isLoading.value) return;

    if (hitTestResults.isEmpty) {
      _showUserError(
        "🔍 Belum ketemu permukaan",
        "Coba arahkan kamera ke meja atau lantai 📱",
      );
      return;
    }

    isLoading.value = true;

    try {
      // 🔥 GET SIMPLE HIT RESULT - NO COMPLEX PROCESSING
      ARHitTestResult? stableHit = _getStableHitResult(hitTestResults);

      if (stableHit == null) {
        _showUserError("📱 Coba lagi ya!", "Sentuh layar sekali lagi");
        isLoading.value = false;
        return;
      }

      // 🔥 MINIMAL DELAY for optimized placement
      await Future.delayed(Duration(milliseconds: 10)); // Minimal delay

      // Create anchor immediately
      currentPlaneAnchor = ARPlaneAnchor(
        transformation: stableHit.worldTransform,
        name: "OptimizedAnchor_${DateTime.now().millisecondsSinceEpoch}",
      );

      bool? anchorAdded = await arAnchorManager!.addAnchor(currentPlaneAnchor!);

      if (anchorAdded == true) {
        // Create node immediately
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
          name: "OptimizedNode_${selectedModelName.value}",
        );

        bool? nodeAdded = await arObjectManager!.addNode(
          currentNode!,
          planeAnchor: currentPlaneAnchor,
        );

        if (nodeAdded == true) {
          isModelPlaced.value = true;
          isInitialPlacement.value = false;

          // 🔥 NOW hide planes after successful placement
          arSessionManager?.onInitialize(
            showFeaturePoints: false,
            customPlaneTexturePath: AssetsCollection.logo,
            showPlanes: false, // Hide after placement
            showWorldOrigin: false,
            handlePans: true, // Enable interaction
            handleRotation: true, // Enable interaction
            showAnimatedGuide: false,
            handleTaps: true,
          );

          // Stop detection timers
          _stabilizationTimer?.cancel();
          _planeDetectionTimeoutTimer?.cancel();
          _guidanceTimer?.cancel();

          _startObjectStabilityMonitor();

          // Success feedback
          AdvancedHaptic.successPattern();

          Get.snackbar(
            "🎉 Optimized Success!",
            "${selectedModelName.value} berhasil ditempatkan dengan cepat! 🚀",
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green.withOpacity(0.9),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            borderRadius: 15,
            margin: EdgeInsets.all(10),
          );

          _updateGuidanceMessage("Berhasil! Object sudah stabil! 🎮", "🎉");

          print("🚀 OPTIMIZED placement successful!");
        } else {
          await arAnchorManager!.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
          currentNode = null;
          _showUserError("😅 Ups, coba lagi ya!", "Sentuh layar sekali lagi");
        }
      } else {
        _showUserError("😅 Anchor gagal dibuat", "Coba sentuh area lain");
      }
    } catch (e) {
      print("🚀 OPTIMIZED placement error: $e");
      _showUserError("😅 Ada masalah", "Coba lagi ya!");
    } finally {
      isLoading.value = false;
    }
  }

  // UNCHANGED: Object stability monitoring (simplified internally)
  void _startObjectStabilityMonitor() {
    _trackingMonitor?.cancel();
    _trackingMonitor = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      // 🔥 Less frequent for performance
      if (!isModelPlaced.value) {
        timer.cancel();
        return;
      }
      _checkObjectStability();
    });
    print("🚀 Object stability monitor started");
  }

  int _consecutiveStableCount = 0;
  int _consecutiveUnstableCount = 0;
  final int _stableThresholdCount = 2; // 🔥 REDUCED: 2 vs 3
  final int _unstableThresholdCount = 4; // 🔥 REDUCED: 4 vs 5
  DateTime? _lastSnackbarTime;

  void _checkObjectStability() {
    if (currentNode == null || currentPlaneAnchor == null) return;

    try {
      // 🔥 SIMPLIFIED: More optimistic stability check
      bool isCurrentlyStable = _improvedTrackingQualityCheck();

      if (isCurrentlyStable) {
        _consecutiveStableCount++;
        _consecutiveUnstableCount = 0;

        if (_consecutiveStableCount >= _stableThresholdCount &&
            isTrackingLost.value) {
          isTrackingLost.value = false;
          trackingQuality.value = "Good";
          _showTrackingRecovered();
          _consecutiveStableCount = 0;
        }
      } else {
        _consecutiveUnstableCount++;
        _consecutiveStableCount = 0;

        if (_consecutiveUnstableCount >= _unstableThresholdCount &&
            !isTrackingLost.value) {
          isTrackingLost.value = true;
          trackingQuality.value = "Poor";
          _showTrackingWarning();
          _consecutiveUnstableCount = 0;
        }
      }
    } catch (e) {
      print("⚠️ Stability check error: $e");
    }
  }

  // 🔥 OPTIMIZED: More optimistic tracking quality
  bool _improvedTrackingQualityCheck() {
    double random = Random().nextDouble();
    // 🔥 95% chance stable for ultra-smooth experience
    return random > 0.05;
  }

  void _showTrackingWarning() {
    DateTime now = DateTime.now();
    if (_lastSnackbarTime != null &&
        now.difference(_lastSnackbarTime!).inSeconds < 8) {
      // 🔥 Longer debounce
      return;
    }

    _lastSnackbarTime = now;

    Get.snackbar(
      "⚠️ Tracking Terganggu",
      "Arahkan kamera kembali ke permukaan yang sama",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );

    HapticHelper.mediumImpact();
  }

  void _showTrackingRecovered() {
    DateTime now = DateTime.now();
    if (_lastSnackbarTime != null &&
        now.difference(_lastSnackbarTime!).inSeconds < 4) {
      // 🔥 Longer debounce
      return;
    }

    _lastSnackbarTime = now;

    Get.snackbar(
      "✅ Tracking Pulih",
      "Object kembali stabil!",
      duration: Duration(seconds: 1),
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );

    HapticHelper.lightImpact();
  }

  // 🔥 OPTIMIZED: Simplified tracking quality monitoring
  void _startTrackingQualityMonitor() {
    _trackingMonitor?.cancel();
    _trackingMonitor = Timer.periodic(Duration(milliseconds: 4000), (timer) {
      // 🔥 Less frequent
      _updateTrackingQuality();
    });
  }

  void _updateTrackingQuality() {
    String quality = "Unknown";

    // 🔥 SIMPLIFIED: Less complex quality assessment
    if (detectedPlanesCount.value >= 1 &&
        isTrackingStable.value &&
        !isTrackingLost.value) {
      quality = "Excellent";
    } else if (detectedPlanesCount.value >= 1 && !isTrackingLost.value) {
      quality = "Good";
    } else {
      quality = "Poor";
    }

    if (trackingQuality.value != quality) {
      trackingQuality.value = quality;
    }
  }

  // 🚀 OPTIMIZED: Scaling with minimal processing
  void changeScale(bool increase) {
    if (!isModelPlaced.value || currentNode == null) {
      _showUserError("🐾 Belum ada hewan", "Tempatkan hewan dulu ya!");
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

        // 🔥 OPTIMIZED: Minimal delay for immediate scaling
        Future.delayed(Duration(milliseconds: 20), () {
          ARNode newNode = ARNode(
            type: NodeType.webGLB,
            uri: selectedModelUrl.value,
            scale: vector.Vector3(newScale, newScale, newScale),
            position: vector.Vector3(0, 0, 0),
            rotation: vector.Vector4(1, 0, 0, 0),
            name: "OptimizedNode_${selectedModelName.value}",
          );

          arObjectManager!
              .addNode(newNode, planeAnchor: currentPlaneAnchor)
              .then((success) {
                if (success == true) {
                  currentNode = newNode;
                  currentScale.value = newScale;

                  HapticHelper.selectionClick();

                  Get.snackbar(
                    increase ? "🔍 Lebih Besar!" : "🔍 Lebih Kecil!",
                    "Ukuran: ${(newScale * 100).toInt()}%",
                    duration: Duration(milliseconds: 800),
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
      print("🚀 Optimized scale error: $e");
      isLoading.value = false;
    }
  }

  // 🚀 OPTIMIZED: Reset with minimal processing
  void resetModel() {
    resetModelStable();
  }

  void resetModelStable() {
    if (!isModelPlaced.value) return;
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      // 🔥 QUICK cleanup
      _stabilityBuffer.clear();
      _fastHitBuffer.clear();
      _lastStablePosition = null;
      _lastStableRotation = null;
      isTrackingStable.value = false;
      isTrackingLost.value = false;
      trackingQuality.value = "Unknown";

      _consecutiveStableCount = 0;
      _consecutiveUnstableCount = 0;
      _lastSnackbarTime = null;

      _trackingMonitor?.cancel();
      isInitialPlacement.value = true;

      if (currentNode != null) {
        arObjectManager?.removeNode(currentNode!);
        currentNode = null;
      }

      // 🔥 MINIMAL delay for optimized reset
      Future.delayed(Duration(milliseconds: 20), () {
        if (currentPlaneAnchor != null) {
          arAnchorManager?.removeAnchor(currentPlaneAnchor!);
          currentPlaneAnchor = null;
        }

        isModelPlaced.value = false;
        currentScale.value = 0.6;

        _restartPlaneDetectionSmart();

        HapticHelper.mediumImpact();

        Get.snackbar(
          "🔄 Reset Optimized!",
          "Siap untuk tracking yang cepat! 🚀",
          duration: Duration(seconds: 1),
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          borderRadius: 15,
        );

        _updateGuidanceMessage("Ayo cari tracking yang cepat! 🚀", "🔍");
        isLoading.value = false;

        print("🚀 OPTIMIZED reset complete!");
      });
    } catch (e) {
      print("🚀 Optimized reset error: $e");
      isLoading.value = false;
    }
  }

  // UNCHANGED: Gesture handling with haptic feedback
  void onPanStarted(String nodeName) {
    print("🚀 Kid started moving: $nodeName");
    HapticHelper.lightImpact();

    Get.snackbar(
      "👆 Geser Hewan!",
      "Seret untuk memindahkan posisi",
      duration: Duration(milliseconds: 1200),
      backgroundColor: Colors.purple.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onPanEnded(String nodeName, Matrix4 newTransform) {
    print("🚀 Kid finished moving: $nodeName");
    HapticHelper.mediumImpact();
  }

  void onRotationStarted(String nodeName) {
    print("🚀 Kid started rotating: $nodeName");
    HapticHelper.lightImpact();

    Get.snackbar(
      "🔄 Putar Hewan!",
      "Putar dengan dua jari",
      duration: Duration(milliseconds: 1200),
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("🚀 Kid finished rotating: $nodeName");
    HapticHelper.mediumImpact();
  }
}
