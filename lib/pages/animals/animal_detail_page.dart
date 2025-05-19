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
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
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
                  colors: [Colors.blue[100]!, Colors.blue[50]!],
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
                  color: Colors.indigo,
                ),
              ),
            ),

            // Animal Image
            Container(
              height: 180,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
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
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
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
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Halo teman! Ini adalah ${animal["name"].toUpperCase()}!",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Sound Section
                        _buildInfoSection(
                          title: "SUARA",
                          content: controller.getAnimalSound(),
                          icon: Icons.volume_up,
                          color: Colors.blue[100]!,
                          iconColor: Colors.blue,
                        ),

                        const SizedBox(height: 12),

                        // Food Section
                        _buildInfoSection(
                          title: "MAKANAN",
                          content: controller.getAnimalFood(),
                          icon: Icons.restaurant,
                          color: Colors.green[100]!,
                          iconColor: Colors.green,
                        ),

                        const SizedBox(height: 12),

                        // Family Section
                        _buildInfoSection(
                          title: "KELUARGA",
                          content: controller.getAnimalFamily(),
                          icon: Icons.people,
                          color: Colors.purple[100]!,
                          iconColor: Colors.purple,
                        ),

                        const SizedBox(height: 12),

                        // Skill Section
                        _buildInfoSection(
                          title: "KEAHLIAN",
                          content: controller.getAnimalSkill(),
                          icon: Icons.star,
                          color: Colors.orange[100]!,
                          iconColor: Colors.orange,
                        ),

                        const SizedBox(height: 12),

                        // Fun Fact Section (Special Design)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink[100]!, Colors.purple[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
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
                                    color: Colors.amber,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "FAKTA SERU",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events,
                                      color: Colors.amber,
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
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 60,
        child: ElevatedButton(
          onPressed: () => controller.onViewInAR(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: Colors.blue.withOpacity(0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.view_in_ar, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              const Text(
                "Lihat dalam AR",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
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
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
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
                  color: Colors.white,
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

// Update animal_detail_controller.dart to add these new helper methods
// that return individual sections of the description
/*
String getAnimalSound() {
  switch(animal["name"]) {
    case "Ayam":
      return "Ayam berbunyi 'kukuruyuk' dan 'kotkotkot'.";
    // other animals...
  }
}

String getAnimalFood() {
  switch(animal["name"]) {
    case "Ayam":
      return "Ayam makan biji-bijian, serangga, dan cacing.";
    // other animals...
  }
}

String getAnimalFamily() {
  switch(animal["name"]) {
    case "Ayam":
      return "Ayam jantan disebut jago\nAyam betina disebut induk ayam\nAnaknya disebut anak ayam";
    // other animals...
  }
}

String getAnimalSkill() {
  switch(animal["name"]) {
    case "Ayam":
      return "Ayam bisa mengenali lebih dari 100 ayam lain dalam kelompoknya.";
    // other animals...
  }
}

String getAnimalFunFact() {
  switch(animal["name"]) {
    case "Ayam":
      return "Ayam adalah keturunan dinosaurus! Mereka adalah kerabat terdekat dari T-Rex yang masih hidup saat ini.";
    // other animals...
  }
}
*/
