// pages/animals/animal_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/sounds_constant.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../camera/camera_page.dart';

class AnimalDetailController extends GetxController {
  final Map<String, dynamic> animal;
  final audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;

  AnimalDetailController(this.animal);

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void onBackPressed() {
    audioPlayer.stop();
    Get.back();
  }

  void onViewInAR() {
    audioPlayer.stop();
    Get.to(() => const CameraPage(), arguments: animal);
  }

  Future<void> playAnimalSound() async {
    try {
      if (isPlaying.value) {
        await audioPlayer.stop();
        isPlaying.value = false;
        return;
      }

      final String soundPath = getAnimalSoundPath();
      
      if (soundPath.isEmpty) {
        Get.snackbar(
          "Informasi",
          "Suara untuk ${animal["name"]} belum tersedia",
          backgroundColor: Color.fromRGBO(255, 152, 0, 0.7),
          colorText: Color.fromRGBO(255, 255, 255, 1.0),
          duration: const Duration(seconds: 2),
        );
        return;
      }
      
      await audioPlayer.play(AssetSource(soundPath));
      isPlaying.value = true;
      
      audioPlayer.onPlayerComplete.listen((event) {
        isPlaying.value = false;
      });
    } catch (e) {
      isPlaying.value = false;
      Get.snackbar(
        "Error",
        "Gagal memutar suara: $e",
        backgroundColor: Color.fromRGBO(244, 67, 54, 0.7),
        colorText: Color.fromRGBO(255, 255, 255, 1.0),
      );
      print("Error memutar suara: $e");
    }
  }

  String getAnimalSoundPath() {
    switch (animal["name"].toLowerCase()) {
      case "ayam":
        return SoundsCollection.chicken;
      case "anjing":
        return SoundsCollection.dog;
      case "kucing":
        return SoundsCollection.cat;
      case "katak":
        return SoundsCollection.frog;
      case "iguana":
        return SoundsCollection.iguana;
      case "kelinci":
        return SoundsCollection.rabbit;
      case "burung":
        return SoundsCollection.bird;
      // Hewan lainnya belum memiliki file suara
      case "kura-kura":
      case "ikan mas":
      case "kepiting biru":
      case "kerang":
      case "laba-laba":
      case "cumi-cumi":
      case "spons":
      case "bintang laut":
      default:
        return "";
    }
  }

