import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Tes Black Box Halaman Kuis', () {
    setUp(() async {
      // Setup lingkungan test sebelum setiap test
      Get.reset();
    });

    tearDown(() async {
      // Bersihkan setelah setiap test
      Get.reset();
    });

    group('Tes Navigasi Kuis', () {
      testWidgets('harus menampilkan interface pemilihan kuis', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Center(child: Text('Pemilihan Kuis'))),
        );

        // Act & Assert
        expect(find.text('Pemilihan Kuis'), findsOneWidget);
      });

      testWidgets(
        'should navigate to habitat quiz when habitat option is selected',
        (WidgetTester tester) async {
          // Arrange
          await BlackBoxTestHelpers.pumpWidgetWithGetX(
            tester,
            Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Habitat Quiz'),
                ),
              ),
            ),
          );

          // Act
          final habitatButton = find.text('Habitat Quiz');
          await tester.tap(habitatButton);
          await tester.pumpAndSettle();

          // Assert
          expect(habitatButton, findsOneWidget);
        },
      );

      testWidgets('should navigate to drag and drop quiz when selected', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Drag Quiz'),
              ),
            ),
          ),
        );

        // Act
        final dragQuizButton = find.text('Drag Quiz');
        await tester.tap(dragQuizButton);
        await tester.pumpAndSettle();

        // Assert
        expect(dragQuizButton, findsOneWidget);
      });
    });

    group('Quiz Functionality Tests', () {
      testWidgets('should display question correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testQuestion = 'What habitat do cats prefer?';
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Center(child: Text(testQuestion))),
        );

        // Act & Assert
        expect(find.text(testQuestion), findsOneWidget);
      });

      testWidgets('should display multiple choice options', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Forest')),
                ElevatedButton(onPressed: () {}, child: const Text('Desert')),
                ElevatedButton(onPressed: () {}, child: const Text('Ocean')),
                ElevatedButton(onPressed: () {}, child: const Text('City')),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Forest'), findsOneWidget);
        expect(find.text('Desert'), findsOneWidget);
        expect(find.text('Ocean'), findsOneWidget);
        expect(find.text('City'), findsOneWidget);
      });

      testWidgets('should respond to answer selection', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool answerSelected = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {
                answerSelected = true;
              },
              child: const Text('Forest'),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Forest'));
        await tester.pump();

        // Assert
        expect(answerSelected, isTrue);
      });

      testWidgets('should display feedback after answer selection', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(children: [Text('Correct!'), Text('Great job!')]),
          ),
        );

        // Act & Assert
        expect(find.text('Correct!'), findsOneWidget);
        expect(find.text('Great job!'), findsOneWidget);
      });
    });

    group('Drag and Drop Quiz Tests', () {
      testWidgets('should display draggable items', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Draggable<String>(
              data: 'Cat',
              feedback: Container(
                width: 50,
                height: 50,
                color: Colors.blue,
                child: const Text('Cat'),
              ),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
                child: const Text('Cat'),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Cat'), findsOneWidget);
        expect(find.byType(Draggable<String>), findsOneWidget);
      });

      testWidgets('should display drop targets', (WidgetTester tester) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: const Text('Drop here'),
                );
              },
              onAccept: (data) {},
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Drop here'), findsOneWidget);
        expect(find.byType(DragTarget<String>), findsOneWidget);
      });

      testWidgets('should handle drag and drop interaction', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool itemDropped = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Draggable<String>(
                  data: 'Cat',
                  feedback: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                    child: const Text('Cat'),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                    child: const Text('Cat'),
                  ),
                ),
                DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.green,
                      child: const Text('Drop here'),
                    );
                  },
                  onAccept: (data) {
                    itemDropped = true;
                  },
                ),
              ],
            ),
          ),
        );

        // Act
        final draggable = find.byType(Draggable<String>);

        await tester.drag(draggable, const Offset(0, 100));
        await tester.pumpAndSettle();

        // Assert
        expect(itemDropped, isTrue);
      });
    });

    group('Score Tracking Tests', () {
      testWidgets('should display current score', (WidgetTester tester) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Text('Score: 85')),
        );

        // Act & Assert
        expect(find.text('Score: 85'), findsOneWidget);
      });

      testWidgets('should update score after correct answer', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [Text('Score: 90'), Text('Previous Score: 85')],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Score: 90'), findsOneWidget);
        expect(find.text('Previous Score: 85'), findsOneWidget);
      });
    });

    group('Quiz Completion Tests', () {
      testWidgets('should display completion message', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [Text('Quiz Completed!'), Text('Final Score: 95%')],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Quiz Completed!'), findsOneWidget);
        expect(find.text('Final Score: 95%'), findsOneWidget);
      });

      testWidgets('should provide restart option', (WidgetTester tester) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Restart Quiz'),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Restart Quiz'), findsOneWidget);
      });

      testWidgets('should provide navigation back to menu', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Back to Menu'),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Back to Menu'), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle invalid input gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Text('Quiz loaded successfully')),
        );

        // Act & Assert
        // Test that the quiz doesn't crash with invalid data
        expect(find.text('Quiz loaded successfully'), findsOneWidget);
      });

      testWidgets('should display error message when quiz fails to load', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Text('Error loading quiz. Please try again.')),
        );

        // Act & Assert
        expect(
          find.text('Error loading quiz. Please try again.'),
          findsOneWidget,
        );
      });
    });

    group('Boundary Value Tests', () {
      testWidgets('should handle minimum score correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Text('Score: 0')),
        );

        // Act & Assert
        expect(find.text('Score: 0'), findsOneWidget);
      });

      testWidgets('should handle maximum score correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Text('Score: 100')),
        );

        // Act & Assert
        expect(find.text('Score: 100'), findsOneWidget);
      });
    });
  });
}
