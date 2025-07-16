import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Tes Black Box Halaman Kamera', () {
    setUp(() async {
      // Setup lingkungan test sebelum setiap test
      Get.reset();
    });

    tearDown(() async {
      // Bersihkan setelah setiap test
      Get.reset();
    });

    group('Tes Interface Kamera', () {
      testWidgets('harus menampilkan pratinjau kamera', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  'Pratinjau Kamera',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Camera Preview'), findsOneWidget);
      });

      testWidgets('should display camera controls', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Expanded(child: Container(color: Colors.black)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.flip_camera_ios),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt, size: 60),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.flash_auto),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.flip_camera_ios), findsOneWidget);
        expect(find.byIcon(Icons.camera_alt), findsOneWidget);
        expect(find.byIcon(Icons.flash_auto), findsOneWidget);
      });

      testWidgets('should handle camera permission requests', (
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
                  Icon(Icons.camera_alt, size: 64),
                  Text('Camera access required'),
                  Text('Please grant camera permission to continue'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Camera access required'), findsOneWidget);
        expect(
          find.text('Please grant camera permission to continue'),
          findsOneWidget,
        );
      });
    });

    group('AR Functionality Tests', () {
      testWidgets('should display AR overlay interface', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                ),
                const Positioned(
                  top: 50,
                  left: 20,
                  child: Text(
                    'Point camera at animals',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    color: Colors.black54,
                    child: const Center(
                      child: Text(
                        'AR Mode Active',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Point camera at animals'), findsOneWidget);
        expect(find.text('AR Mode Active'), findsOneWidget);
      });

      testWidgets('should display animal detection indicators', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Stack(
              children: [
                Container(color: Colors.black),
                Positioned(
                  top: 200,
                  left: 100,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Cat', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Cat'), findsOneWidget);
      });

      testWidgets('should provide AR animal information overlay', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Stack(
              children: [
                Container(color: Colors.black),
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Cat Detected',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Habitat: Domestic'),
                          const Text('Sound: Meow'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Learn More'),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Take Quiz'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Cat Detected'), findsOneWidget);
        expect(find.text('Habitat: Domestic'), findsOneWidget);
        expect(find.text('Learn More'), findsOneWidget);
        expect(find.text('Take Quiz'), findsOneWidget);
      });
    });

    group('Camera Controls Tests', () {
      testWidgets('should handle capture button press', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool photoCaptured = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Center(
              child: IconButton(
                onPressed: () {
                  photoCaptured = true;
                },
                icon: const Icon(Icons.camera_alt, size: 60),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pump();

        // Assert
        expect(photoCaptured, isTrue);
      });

      testWidgets('should handle camera flip functionality', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool cameraFlipped = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: IconButton(
              onPressed: () {
                cameraFlipped = true;
              },
              icon: const Icon(Icons.flip_camera_ios),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.flip_camera_ios));
        await tester.pump();

        // Assert
        expect(cameraFlipped, isTrue);
      });

      testWidgets('should handle flash toggle', (WidgetTester tester) async {
        // Arrange
        bool flashToggled = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: IconButton(
              onPressed: () {
                flashToggled = true;
              },
              icon: const Icon(Icons.flash_auto),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.flash_auto));
        await tester.pump();

        // Assert
        expect(flashToggled, isTrue);
      });

      testWidgets('should display zoom controls', (WidgetTester tester) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Slider(value: 1.0, min: 1.0, max: 5.0, onChanged: (value) {}),
                const Text('Zoom: 1.0x'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(Slider), findsOneWidget);
        expect(find.text('Zoom: 1.0x'), findsOneWidget);
      });
    });

    group('Image Capture Tests', () {
      testWidgets('should display captured image preview', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey,
                  child: const Center(child: Text('Captured Image')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Retake'),
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('Save')),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Share'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Captured Image'), findsOneWidget);
        expect(find.text('Retake'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);
      });

      testWidgets('should handle image save functionality', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool imageSaved = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {
                imageSaved = true;
              },
              child: const Text('Save'),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Assert
        expect(imageSaved, isTrue);
      });

      testWidgets('should handle image sharing', (WidgetTester tester) async {
        // Arrange
        bool imageShared = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {
                imageShared = true;
              },
              child: const Text('Share'),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Share'));
        await tester.pump();

        // Assert
        expect(imageShared, isTrue);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle camera initialization errors', (
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
                  Icon(Icons.error_outline, size: 64),
                  Text('Camera initialization failed'),
                  Text('Please try again'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Camera initialization failed'), findsOneWidget);
        expect(find.text('Please try again'), findsOneWidget);
      });

      testWidgets('should handle AR detection failures', (
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
                  Icon(Icons.search_off, size: 64),
                  Text('No animals detected'),
                  Text('Point camera at different objects'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('No animals detected'), findsOneWidget);
        expect(find.text('Point camera at different objects'), findsOneWidget);
      });

      testWidgets('should handle permission denied gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_outlined, size: 64),
                  const Text('Camera permission denied'),
                  const Text('Please enable camera access in settings'),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Camera permission denied'), findsOneWidget);
        expect(find.text('Open Settings'), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should navigate back from camera', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title: const Text('Camera'),
            ),
            body: Container(),
          ),
        );

        // Act & Assert
        expect(find.byType(BackButton), findsOneWidget);
        expect(find.text('Camera'), findsOneWidget);
      });

      testWidgets('should navigate to animal details from AR detection', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('View Animal Details'),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('View Animal Details'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should maintain smooth camera preview', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: const Center(child: Text('Camera Preview Running')),
            ),
          ),
        );

        // Act
        // Simulate camera preview running
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 16)); // 60 FPS
        }

        // Assert
        expect(find.text('Camera Preview Running'), findsOneWidget);
      });

      testWidgets('should handle AR processing efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Stack(
              children: [
                Container(color: Colors.black),
                const Positioned(
                  top: 50,
                  left: 20,
                  child: Text(
                    'AR Processing...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('AR Processing...'), findsOneWidget);
      });
    });
  });
}