  String getAnimalSound() {
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam berbunyi 'kukuruyuk' dan 'kotkotkot'.";
      case "Anjing":
        return "Anjing berbunyi 'guk guk' atau 'woof woof'.";
      case "Kucing":
        return "Kucing berbunyi 'meong meong' atau 'purr' saat senang.";
      case "Katak":
        return "Katak berbunyi 'ribbit ribbit' terutama saat malam hari.";
      case "Iguana":
        return "Iguana mengeluarkan suara desis atau gumaman pelan untuk berkomunikasi.";
      case "Kelinci":
        return "Kelinci mencicit halus, menggeram, atau mendengus saat berkomunikasi.";
      case "Burung":
        return "Burung berkicau dengan melodi yang indah untuk berkomunikasi.";
      case "Kura-kura":
        return "Kura-kura biasanya diam, tapi kadang mengeluarkan suara desis pelan.";
      case "Ikan Mas":
        return "Ikan mas tidak bersuara seperti hewan darat, mereka berkomunikasi dengan gerakan.";
      case "Kepiting Biru":
        return "Kepiting biru menggunakan capitnya untuk menghasilkan suara ketukan di permukaan.";
      case "Kerang":
        return "Kerang tidak memiliki suara, mereka berkomunikasi dengan sinyal kimia.";
      case "Laba-laba":
        return "Laba-laba berkomunikasi dengan getaran pada jaring dan sentuhan kaki.";
      case "Cumi-cumi":
        return "Cumi-cumi berkomunikasi dengan perubahan warna kulit dan pola tubuh.";
      case "Spons":
        return "Spons tidak memiliki sistem saraf, sehingga tidak dapat bersuara.";
      case "Bintang Laut":
        return "Bintang laut berkomunikasi melalui sinyal kimia dan sentuhan.";
      default:
        return "Setiap hewan memiliki cara komunikasi yang berbeda.";
    }
  }

  String getAnimalFood() {
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam makan biji-bijian, serangga, cacing, dan sisa makanan.";
      case "Anjing":
        return "Anjing makan daging, sayuran, dan makanan khusus anjing.";
      case "Kucing":
        return "Kucing adalah karnivora yang makan daging, ikan, dan makanan kucing.";
      case "Katak":
        return "Katak makan serangga, cacing, dan hewan kecil lainnya.";
      case "Iguana":
        return "Iguana herbivora yang makan daun, bunga, dan buah-buahan.";
      case "Kelinci":
        return "Kelinci makan rumput, sayuran hijau, wortel, dan hay.";
      case "Burung":
        return "Burung makan biji-bijian, buah, serangga, dan nektar bunga.";
      case "Kura-kura":
        return "Kura-kura makan tumbuhan air, ikan kecil, dan sayuran.";
      case "Ikan Mas":
        return "Ikan mas makan plankton, tumbuhan air, dan pelet ikan.";
      case "Kepiting Biru":
        return "Kepiting biru makan ikan kecil, kerang, dan sisa organik di dasar laut.";
      case "Kerang":
        return "Kerang menyaring plankton dan partikel organik dari air laut.";
      case "Laba-laba":
        return "Laba-laba memakan serangga yang terjebak di jaringnya.";
      case "Cumi-cumi":
        return "Cumi-cumi makan ikan kecil, udang, dan krustasea lainnya.";
      case "Spons":
        return "Spons menyaring bakteri dan partikel organik kecil dari air.";
      case "Bintang Laut":
        return "Bintang laut makan kerang, tiram, dan hewan kecil di dasar laut.";
      default:
        return "Setiap hewan membutuhkan makanan untuk bertahan hidup.";
    }
  }

  String getAnimalFamily() {
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam jantan disebut jago\nAyam betina disebut induk ayam\nAnaknya disebut anak ayam";
      case "Anjing":
        return "Anjing jantan disebut anjing jantan\nAnjing betina disebut anjing betina\nAnaknya disebut anak anjing atau puppy";
      case "Kucing":
        return "Kucing jantan disebut kucing jantan\nKucing betina disebut kucing betina\nAnaknya disebut anak kucing atau kitten";
      case "Katak":
        return "Katak jantan dan betina dewasa\nTelurnya menetas menjadi kecebong\nKecebong berkembang menjadi katak";
      case "Iguana":
        return "Iguana jantan umumnya lebih besar\nIguana betina bertelur di tanah\nAnaknya disebut iguana muda";
      case "Kelinci":
        return "Kelinci jantan disebut buck\nKelinci betina disebut doe\nAnaknya disebut kit atau bunny";
      case "Burung":
        return "Burung jantan dan betina dewasa\nMereka bertelur di sarang\nAnaknya disebut anak burung";
      case "Kura-kura":
        return "Kura-kura jantan dan betina\nMereka bertelur di pasir atau tanah\nAnaknya disebut tukik";
      case "Ikan Mas":
        return "Ikan mas jantan dan betina\nMereka bertelur di air\nAnaknya disebut benih ikan";
      case "Kepiting Biru":
        return "Kepiting jantan memiliki capit lebih besar\nKepiting betina membawa telur di perut\nAnaknya disebut kepiting muda";
      case "Kerang":
        return "Kerang ada yang jantan dan betina\nMereka melepas telur dan sperma ke air\nAnaknya disebut larva kerang";
      case "Laba-laba":
        return "Laba-laba betina umumnya lebih besar\nMereka bertelur dalam kantung sutra\nAnaknya disebut laba-laba muda";
      case "Cumi-cumi":
        return "Cumi-cumi jantan dan betina\nMereka bertelur dalam kapsul\nAnaknya disebut cumi-cumi muda";
      case "Spons":
        return "Spons dapat jantan, betina, atau hermafrodit\nMereka berkembang biak dengan spora\nAnaknya disebut larva spons";
      case "Bintang Laut":
        return "Bintang laut dapat jantan atau betina\nMereka melepas telur dan sperma ke air\nAnaknya disebut larva bintang laut";
      default:
        return "Semua hewan memiliki cara berkembang biak yang unik.";
    }
  }

  String getAnimalSkill() {
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam bisa mengenali lebih dari 100 ayam lain dalam kelompoknya.";
      case "Anjing":
        return "Anjing memiliki penciuman 10.000 kali lebih kuat dari manusia.";
      case "Kucing":
        return "Kucing dapat memutar telinganya 180 derajat dan selalu mendarat dengan kaki.";
      case "Katak":
        return "Katak dapat melompat hingga 20 kali panjang tubuhnya.";
      case "Iguana":
        return "Iguana memiliki mata ketiga di atas kepala untuk mendeteksi bayangan.";
      case "Kelinci":
        return "Kelinci dapat berlari hingga 50 km/jam dan melompat setinggi 1 meter.";
      case "Burung":
        return "Burung dapat terbang ribuan kilometer tanpa istirahat saat migrasi.";
      case "Kura-kura":
        return "Kura-kura dapat hidup hingga 100 tahun dan bernafas melalui pantat.";
      case "Ikan Mas":
        return "Ikan mas memiliki memori hingga 3 bulan dan dapat dilatih melakukan trik.";
      case "Kepiting Biru":
        return "Kepiting biru dapat berjalan menyamping dengan sangat cepat dan berenang.";
      case "Kerang":
        return "Kerang dapat menyaring hingga 50 liter air per hari untuk mencari makanan.";
      case "Laba-laba":
        return "Laba-laba dapat menghasilkan sutra yang 5 kali lebih kuat dari baja.";
      case "Cumi-cumi":
        return "Cumi-cumi dapat mengubah warna kulit dalam sekejap untuk berkamuflase.";
      case "Spons":
        return "Spons dapat meregenerasi seluruh tubuhnya dari potongan kecil.";
      case "Bintang Laut":
        return "Bintang laut dapat meregenerasi lengan yang putus menjadi individu baru.";
      default:
        return "Setiap hewan memiliki keahlian khusus untuk bertahan hidup.";
    }
  }

  String getAnimalFunFact() {
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam adalah keturunan dinosaurus! Mereka adalah kerabat terdekat dari T-Rex yang masih hidup saat ini.";
      case "Anjing":
        return "Anjing memiliki sidik hidung yang unik seperti sidik jari manusia, tidak ada yang sama!";
      case "Kucing":
        return "Kucing menghabiskan 70% hidupnya untuk tidur, itu sekitar 13-16 jam sehari!";
      case "Katak":
        return "Katak minum air melalui kulitnya, bukan melalui mulut seperti hewan lainnya!";
      case "Iguana":
        return "Iguana dapat menahan napas hingga 30 menit saat berenang di bawah air!";
      case "Kelinci":
        return "Kelinci tidak bisa muntah dan matanya dapat melihat hampir 360 derajat!";
      case "Burung":
        return "Burung tidak memiliki gigi, mereka menggunakan batu kecil di perut untuk menghancurkan makanan!";
      case "Kura-kura":
        return "Kura-kura tertua yang tercatat hidup hingga 188 tahun dan masih hidup sampai sekarang!";
      case "Ikan Mas":
        return "Ikan mas dapat melihat lebih banyak warna daripada manusia, termasuk ultraviolet!";
      case "Kepiting Biru":
        return "Kepiting biru harus keluar dari cangkangnya untuk tumbuh, proses ini disebut molting!";
      case "Kerang":
        return "Kerang raksasa dapat hidup hingga 100 tahun dan beratnya bisa mencapai 200 kg!";
      case "Laba-laba":
        return "Jika jaring laba-laba sebesar lapangan sepak bola, ia bisa menahan pesawat jet!";
      case "Cumi-cumi":
        return "Cumi-cumi memiliki 3 jantung dan darahnya berwarna biru, bukan merah!";
      case "Spons":
        return "Spons adalah hewan tertua di bumi, sudah ada sejak 600 juta tahun lalu!";
      case "Bintang Laut":
        return "Bintang laut tidak memiliki otak atau darah, tapi bisa hidup hingga 35 tahun!";
      default:
        return "Ada lebih dari 1,5 juta jenis hewan berbeda di dunia, dan ilmuwan masih menemukan jenis baru setiap tahun!";
    }
  }

  String getAnimalDescription() {
    switch (animal["name"]) {
      case "Ayam":
        return "Halo teman! Ini adalah AYAM!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Anjing":
        return "Halo teman! Ini adalah ANJING!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Kucing":
        return "Halo teman! Ini adalah KUCING!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Katak":
        return "Halo teman! Ini adalah KATAK!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Iguana":
        return "Halo teman! Ini adalah IGUANA!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Kelinci":
        return "Halo teman! Ini adalah KELINCI!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Burung":
        return "Halo teman! Ini adalah BURUNG!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Kura-kura":
        return "Halo teman! Ini adalah KURA-KURA!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Ikan Mas":
        return "Halo teman! Ini adalah IKAN MAS!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Kepiting Biru":
        return "Halo teman! Ini adalah KEPITING BIRU!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Kerang":
        return "Halo teman! Ini adalah KERANG!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Laba-laba":
        return "Halo teman! Ini adalah LABA-LABA!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Cumi-cumi":
        return "Halo teman! Ini adalah CUMI-CUMI!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Spons":
        return "Halo teman! Ini adalah SPONS!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      case "Bintang Laut":
        return "Halo teman! Ini adalah BINTANG LAUT!\n\n"
            "SUARA:\n"
            "${getAnimalSound()}\n\n"
            "MAKANAN:\n"
            "${getAnimalFood()}\n\n"
            "KELUARGA:\n"
            "${getAnimalFamily()}\n\n"
            "KEAHLIAN:\n"
            "${getAnimalSkill()}\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
      default:
        return "Halo teman! Mari kenali hewan ini!\n\n"
            "DUNIA HEWAN:\n"
            "Ada berbagai jenis hewan yang hidup di darat, air, dan udara.\n\n"
            "PERLINDUNGAN:\n"
            "Banyak hewan yang terancam punah dan perlu kita lindungi.\n\n"
            "PERAN HEWAN:\n"
            "Hewan membantu menjaga keseimbangan alam dan lingkungan kita.\n\n"
            "BELAJAR:\n"
            "Dengan mengenal hewan, kita jadi lebih sayang pada mereka.\n\n"
            "FAKTA SERU:\n"
            "${getAnimalFunFact()}";
    }
  }
}