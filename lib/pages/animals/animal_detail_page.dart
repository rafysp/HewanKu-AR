// pages/animals/animal_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'animal_detail_controller.dart';

class AnimalDetailPage extends StatelessWidget {
  final Map<String, dynamic> animal;

  const AnimalDetailPage({Key? key, required this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnimalDetailController(animal));

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.onBackPressed(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(224, 224, 224, 1.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                        size: 24,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Animal Name with Colorful Background
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(187, 222, 251, 1.0),
                    Color.fromRGBO(227, 242, 253, 1.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                animal["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(63, 81, 181, 1.0),
                ),
              ),
            ),

            // Animal Image
            Container(
              height: 180,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1.0),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  animal["photoUrl"],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Color.fromRGBO(158, 158, 158, 1.0),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Animal Info Section with Colorful Categories
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Greeting Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 249, 196, 1.0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Halo teman! Ini adalah ${animal["name"].toUpperCase()}!",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 152, 0, 1.0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Sound Section with Interactive Play Button
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(187, 222, 251, 1.0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.volume_up,
                                      color: Color.fromRGBO(33, 150, 243, 1.0),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "SUARA",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(33, 150, 243, 1.0),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Play/Stop Button with Obx reactive state
                                  Obx(
                                    () => GestureDetector(
                                      onTap: () => controller.playAnimalSound(),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              controller.isPlaying.value
                                                  ? Color.fromRGBO(
                                                    244,
                                                    67,
                                                    54,
                                                    0.8,
                                                  )
                                                  : Color.fromRGBO(
                                                    76,
                                                    175,
                                                    80,
                                                    1.0,
                                                  ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                0,
                                                0,
                                                0,
                                                0.2,
                                              ),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          controller.isPlaying.value
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                          color: Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            1.0,
                                          ),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.getAnimalSound(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                              // Petunjuk untuk anak-anak
                              const SizedBox(height: 8),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.7),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color.fromRGBO(33, 150, 243, 1.0),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Text(
                                    "Tekan tombol di atas untuk mendengar suaranya!",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(33, 150, 243, 1.0),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Food Section
                        _buildInfoSection(
                          title: "MAKANAN",
                          content: controller.getAnimalFood(),
                          icon: Icons.restaurant,
                          backgroundColor: Color.fromRGBO(200, 230, 201, 1.0),
                          iconColor: Color.fromRGBO(76, 175, 80, 1.0),
                        ),

                        const SizedBox(height: 12),

                        // Family Section
                        _buildInfoSection(
                          title: "KELUARGA",
                          content: controller.getAnimalFamily(),
                          icon: Icons.people,
                          backgroundColor: Color.fromRGBO(209, 196, 233, 1.0),
                          iconColor: Color.fromRGBO(103, 58, 183, 1.0),
                        ),

                        const SizedBox(height: 12),

                        // Skill Section
                        _buildInfoSection(
                          title: "KEAHLIAN",
                          content: controller.getAnimalSkill(),
                          icon: Icons.star,
                          backgroundColor: Color.fromRGBO(255, 224, 178, 1.0),
                          iconColor: Color.fromRGBO(255, 152, 0, 1.0),
                        ),

                        const SizedBox(height: 12),

                        // Fun Fact Section (Special Design)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(248, 187, 208, 1.0),
                                Color.fromRGBO(225, 190, 231, 1.0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lightbulb,
                                    color: Color.fromRGBO(255, 193, 7, 1.0),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "FAKTA SERU",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(103, 58, 183, 1.0),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events,
                                      color: Color.fromRGBO(255, 193, 7, 1.0),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.getAnimalFunFact(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100), // Space for button
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // AR View Button - Fixed at bottom
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 60,
        child: ElevatedButton(
          onPressed: () => controller.onViewInAR(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(33, 150, 243, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: Color.fromRGBO(33, 150, 243, 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.view_in_ar,
                  color: Color.fromRGBO(33, 150, 243, 1.0),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Lihat dalam AR",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromRGBO(255, 255, 255, 1.0),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
