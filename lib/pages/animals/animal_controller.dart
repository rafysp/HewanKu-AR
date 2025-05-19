// pages/animals/animal_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'animal_detail_page.dart';

class AnimalController extends GetxController {
  RxInt selectedCategoryIndex = 0.obs;
  
  // Lists of animals by category
  final List<Map<String, dynamic>> vertebrateAnimals = [
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//chicken_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//ayam.jpg",
      "name": "Ayam"
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//dog_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-siberian-husky-dog-png-image_16179695.png",
      "name": "Anjing"
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//horse_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-horse-png-with-ai-generated-png-image_14576200.png",
      "name": "Kuda"
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//kitty_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-orange-cat-cute-little-kitty-png-image_14519124.png",
      "name": "Kucing"
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//tiger_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-tiger-walking-wildlife-scene-transparent-background-png-image_9153495.png",
      "name": "Harimau"
    },
  ];
  
  final List<Map<String, dynamic>> invertebrateAnimals = [
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//arm_chair__furniture.glb", // Placeholder
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//Arm%20chair.png", // Placeholder
      "name": "Lebah"
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//arm_chair__furniture.glb", // Placeholder
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//Arm%20chair.png", // Placeholder
      "name": "Kepiting"
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//arm_chair__furniture.glb", // Placeholder
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//Arm%20chair.png", // Placeholder
      "name": "Cacing"
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//arm_chair__furniture.glb", // Placeholder
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//Arm%20chair.png", // Placeholder
      "name": "Kupu-kupu"
    },
  ];
  
  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }
  
  void onBackPressed() {
    Get.back();
  }
  
  void onAnimalTap(Map<String, dynamic> animal) {
    // Navigate to animal detail page instead of directly to camera
    Get.to(() => AnimalDetailPage(animal: animal));
  }
}