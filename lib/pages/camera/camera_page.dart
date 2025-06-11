import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'camera_controller.dart';
import 'widgets/model_item.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CameraController());
    
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
                // Back button at top left
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () => controller.onBackPressed(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Plane scanning guidance - only show during initial scanning
                Obx(() => controller.isPlaneDetectionInProgress.value
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Mendeteksi permukaan...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Gerakkan kamera perlahan di atas permukaan datar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
                ),
                
                // Instructions when AR is initialized but no model selected
                Obx(() => controller.isPlaneScanningComplete.value && controller.selectedModelUrl.value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Pilih model hewan dari bawah",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
                ),
                
                // Push everything else to the bottom
                const Spacer(),
                
                // Scale control buttons - Only show when model is placed
                Obx(() => controller.isModelPlaced.value
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 24, right: 16, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                            icon: Icons.remove,
                            label: "Perkecil",
                            color: Colors.red[400]!,
                            onTap: () => controller.changeScale(false),
                          ),
                          const SizedBox(width: 16),
                          _buildControlButton(
                            icon: Icons.refresh,
                            label: "Reset",
                            color: Colors.blue[400]!,
                            onTap: controller.resetModel,
                          ),
                          const SizedBox(width: 16),
                          _buildControlButton(
                            icon: Icons.add,
                            label: "Perbesar",
                            color: Colors.green[400]!,
                            onTap: () => controller.changeScale(true),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
                ),
                
                // Loading indicator when AR is not initialized
                Obx(() => !controller.isARInitialized.value
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Mempersiapkan AR...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
                ),
                
                // Bottom scrollable 3D models
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.models3dList.length,
                    itemBuilder: (context, index) {
                      final model = controller.models3dList[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () => controller.onModelTap(index),
                          child: ModelItem(
                            imageUrl: model["photoUrl"],
                            name: model["name"],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
   
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}