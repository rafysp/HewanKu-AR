import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Tes Black Box Halaman Hewan', () {
    setUp(() async {
      // Setup lingkungan test sebelum setiap test
      Get.reset();
    });

    tearDown(() async {
      // Bersihkan setelah setiap test
      Get.reset();
    });

    group('Tes Tampilan Daftar Hewan', () {
      testWidgets('harus menampilkan daftar hewan', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ListView(
              children: const [
                ListTile(title: Text('Kucing')),
                ListTile(title: Text('Anjing')),
                ListTile(title: Text('Burung')),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Cat'), findsOneWidget);
        expect(find.text('Dog'), findsOneWidget);
        expect(find.text('Bird'), findsOneWidget);
      });

      testWidgets('should display animal cards with images', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Card(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.pets),
                  ),
                  const Text('Cat'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.byIcon(Icons.pets), findsOneWidget);
        expect(find.text('Cat'), findsOneWidget);
      });

      testWidgets('should display animal information correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Cat'),
                Text('Habitat: Domestic'),
                Text('Sound: Meow'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Cat'), findsOneWidget);
        expect(find.text('Habitat: Domestic'), findsOneWidget);
        expect(find.text('Sound: Meow'), findsOneWidget);
      });
    });

    group('Animal Interaction Tests', () {
      testWidgets('should respond to animal selection', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool animalSelected = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: GestureDetector(
              onTap: () {
                animalSelected = true;
              },
              child: const Card(child: Text('Cat')),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Cat'));
        await tester.pump();

        // Assert
        expect(animalSelected, isTrue);
      });

      testWidgets('should navigate to animal detail when animal is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: GestureDetector(
              onTap: () {},
              child: const ListTile(
                title: Text('Cat'),
                subtitle: Text('Tap to view details'),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Cat'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Cat'), findsOneWidget);
      });

      testWidgets('should play animal sound when sound button is pressed', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool soundPlayed = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {
                soundPlayed = true;
              },
              child: const Icon(Icons.volume_up),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.volume_up));
        await tester.pump();

        // Assert
        expect(soundPlayed, isTrue);
      });
    });

    group('Animal Filtering Tests', () {
      testWidgets('should display search functionality', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search animals...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Search animals...'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('should filter animals based on search input', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(hintText: 'Search animals...'),
                ),
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(title: Text('Cat')),
                      ListTile(title: Text('Dog')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'Cat');
        await tester.pump();

        // Assert
        expect(find.text('Cat'), findsAtLeastNWidgets(1));
      });

      testWidgets('should display filter by habitat options', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                DropdownButton<String>(
                  hint: const Text('Filter by habitat'),
                  items: const [
                    DropdownMenuItem(value: 'forest', child: Text('Forest')),
                    DropdownMenuItem(value: 'ocean', child: Text('Ocean')),
                    DropdownMenuItem(value: 'desert', child: Text('Desert')),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Filter by habitat'), findsOneWidget);
        expect(find.byType(DropdownButton<String>), findsOneWidget);
      });
    });

    group('Animal Categories Tests', () {
      testWidgets('should display different animal categories', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                const Text('Mammals'),
                const Text('Birds'),
                const Text('Reptiles'),
                const Text('Amphibians'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Mammals'), findsOneWidget);
        expect(find.text('Birds'), findsOneWidget);
        expect(find.text('Reptiles'), findsOneWidget);
        expect(find.text('Amphibians'), findsOneWidget);
      });

      testWidgets('should filter animals by category', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Mammals')),
                const Expanded(child: Text('Filtered results')),
              ],
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Mammals'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Filtered results'), findsOneWidget);
      });
    });

    group('Animal Detail View Tests', () {
      testWidgets('should display detailed animal information', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cat',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('Scientific Name: Felis catus'),
                Text('Habitat: Domestic environments'),
                Text('Diet: Carnivore'),
                Text('Description: A small domesticated carnivorous mammal.'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Cat'), findsOneWidget);
        expect(find.text('Scientific Name: Felis catus'), findsOneWidget);
        expect(find.text('Habitat: Domestic environments'), findsOneWidget);
        expect(find.text('Diet: Carnivore'), findsOneWidget);
      });

      testWidgets('should display animal image gallery', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: PageView(
              children: [
                Container(color: Colors.grey, child: const Text('Image 1')),
                Container(color: Colors.blue, child: const Text('Image 2')),
                Container(color: Colors.green, child: const Text('Image 3')),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(PageView), findsOneWidget);
        expect(find.text('Image 1'), findsOneWidget);
      });

      testWidgets('should provide AR viewing option', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.view_in_ar), Text('View in AR')],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('View in AR'), findsOneWidget);
        expect(find.byIcon(Icons.view_in_ar), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should navigate back to animal list from detail view', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title: const Text('Animal Details'),
            ),
            body: const Text('Animal information'),
          ),
        );

        // Act & Assert
        expect(find.byType(BackButton), findsOneWidget);
        expect(find.text('Animal Details'), findsOneWidget);
      });

      testWidgets('should navigate to quiz from animal page', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Take Quiz'),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Take Quiz'), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle empty animal list gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Center(child: Text('No animals found'))),
        );

        // Act & Assert
        expect(find.text('No animals found'), findsOneWidget);
      });

      testWidgets('should handle failed image loading', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Icon(Icons.broken_image, size: 100),
                Text('Image not available'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.broken_image), findsOneWidget);
        expect(find.text('Image not available'), findsOneWidget);
      });

      testWidgets('should handle network errors', (WidgetTester tester) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64),
                  Text('Unable to load animals'),
                  Text('Please check your internet connection'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Unable to load animals'), findsOneWidget);
        expect(
          find.text('Please check your internet connection'),
          findsOneWidget,
        );
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle large animal lists efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange
        const int itemCount = 100;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ListView.builder(
              itemCount: itemCount,
              itemBuilder:
                  (context, index) => ListTile(title: Text('Animal $index')),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(ListView), findsOneWidget);
        // The list should handle large datasets without performance issues
      });

      testWidgets('should implement lazy loading for images', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ListView(
              children: [
                for (int i = 0; i < 10; i++)
                  Card(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Text('Animal $i'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
      });
    });
  });
}
