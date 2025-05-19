import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'animal_controller.dart';

class AnimalPage extends StatelessWidget {
  const AnimalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnimalController());
    
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                  const SizedBox(width: 16),
                  const Text(
                    "Koleksi Hewan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Categories Tabs
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectCategory(0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: controller.selectedCategoryIndex.value == 0
                            ? Colors.blue[600]
                            : Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Hewan Vertebrata",
                          style: TextStyle(
                            color: controller.selectedCategoryIndex.value == 0
                              ? Colors.white
                              : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectCategory(1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: controller.selectedCategoryIndex.value == 1
                            ? Colors.blue[600]
                            : Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Hewan Invertebrata",
                          style: TextStyle(
                            color: controller.selectedCategoryIndex.value == 1
                              ? Colors.white
                              : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
            
            const SizedBox(height: 16),
            
            // Category Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => Text(
                controller.selectedCategoryIndex.value == 0
                  ? "Hewan vertebrata adalah hewan yang memiliki tulang belakang, seperti mamalia, burung, ikan, dan reptil."
                  : "Hewan invertebrata adalah hewan yang tidak memiliki tulang belakang, seperti serangga, cacing, dan moluska.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              )),
            ),
            
            const SizedBox(height: 16),
            
            // Grid of Animals
            Expanded(
              child: Obx(() => GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: controller.selectedCategoryIndex.value == 0
                  ? controller.vertebrateAnimals.length
                  : controller.invertebrateAnimals.length,
                itemBuilder: (context, index) {
                  final animal = controller.selectedCategoryIndex.value == 0
                    ? controller.vertebrateAnimals[index]
                    : controller.invertebrateAnimals[index];
                  
                  return GestureDetector(
                    onTap: () => controller.onAnimalTap(animal),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                animal["photoUrl"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              animal["name"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}