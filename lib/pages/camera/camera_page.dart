import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'camera_controller.dart';
import 'widgets/model_item.dart';

class KidFriendlyCameraPage extends StatelessWidget {
  const KidFriendlyCameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KidFriendlyARController());

    return Scaffold(
      body: Stack(
        children: [
          // AR View (full screen)
          ARView(
            onARViewCreated: controller.onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),

          // Main content with proper overflow handling
          SafeArea(
            child: Column(
              children: [
                // Top navigation with kid-friendly design
                _buildKidFriendlyTopBar(controller),

                // Flexible guidance system that adapts to available space
                Flexible(
                  flex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Kid-friendly guidance system with progress
                      _buildKidGuidanceSystem(controller),

                      // Success celebration overlay
                      _buildSuccessCelebration(controller),

                      // Kid-friendly loading indicator
                      _buildKidFriendlyLoading(controller),
                    ],
                  ),
                ),

                // Flexible spacer that adapts to content
                const Expanded(child: SizedBox()),

                // Kid-friendly control buttons - only show when model is placed
                _buildKidFriendlyControls(controller),

                // Fixed height bottom section for animal list
                _buildKidFriendlyModelList(controller),
              ],
            ),
          ),

          // Floating help button for kids
          _buildFloatingHelpButton(controller),
        ],
      ),
    );
  }

  Widget _buildKidFriendlyTopBar(KidFriendlyARController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button with emoji
          GestureDetector(
            onTap: () => controller.onBackPressed(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  SizedBox(width: 4),
                  Text("🏠", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

          const Spacer(),

          // AR status indicator for kids
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    controller.isARInitialized.value
                        ? Colors.green.withOpacity(0.9)
                        : Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.isARInitialized.value ? "📱 Siap!" : "⏳ Loading",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKidGuidanceSystem(KidFriendlyARController controller) {
    return Obx(() {
      // Show different guidance based on state
      if (controller.isPlaneDetectionInProgress.value) {
        return _buildPlaneDetectionGuidance(controller);
      } else if (controller.isPlaneScanningComplete.value &&
          controller.selectedModelUrl.value.isEmpty) {
        return _buildModelSelectionGuidance();
      } else if (controller.isPlaneScanningComplete.value &&
          controller.selectedModelUrl.value.isNotEmpty &&
          !controller.isModelPlaced.value) {
        return _buildPlacementGuidance(controller);
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildPlaneDetectionGuidance(KidFriendlyARController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.9),
            Colors.purple.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated icon
          const Text("🔍", style: TextStyle(fontSize: 28)),
          const SizedBox(height: 6),

          const Text(
            "Mencari Permukaan Datar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            "Arahkan kamera ke meja atau lantai\nGerakkan perlahan-lahan ya! 😊",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 10),

          // Kid-friendly progress bar
          Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Progress: ${(controller.detectedPlanesCount.value * 50).clamp(0, 100).toInt()}%",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "${controller.detectedPlanesCount.value}/2 ✨",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (controller.detectedPlanesCount.value / 2.0).clamp(
                    0.0,
                    1.0,
                  ),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.yellow,
                  ),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelectionGuidance() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withOpacity(0.9), Colors.teal.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Text("🎯", style: TextStyle(fontSize: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Bagus! Sekarang pilih hewan favorit kamu di bawah! 👇",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacementGuidance(KidFriendlyARController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.withOpacity(0.9), Colors.red.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text("👆", style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => Text(
                "Sentuh layar untuk menempatkan ${controller.selectedModelName.value}! ✨",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCelebration(KidFriendlyARController controller) {
    return Obx(
      () =>
          controller.isModelPlaced.value
              ? AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.9),
                      Colors.pink.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text("🎉", style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Keren! ${controller.selectedModelName.value} sudah muncul! Coba geser atau putar! 🎮",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _buildKidFriendlyControls(KidFriendlyARController controller) {
    return Obx(
      () =>
          controller.isModelPlaced.value
              ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildKidControlButton(
                      icon: Icons.remove_circle,
                      emoji: "🔍",
                      label: "Kecilkan",
                      color: Colors.red[400]!,
                      onTap: () => controller.changeScale(false),
                    ),
                    _buildKidControlButton(
                      icon: Icons.refresh,
                      emoji: "🔄",
                      label: "Ulang",
                      color: Colors.blue[400]!,
                      onTap: controller.resetModel,
                    ),
                    _buildKidControlButton(
                      icon: Icons.add_circle,
                      emoji: "🔍",
                      label: "Besarkan",
                      color: Colors.green[400]!,
                      onTap: () => controller.changeScale(true),
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _buildKidControlButton({
    required IconData icon,
    required String emoji,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
          minimumSize: const Size(80, 60),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKidFriendlyLoading(KidFriendlyARController controller) {
    return Obx(
      () =>
          !controller.isARInitialized.value
              ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.withOpacity(0.9),
                      Colors.blue.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("🚀", style: TextStyle(fontSize: 24)),
                    SizedBox(height: 12),
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Menyiapkan Kamera Ajaib...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Sebentar ya, hampir selesai! ✨",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _buildKidFriendlyModelList(KidFriendlyARController controller) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 110,
        maxHeight: 140, // Fixed maximum height to prevent overflow
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.grey[100]!.withOpacity(0.95),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Compact category header for kids
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text("🎯", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                const Text(
                  "Pilih Hewan Favorit:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  "${controller.models3dList.length} hewan",
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Model list with controlled height
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.models3dList.length,
              itemBuilder: (context, index) {
                final model = controller.models3dList[index];
                final isSelected =
                    controller.selectedModelUrl.value == model["model3dUrl"];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => controller.onModelTap(index),
                    child: _buildKidFriendlyModelItem(
                      model: model,
                      isSelected: isSelected,
                    ),
                  ),
                );
              },
            ),
          ),

          // Small bottom padding
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildKidFriendlyModelItem({
    required Map<String, dynamic> model,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70, // Slightly smaller width to fit more items
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? Colors.purple : Colors.transparent,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isSelected
                    ? Colors.purple.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
            blurRadius: isSelected ? 6 : 3,
            offset: Offset(0, isSelected ? 3 : 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple.withOpacity(0.1) : Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animal image with error handling
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    model["photoUrl"],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 20,
                          color: Colors.grey,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Animal name with better text handling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  model["name"],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.purple[700] : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Selection indicator
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: const Text("✅", style: TextStyle(fontSize: 10)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingHelpButton(KidFriendlyARController controller) {
    return Positioned(
      right: 20,
      top: MediaQuery.of(Get.context!).size.height * 0.4,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.orange.withOpacity(0.9),
        child: const Text("❓", style: TextStyle(fontSize: 18)),
        onPressed: () => _showKidHelpDialog(),
      ),
    );
  }

  void _showKidHelpDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("🤔 Butuh Bantuan?"),
        content: const Text(
          "1. 📱 Arahkan kamera ke meja atau lantai\n"
          "2. 🔍 Tunggu sampai permukaan terdeteksi\n"
          "3. 🎯 Pilih hewan favorit kamu\n"
          "4. 👆 Sentuh layar untuk menempatkan hewan\n"
          "5. 🎮 Geser atau putar hewannya!",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "😊 Mengerti!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
