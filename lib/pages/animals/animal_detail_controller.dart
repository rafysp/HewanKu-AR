// pages/animals/animal_detail_controller.dart
import 'package:get/get.dart';
import '../camera/camera_page.dart';

class AnimalDetailController extends GetxController {
  final Map<String, dynamic> animal;

  AnimalDetailController(this.animal);

  void onBackPressed() {
    Get.back();
  }

  void onViewInAR() {
    // Pass the animal data to the CameraPage when navigating
    Get.to(() => const CameraPage(), arguments: animal);
  }

  String getAnimalSound() {
    // Return sound information based on animal name
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam berbunyi 'kukuruyuk' dan 'kotkotkot'.";
      case "Anjing":
        return "Anjing berbunyi 'guk guk' atau 'woof woof'.";
      case "Kuda":
        return "Kuda berbunyi 'hiiihiii' yang disebut ringkikan.";
      case "Kucing":
        return "Kucing berbunyi 'meong meong' atau 'purr' saat senang.";
      case "Harimau":
        return "Harimau dapat mengaum dengan suara 'AUMMM!' yang sangat keras.";
      case "Lebah":
        return "Lebah berbunyi 'bzzzz' karena getaran sayap mereka.";
      case "Kepiting":
        return "Kepiting tidak bisa bersuara, tapi bisa membuat suara dengan capitnya.";
      case "Cacing":
        return "Cacing tidak memiliki suara atau alat pendengaran.";
      case "Kupu-kupu":
        return "Kupu-kupu tidak bisa bersuara, mereka berkomunikasi dengan warna sayap dan bau kimia.";
      default:
        return "Setiap hewan memiliki cara komunikasi yang berbeda.";
    }
  }

  String getAnimalFood() {
    // Return food information based on animal name
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam makan biji-bijian, serangga, dan cacing.";
      case "Anjing":
        return "Anjing suka makan daging, tulang, dan makanan khusus anjing.";
      case "Kuda":
        return "Kuda makan rumput, hay, dan sangat suka wortel dan apel.";
      case "Kucing":
        return "Kucing adalah karnivora, mereka makan daging dan ikan.";
      case "Harimau":
        return "Harimau adalah karnivora yang makan daging, seperti rusa dan babi hutan.";
      case "Lebah":
        return "Lebah makan nektar dan serbuk sari dari bunga.";
      case "Kepiting":
        return "Kepiting makan tanaman laut, hewan kecil, dan sisa-sisa makanan di laut.";
      case "Cacing":
        return "Cacing makan tanah dan sisa-sisa tumbuhan yang membusuk.";
      case "Kupu-kupu":
        return "Kupu-kupu dewasa menghisap nektar bunga menggunakan belalai panjang mereka.";
      default:
        return "Setiap hewan membutuhkan makanan untuk bertahan hidup.";
    }
  }

  String getAnimalFamily() {
    // Return family information based on animal name
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam jantan disebut jago\nAyam betina disebut induk ayam\nAnaknya disebut anak ayam";
      case "Anjing":
        return "Anak anjing disebut 'puppy'\nMereka tinggal bersama induknya selama beberapa minggu";
      case "Kuda":
        return "Anak kuda disebut 'foal'\nKuda jantan disebut 'stallion'\nKuda betina disebut 'mare'";
      case "Kucing":
        return "Anak kucing disebut 'kitten'\nDalam satu kelahiran bisa ada 4-6 anak kucing";
      case "Harimau":
        return "Anak harimau tinggal dengan induknya hingga berusia 2-3 tahun sebelum hidup sendiri.";
      case "Lebah":
        return "Dalam satu sarang ada:\n- Ratu lebah\n- Lebah jantan\n- Ribuan lebah pekerja";
      case "Kepiting":
        return "Kepiting betina bisa menghasilkan hingga 2 juta telur sekaligus!";
      case "Cacing":
        return "Cacing tanah adalah hermafrodit, yang berarti mereka punya organ jantan dan betina.";
      case "Kupu-kupu":
        return "Kupu-kupu berubah dari:\n- Telur\n- Menjadi ulat\n- Lalu kepompong\n- Dan akhirnya kupu-kupu dewasa";
      default:
        return "Semua hewan memiliki cara berkembang biak yang unik.";
    }
  }

  String getAnimalSkill() {
    // Return skill information based on animal name
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam bisa mengenali lebih dari 100 ayam lain dalam kelompoknya.";
      case "Anjing":
        return "Anjing bisa dilatih untuk membantu orang, seperti membimbing orang yang tidak bisa melihat.";
      case "Kuda":
        return "Kuda bisa berlari sangat cepat hingga 88 kilometer per jam.";
      case "Kucing":
        return "Kucing bisa melompat hingga 6 kali panjang tubuh mereka sendiri.";
      case "Harimau":
        return "Harimau adalah perenang yang sangat baik dan suka bermain di air.";
      case "Lebah":
        return "Lebah berkomunikasi dengan melakukan 'tarian' khusus untuk memberitahu lebah lain di mana sumber makanan berada.";
      case "Kepiting":
        return "Kepiting berjalan menyamping, bukan ke depan seperti hewan lain.";
      case "Cacing":
        return "Cacing membuat terowongan di tanah yang membantu udara dan air masuk ke dalam tanah.";
      case "Kupu-kupu":
        return "Sayap kupu-kupu sangat rapuh tapi mereka bisa terbang ribuan kilometer saat bermigrasi.";
      default:
        return "Setiap hewan memiliki keahlian khusus untuk bertahan hidup.";
    }
  }

  String getAnimalFunFact() {
    // Return fun fact based on animal name
    switch (animal["name"]) {
      case "Ayam":
        return "Ayam adalah keturunan dinosaurus! Mereka adalah kerabat terdekat dari T-Rex yang masih hidup saat ini.";
      case "Anjing":
        return "Hidung anjing selalu basah karena membantu mereka mencium bau lebih baik. Anjing bisa mencium penyakit pada tubuh manusia!";
      case "Kuda":
        return "Kuda bisa tidur sambil berdiri! Mereka punya 'kunci lutut' khusus yang membuat kaki mereka tetap lurus saat tidur.";
      case "Kucing":
        return "Kumis kucing sama lebarnya dengan tubuh mereka, sehingga membantu mereka mengukur apakah mereka bisa melewati celah sempit atau tidak.";
      case "Harimau":
        return "Garis-garis pada setiap harimau berbeda, seperti sidik jari manusia. Garis-garis ini juga ada di kulit harimau, bukan hanya di bulunya!";
      case "Lebah":
        return "Untuk membuat satu sendok makan madu, lebah harus mengunjungi sekitar 2.000 bunga dan terbang sejauh 88 km!";
      case "Kepiting":
        return "Kepiting berganti cangkang saat tumbuh besar. Mereka melepas cangkang lama dan bersembunyi sampai cangkang baru mengeras!";
      case "Cacing":
        return "Ada cacing yang bisa hidup selama 6 tahun! Dan jika bagian kepala cacing terpotong, bagian itu bisa tumbuh menjadi cacing baru.";
      case "Kupu-kupu":
        return "Kupu-kupu mencicipi makanan dengan kaki mereka, bukan lidah! Mereka merasakan rasa manis menggunakan sensor di kaki!";
      default:
        return "Ada lebih dari 1,5 juta jenis hewan berbeda di dunia, dan ilmuwan masih menemukan jenis baru setiap tahun!";
    }
  }

  // Original combined method - we keep this for backwards compatibility
  String getAnimalDescription() {
    // Return full description based on animal name
    switch (animal["name"]) {
      case "Ayam":
        return "Halo teman! Ini adalah AYAM!\n\n"
            "SUARA:\n"
            "Ayam berbunyi 'kukuruyuk' dan 'kotkotkot'.\n\n"
            "MAKANAN:\n"
            "Ayam makan biji-bijian, serangga, dan cacing.\n\n"
            "KELUARGA:\n"
            "Ayam jantan disebut jago\n"
            "Ayam betina disebut induk ayam\n"
            "Anaknya disebut anak ayam\n\n"
            "KEAHLIAN:\n"
            "Ayam bisa mengenali lebih dari 100 ayam lain dalam kelompoknya.\n\n"
            "FAKTA SERU:\n"
            "Ayam adalah keturunan dinosaurus! Mereka adalah kerabat terdekat dari T-Rex yang masih hidup saat ini.";

      // Other animals descriptions removed for brevity but would contain similar format

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
            "Ada lebih dari 1,5 juta jenis hewan berbeda di dunia, dan ilmuwan masih menemukan jenis baru setiap tahun!";
    }
  }
}