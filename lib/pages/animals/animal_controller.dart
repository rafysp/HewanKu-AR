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
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//Chicken_Quad.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//chicken.png",
      "name": "Ayam",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//dog_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//dog.png",
      "name": "Anjing",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//cat.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//cat.png",
      "name": "Kucing",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//Frog_Quad.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//frog.png",
      "name": "Katak",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//iguana.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//iguana.png",
      "name": "Iguana",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//rabbit.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//rabbit.png",
      "name": "Kelinci",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//bird.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//bird.png",
      "name": "Burung",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//turtle2.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//turtle.png",
      "name": "Kura-kura",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//carp.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//carp.png",
      "name": "Ikan Mas",
    },
  ];

  final List<Map<String, dynamic>> invertebrateAnimals = [
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//blue_crab.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//crab.png",
      "name": "Kepiting Biru",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//clam_with_tongue_and_pearl.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//clam.png",
      "name": "Kerang",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//spider.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//spider.png",
      "name": "Laba-laba",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//squid.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//squid.png",
      "name": "Cumi-cumi",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//sponge_recent_demosponge.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//sponge.png",
      "name": "Spons",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//cushion_star.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//star.png",
      "name": "Bintang Laut",
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
