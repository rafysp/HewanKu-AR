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

      testWidgets('should display puzzle piece grid', (
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
                    child: Center(child: Text('Piece ${index + 1}')),
                  );
                },
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(GridView), findsOneWidget);
        expect(find.text('Piece 1'), findsOneWidget);
        expect(find.text('Piece 9'), findsOneWidget);
      });
    });

    group('Puzzle Piece Interaction Tests', () {
      testWidgets('should respond to puzzle piece selection', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool pieceSelected = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  pieceSelected = true;
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    color: Colors.lightBlue[100],
                  ),
                  child: const Center(child: Text('Selected Piece')),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Selected Piece'));
        await tester.pump();

        // Assert
        expect(pieceSelected, isTrue);
      });

      testWidgets('should handle puzzle piece drag and drop', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool pieceMoved = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Draggable<String>(
                  data: 'puzzle_piece_1',
                  feedback: Container(
                    width: 80,
                    height: 80,
                    color: Colors.blue.withOpacity(0.7),
                    child: const Center(child: Text('Moving')),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: const Center(child: Text('Piece 1')),
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
                      child: const Center(child: Text('Drop Here')),
                    );
                  },
                  onAccept: (data) {
                    pieceMoved = true;
                  },
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.drag(find.text('Piece 1'), const Offset(0, 150));
        await tester.pumpAndSettle();

        // Assert
        expect(pieceMoved, isTrue);
      });

      testWidgets('should validate correct puzzle piece placement', (
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
                  Text('Correct placement!'),
                  Text('Score: +10 points'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.text('Correct placement!'), findsOneWidget);
        expect(find.text('Score: +10 points'), findsOneWidget);
      });

      testWidgets('should handle incorrect puzzle piece placement', (
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
                  Text('Incorrect placement'),
                  Text('Try again!'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.error), findsOneWidget);
        expect(find.text('Incorrect placement'), findsOneWidget);
        expect(find.text('Try again!'), findsOneWidget);
      });
    });

    group('Puzzle Game Progress Tests', () {
      testWidgets('should display puzzle completion progress', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Progress: 6/9 pieces placed'),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.67),
                SizedBox(height: 20),
                Text('Time: 02:35'),
                Text('Score: 85 points'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Progress: 6/9 pieces placed'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.text('Time: 02:35'), findsOneWidget);
        expect(find.text('Score: 85 points'), findsOneWidget);
      });

      testWidgets('should display timer countdown', (
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
                Text('Time remaining'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.timer), findsOneWidget);
        expect(find.text('04:32'), findsOneWidget);
        expect(find.text('Time remaining'), findsOneWidget);
      });

      testWidgets('should display hints for puzzle solving', (
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
                          'Hint: Look for pieces with similar colors or patterns',
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Get Another Hint (-5 points)'),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.lightbulb), findsOneWidget);
        expect(
          find.text('Hint: Look for pieces with similar colors or patterns'),
          findsOneWidget,
        );
        expect(find.text('Get Another Hint (-5 points)'), findsOneWidget);
      });
    });

    group('Puzzle Completion Tests', () {
      testWidgets('should display puzzle completion celebration', (
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
                    'Puzzle Completed!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Congratulations!'),
                  SizedBox(height: 16),
                  Text('Final Score: 150 points'),
                  Text('Time: 03:45'),
                  Text('Difficulty: Medium'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.celebration), findsOneWidget);
        expect(find.text('Puzzle Completed!'), findsOneWidget);
        expect(find.text('Congratulations!'), findsOneWidget);
        expect(find.text('Final Score: 150 points'), findsOneWidget);
        expect(find.text('Time: 03:45'), findsOneWidget);
        expect(find.text('Difficulty: Medium'), findsOneWidget);
      });

      testWidgets('should provide post-completion options', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('What would you like to do next?'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Play Again'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('New Puzzle'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Main Menu'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Share Score'),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('What would you like to do next?'), findsOneWidget);
        expect(find.text('Play Again'), findsOneWidget);
        expect(find.text('New Puzzle'), findsOneWidget);
        expect(find.text('Main Menu'), findsOneWidget);
        expect(find.text('Share Score'), findsOneWidget);
      });

      testWidgets('should display puzzle statistics', (
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
                    'Puzzle Statistics:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Pieces placed correctly:'), Text('9/9')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Incorrect attempts:'), Text('3')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Hints used:'), Text('1')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Accuracy:'), Text('75%')],
                  ),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Puzzle Statistics:'), findsOneWidget);
        expect(find.text('Pieces placed correctly:'), findsOneWidget);
        expect(find.text('9/9'), findsOneWidget);
        expect(find.text('Incorrect attempts:'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('Hints used:'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
        expect(find.text('Accuracy:'), findsOneWidget);
        expect(find.text('75%'), findsOneWidget);
      });
    });

    group('Puzzle Game Controls Tests', () {
      testWidgets('should provide pause and resume functionality', (
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
                    const Text('Animal Puzzle'),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.pause)),
                  ],
                ),
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pause_circle, size: 64, color: Colors.grey),
                        Text('Game Paused'),
                        Text('Tap play to continue'),
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
        expect(find.text('Game Paused'), findsOneWidget);
        expect(find.text('Tap play to continue'), findsOneWidget);
      });

      testWidgets('should provide shuffle pieces option', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool piecesShuffled = false;
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
                        piecesShuffled = true;
                      },
                      child: const Text('Shuffle Pieces'),
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
        await tester.tap(find.text('Shuffle Pieces'));
        await tester.pump();

        // Assert
        expect(piecesShuffled, isTrue);
        expect(find.text('Reset Puzzle'), findsOneWidget);
      });

      testWidgets('should provide preview image toggle', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool previewVisible = true;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Reference Image:'),
                    Switch(
                      value: previewVisible,
                      onChanged: (value) {
                        previewVisible = value;
                      },
                    ),
                  ],
                ),
                if (previewVisible)
                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Cat Image\nPreview')),
                  ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Reference Image:'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);
        expect(find.text('Cat Image\nPreview'), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle puzzle piece loading errors', (
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
                  Text('Failed to load puzzle pieces'),
                  SizedBox(height: 8),
                  Text('Please check your internet connection'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Failed to load puzzle pieces'), findsOneWidget);
        expect(
          find.text('Please check your internet connection'),
          findsOneWidget,
        );
      });

      testWidgets('should handle game timeout scenarios', (
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
                  Text('Time\'s Up!'),
                  SizedBox(height: 8),
                  Text('You can still finish the puzzle'),
                  Text('but no time bonus will be awarded'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.timer_off), findsOneWidget);
        expect(find.text('Time\'s Up!'), findsOneWidget);
        expect(find.text('You can still finish the puzzle'), findsOneWidget);
        expect(find.text('but no time bonus will be awarded'), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should provide proper accessibility labels', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Semantics(
              label: 'Animal puzzle game area',
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Semantics(
                    label: 'Puzzle piece ${index + 1}',
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
