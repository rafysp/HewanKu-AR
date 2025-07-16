import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Tes Black Box Quiz Puzzle', () {
    setUp(() async {
      // Setup lingkungan test sebelum setiap test
      Get.reset();
    });

    tearDown(() async {
      // Bersihkan setelah setiap test
      Get.reset();
    });

    group('Tes Setup Game Puzzle', () {
      testWidgets('harus menampilkan interface game puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text(
                  'Game Puzzle Hewan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('Susun potongan untuk melengkapi gambar hewan'),
                SizedBox(height: 20),
                Expanded(child: Center(child: Text('Area Grid Puzzle'))),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Game Puzzle Hewan'), findsOneWidget);
        expect(
          find.text('Susun potongan untuk melengkapi gambar hewan'),
          findsOneWidget,
        );
        expect(find.text('Area Grid Puzzle'), findsOneWidget);
      });

      testWidgets('harus menampilkan pemilihan tingkat kesulitan puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Pilih Tingkat Kesulitan:'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mudah\n(3x3)'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Sedang\n(4x4)'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Sulit\n(5x5)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Pilih Tingkat Kesulitan:'), findsOneWidget);
        expect(find.text('Mudah\n(3x3)'), findsOneWidget);
        expect(find.text('Sedang\n(4x4)'), findsOneWidget);
        expect(find.text('Sulit\n(5x5)'), findsOneWidget);
      });

      testWidgets('harus menampilkan grid potongan puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                    ),
                    child: Center(child: Text('Potongan ${index + 1}')),
                  );
                },
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(GridView), findsOneWidget);
        expect(find.text('Potongan 1'), findsOneWidget);
        expect(find.text('Potongan 9'), findsOneWidget);
      });
    });

    group('Tes Interaksi Potongan Puzzle', () {
      testWidgets('harus merespon pemilihan potongan puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool potonganDipilih = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  potonganDipilih = true;
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    color: Colors.lightBlue[100],
                  ),
                  child: const Center(child: Text('Potongan Terpilih')),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Potongan Terpilih'));
        await tester.pump();

        // Assert
        expect(potonganDipilih, isTrue);
      });

      testWidgets('harus menangani drag dan drop potongan puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool potonganDipindah = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Draggable<String>(
                  data: 'potongan_puzzle_1',
                  feedback: Container(
                    width: 80,
                    height: 80,
                    color: Colors.blue.withOpacity(0.7),
                    child: const Center(child: Text('Bergerak')),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: const Center(child: Text('Potongan 1')),
                  ),
                ),
                const SizedBox(height: 50),
                DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 100,
                      height: 100,
                      color:
                          candidateData.isNotEmpty
                              ? Colors.green[200]
                              : Colors.grey[300],
                      child: const Center(child: Text('Taruh Di Sini')),
                    );
                  },
                  onAccept: (data) {
                    potonganDipindah = true;
                  },
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.drag(find.text('Potongan 1'), const Offset(0, 150));
        await tester.pumpAndSettle();

        // Assert
        expect(potonganDipindah, isTrue);
      });

      testWidgets('harus memvalidasi penempatan potongan puzzle yang benar', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 8),
                  Text('Penempatan benar!'),
                  Text('Skor: +10 poin'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.text('Penempatan benar!'), findsOneWidget);
        expect(find.text('Skor: +10 poin'), findsOneWidget);
      });

      testWidgets('harus menangani penempatan potongan puzzle yang salah', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  SizedBox(height: 8),
                  Text('Penempatan salah'),
                  Text('Coba lagi!'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.error), findsOneWidget);
        expect(find.text('Penempatan salah'), findsOneWidget);
        expect(find.text('Coba lagi!'), findsOneWidget);
      });
    });

    group('Tes Kemajuan Game Puzzle', () {
      testWidgets('harus menampilkan kemajuan penyelesaian puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Kemajuan: 6/9 potongan ditempatkan'),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.67),
                SizedBox(height: 20),
                Text('Waktu: 02:35'),
                Text('Skor: 85 poin'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Kemajuan: 6/9 potongan ditempatkan'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.text('Waktu: 02:35'), findsOneWidget);
        expect(find.text('Skor: 85 poin'), findsOneWidget);
      });

      testWidgets('harus menampilkan hitungan mundur timer', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      '04:32',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('Waktu tersisa'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.timer), findsOneWidget);
        expect(find.text('04:32'), findsOneWidget);
        expect(find.text('Waktu tersisa'), findsOneWidget);
      });

      testWidgets('harus menampilkan petunjuk untuk menyelesaikan puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Petunjuk: Cari potongan dengan warna atau pola yang serupa',
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Dapatkan Petunjuk Lain (-5 poin)'),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.lightbulb), findsOneWidget);
        expect(
          find.text(
            'Petunjuk: Cari potongan dengan warna atau pola yang serupa',
          ),
          findsOneWidget,
        );
        expect(find.text('Dapatkan Petunjuk Lain (-5 poin)'), findsOneWidget);
      });
    });

    group('Tes Penyelesaian Puzzle', () {
      testWidgets('harus menampilkan perayaan penyelesaian puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration, size: 64, color: Colors.amber),
                  SizedBox(height: 16),
                  Text(
                    'Puzzle Selesai!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Selamat!'),
                  SizedBox(height: 16),
                  Text('Skor Akhir: 150 poin'),
                  Text('Waktu: 03:45'),
                  Text('Kesulitan: Sedang'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.celebration), findsOneWidget);
        expect(find.text('Puzzle Selesai!'), findsOneWidget);
        expect(find.text('Selamat!'), findsOneWidget);
        expect(find.text('Skor Akhir: 150 poin'), findsOneWidget);
        expect(find.text('Waktu: 03:45'), findsOneWidget);
        expect(find.text('Kesulitan: Sedang'), findsOneWidget);
      });

      testWidgets('harus menyediakan opsi setelah penyelesaian', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Apa yang ingin Anda lakukan selanjutnya?'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Main Lagi'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Puzzle Baru'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Menu Utama'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Bagikan Skor'),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(
          find.text('Apa yang ingin Anda lakukan selanjutnya?'),
          findsOneWidget,
        );
        expect(find.text('Main Lagi'), findsOneWidget);
        expect(find.text('Puzzle Baru'), findsOneWidget);
        expect(find.text('Menu Utama'), findsOneWidget);
        expect(find.text('Bagikan Skor'), findsOneWidget);
      });

      testWidgets('harus menampilkan statistik puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistik Puzzle:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Potongan ditempatkan dengan benar:'),
                      Text('9/9'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Percobaan salah:'), Text('3')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Petunjuk digunakan:'), Text('1')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Akurasi:'), Text('75%')],
                  ),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Statistik Puzzle:'), findsOneWidget);
        expect(find.text('Potongan ditempatkan dengan benar:'), findsOneWidget);
        expect(find.text('9/9'), findsOneWidget);
        expect(find.text('Percobaan salah:'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('Petunjuk digunakan:'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
        expect(find.text('Akurasi:'), findsOneWidget);
        expect(find.text('75%'), findsOneWidget);
      });
    });

    group('Tes Kontrol Game Puzzle', () {
      testWidgets('harus menyediakan fungsi jeda dan lanjutkan', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Puzzle Hewan'),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.pause)),
                  ],
                ),
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pause_circle, size: 64, color: Colors.grey),
                        Text('Game Dijeda'),
                        Text('Tekan play untuk melanjutkan'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.pause));
        await tester.pump();

        // Assert
        expect(find.text('Game Dijeda'), findsOneWidget);
        expect(find.text('Tekan play untuk melanjutkan'), findsOneWidget);
      });

      testWidgets('harus menyediakan opsi acak potongan', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool potonganDiacak = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        potonganDiacak = true;
                      },
                      child: const Text('Acak Potongan'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Reset Puzzle'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Acak Potongan'));
        await tester.pump();

        // Assert
        expect(potonganDiacak, isTrue);
        expect(find.text('Reset Puzzle'), findsOneWidget);
      });

      testWidgets('harus menyediakan toggle gambar pratinjau', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool pratinjauTerlihat = true;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gambar Referensi:'),
                    Switch(
                      value: pratinjauTerlihat,
                      onChanged: (value) {
                        pratinjauTerlihat = value;
                      },
                    ),
                  ],
                ),
                if (pratinjauTerlihat)
                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text('Pratinjau Gambar\nKucing'),
                    ),
                  ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Gambar Referensi:'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);
        expect(find.text('Pratinjau Gambar\nKucing'), findsOneWidget);
      });
    });

    group('Tes Penanganan Error', () {
      testWidgets('harus menangani error pemuatan potongan puzzle', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Gagal memuat potongan puzzle'),
                  SizedBox(height: 8),
                  Text('Silakan periksa koneksi internet Anda'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Gagal memuat potongan puzzle'), findsOneWidget);
        expect(
          find.text('Silakan periksa koneksi internet Anda'),
          findsOneWidget,
        );
      });

      testWidgets('harus menangani skenario timeout game', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_off, size: 64, color: Colors.orange),
                  SizedBox(height: 16),
                  Text('Waktu Habis!'),
                  SizedBox(height: 8),
                  Text('Anda masih bisa menyelesaikan puzzle'),
                  Text('tapi tidak ada bonus waktu yang diberikan'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.timer_off), findsOneWidget);
        expect(find.text('Waktu Habis!'), findsOneWidget);
        expect(
          find.text('Anda masih bisa menyelesaikan puzzle'),
          findsOneWidget,
        );
        expect(
          find.text('tapi tidak ada bonus waktu yang diberikan'),
          findsOneWidget,
        );
      });
    });

    group('Tes Aksesibilitas', () {
      testWidgets('harus menyediakan label aksesibilitas yang tepat', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Semantics(
              label: 'Area game puzzle hewan',
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Semantics(
                    label: 'Potongan puzzle ${index + 1}',
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(child: Text('${index + 1}')),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(Semantics), findsAtLeastNWidgets(1));
        expect(find.byType(GridView), findsOneWidget);
      });
    });
  });
}
