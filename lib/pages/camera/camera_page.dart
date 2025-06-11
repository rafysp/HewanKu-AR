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
          
          // Safety area for top elements
          SafeArea(
            child: Column(
              children: [
                // Top navigation with kid-friendly design
                _buildKidFriendlyTopBar(controller),
                
                // Kid-friendly guidance system with progress
                _buildKidGuidanceSystem(controller),
                
                // Success celebration overlay
                _buildSuccessCelebration(controller),
                
                // Push everything else to the bottom
                const Spacer(),
                
                // Kid-friendly control buttons with bigger, colorful design
                _buildKidFriendlyControls(controller),
                
                // Kid-friendly loading indicator
                _buildKidFriendlyLoading(controller),
                
                // Bottom scrollable 3D models with enhanced kid design
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
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  SizedBox(width: 4),
                  Text("🏠", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // AR status indicator for kids
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: controller.isARInitialized.value 
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
          )),
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated icon
          const Text("🔍", style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          
          const Text(
            "Mencari Permukaan Datar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          const Text(
            "Arahkan kamera ke meja atau lantai\nGerakkan perlahan-lahan ya! 😊",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          
          // Kid-friendly progress bar
          Obx(() => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress: ${(controller.detectedPlanesCount.value * 50).clamp(0, 100).toInt()}%",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    "${controller.detectedPlanesCount.value}/2 ✨",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (controller.detectedPlanesCount.value / 2.0).clamp(0.0, 1.0),
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                minHeight: 6,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildModelSelectionGuidance() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.9),
            Colors.teal.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text("🎯", style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Bagus! Sekarang pilih hewan favorit kamu di bawah! 👇",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.9),
            Colors.red.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text("👆", style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Text(
              "Sentuh layar untuk menempatkan ${controller.selectedModelName.value}! ✨",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCelebration(KidFriendlyARController controller) {
    return Obx(() => controller.isModelPlaced.value
      ? AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
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
              const Text("🎉", style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Keren! ${controller.selectedModelName.value} sudah muncul! Coba geser atau putar! 🎮",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      : const SizedBox.shrink()
    );
  }

  Widget _buildKidFriendlyControls(KidFriendlyARController controller) {
    return Obx(() => controller.isModelPlaced.value
      ? Padding(
          padding: const EdgeInsets.only(bottom: 24, right: 16, left: 16),
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
      : const SizedBox.shrink()
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          elevation: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKidFriendlyLoading(KidFriendlyARController controller) {
    return Obx(() => !controller.isARInitialized.value
      ? Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.withOpacity(0.9),
                Colors.blue.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("🚀", style: TextStyle(fontSize: 32)),
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              const Text(
                "Menyiapkan Kamera Ajaib...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sebentar ya, hampir selesai! ✨",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
      : const SizedBox.shrink()
    );
  }

  Widget _buildKidFriendlyModelList(KidFriendlyARController controller) {
    return Container(
      height: 120, // Slightly taller for kid-friendly design
      padding: const EdgeInsets.symmetric(vertical: 12),
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
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category header for kids
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Text("🎯", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                const Text(
                  "Pilih Hewan Favorit:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  "${controller.models3dList.length} hewan",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Model list
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.models3dList.length,
              itemBuilder: (context, index) {
                final model = controller.models3dList[index];
                final isSelected = controller.selectedModelUrl.value == model["model3dUrl"];
                
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.purple : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected 
              ? Colors.purple.withOpacity(0.3)
              : Colors.black.withOpacity(0.1),
            blurRadius: isSelected ? 8 : 4,
            offset: Offset(0, isSelected ? 4 : 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple.withOpacity(0.1) : Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animal image
              Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(model["photoUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              
              // Animal name with emoji
              Text(
                model["name"],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.purple[700] : Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Selection indicator
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: const Text("✅", style: TextStyle(fontSize: 12)),
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
        child: const Text("❓", style: TextStyle(fontSize: 20)),
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
            child: const Text("😊 Mengerti!", 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}