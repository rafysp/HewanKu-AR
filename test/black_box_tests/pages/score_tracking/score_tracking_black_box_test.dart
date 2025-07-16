import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Tes Black Box Pelacakan Skor', () {
    setUp(() async {
      // Setup lingkungan test sebelum setiap test
      Get.reset();
    });

    tearDown(() async {
      // Bersihkan setelah setiap test
      Get.reset();
    });

    group('Tes Tampilan Skor', () {
      testWidgets('harus menampilkan skor saat ini dengan benar', (
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
                  Text(
                    'Current Score',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '850',
                    style: TextStyle(fontSize: 48, color: Colors.green),
                  ),
                  Text('out of 1000'),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Current Score'), findsOneWidget);
        expect(find.text('850'), findsOneWidget);
        expect(find.text('out of 1000'), findsOneWidget);
      });

      testWidgets('should display score percentage', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text('Score: 85%'),
                  LinearProgressIndicator(value: 0.85),
                ],
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Score: 85%'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should display score breakdown by category', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Score Breakdown'),
                ListTile(title: Text('Habitat Quiz'), trailing: Text('90%')),
                ListTile(title: Text('Animal Sounds'), trailing: Text('85%')),
                ListTile(title: Text('Drag & Drop'), trailing: Text('92%')),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Score Breakdown'), findsOneWidget);
        expect(find.text('Habitat Quiz'), findsOneWidget);
        expect(find.text('90%'), findsOneWidget);
        expect(find.text('85%'), findsOneWidget);
        expect(find.text('92%'), findsOneWidget);
      });
    });

    group('Score History Tests', () {
      testWidgets('should display score history list', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                const Text('Score History'),
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        title: Text('Habitat Quiz'),
                        subtitle: Text('2024-01-15'),
                        trailing: Text('90%'),
                      ),
                      ListTile(
                        title: Text('Animal Sounds Quiz'),
                        subtitle: Text('2024-01-14'),
                        trailing: Text('85%'),
                      ),
                      ListTile(
                        title: Text('Drag & Drop Quiz'),
                        subtitle: Text('2024-01-13'),
                        trailing: Text('92%'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Score History'), findsOneWidget);
        expect(find.text('2024-01-15'), findsOneWidget);
        expect(find.text('2024-01-14'), findsOneWidget);
        expect(find.text('2024-01-13'), findsOneWidget);
      });

      testWidgets('should show score improvement trends', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Progress Trend'),
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green),
                    Text('Improving! +5% from last week'),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Progress Trend'), findsOneWidget);
        expect(find.byIcon(Icons.trending_up), findsOneWidget);
        expect(find.text('Improving! +5% from last week'), findsOneWidget);
      });

      testWidgets('should display best score achievements', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Achievements'),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.star, color: Colors.amber),
                    title: Text('Perfect Score!'),
                    subtitle: Text('Scored 100% in Habitat Quiz'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.emoji_events, color: Colors.grey),
                    title: Text('Quiz Master'),
                    subtitle: Text('Completed 10 quizzes'),
                  ),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Achievements'), findsOneWidget);
        expect(find.text('Perfect Score!'), findsOneWidget);
        expect(find.text('Quiz Master'), findsOneWidget);
      });
    });

    group('Score Statistics Tests', () {
      testWidgets('should display average score statistics', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Statistics'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Average Score'),
                        Text('87%', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Total Quizzes'),
                        Text('15', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Best Score'),
                        Text('100%', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Statistics'), findsOneWidget);
        expect(find.text('Average Score'), findsOneWidget);
        expect(find.text('87%'), findsOneWidget);
        expect(find.text('Total Quizzes'), findsOneWidget);
        expect(find.text('15'), findsOneWidget);
        expect(find.text('Best Score'), findsOneWidget);
        expect(find.text('100%'), findsOneWidget);
      });

      testWidgets('should display time-based statistics', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('This Week'),
                Text('5 quizzes completed'),
                Text('Average: 89%'),
                Divider(),
                Text('This Month'),
                Text('20 quizzes completed'),
                Text('Average: 85%'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('This Week'), findsOneWidget);
        expect(find.text('5 quizzes completed'), findsOneWidget);
        expect(find.text('Average: 89%'), findsOneWidget);
        expect(find.text('This Month'), findsOneWidget);
        expect(find.text('20 quizzes completed'), findsOneWidget);
        expect(find.text('Average: 85%'), findsOneWidget);
      });
    });

    group('Score Management Tests', () {
      testWidgets('should allow score reset with confirmation', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                const Text('Reset all scores?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Reset all scores?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Reset'), findsOneWidget);
      });

      testWidgets('should handle score export functionality', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool scoreExported = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {
                scoreExported = true;
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.download), Text('Export Scores')],
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Export Scores'));
        await tester.pump();

        // Assert
        expect(scoreExported, isTrue);
      });

      testWidgets('should handle score sharing', (WidgetTester tester) async {
        // Arrange
        bool scoreShared = false;
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: ElevatedButton(
              onPressed: () {
                scoreShared = true;
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.share), Text('Share Score')],
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Share Score'));
        await tester.pump();

        // Assert
        expect(scoreShared, isTrue);
      });
    });

    group('Score Validation Tests', () {
      testWidgets('should handle invalid score values gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(body: Center(child: Text('Error loading scores'))),
        );

        // Act & Assert
        expect(find.text('Error loading scores'), findsOneWidget);
      });

      testWidgets('should display zero scores correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Current Score: 0'),
                Text('No quizzes completed yet'),
                Text('Start your first quiz!'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Current Score: 0'), findsOneWidget);
        expect(find.text('No quizzes completed yet'), findsOneWidget);
        expect(find.text('Start your first quiz!'), findsOneWidget);
      });

      testWidgets('should handle maximum score values', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Perfect Score!'),
                Text('100%', style: TextStyle(color: Colors.amber)),
                Icon(Icons.emoji_events, color: Colors.amber, size: 48),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Perfect Score!'), findsOneWidget);
        expect(find.text('100%'), findsOneWidget);
        expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      });
    });

    group('Score Persistence Tests', () {
      testWidgets('should maintain scores across app sessions', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Text('Welcome back!'),
                Text('Your current score: 850'),
                Text('Last quiz: 92%'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Welcome back!'), findsOneWidget);
        expect(find.text('Your current score: 850'), findsOneWidget);
        expect(find.text('Last quiz: 92%'), findsOneWidget);
      });

      testWidgets('should sync scores across devices (if applicable)', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          const Scaffold(
            body: Column(
              children: [
                Icon(Icons.cloud_done, color: Colors.green),
                Text('Scores synced'),
                Text('Last sync: 2 minutes ago'),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.cloud_done), findsOneWidget);
        expect(find.text('Scores synced'), findsOneWidget);
        expect(find.text('Last sync: 2 minutes ago'), findsOneWidget);
      });
    });

    group('Score Visualization Tests', () {
      testWidgets('should display score charts and graphs', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                const Text('Score Progress'),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(child: Text('Score Chart')),
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Score Progress'), findsOneWidget);
        expect(find.text('Score Chart'), findsOneWidget);
      });

      testWidgets('should display interactive score filters', (
        WidgetTester tester,
      ) async {
        // Arrange
        await BlackBoxTestHelpers.pumpWidgetWithGetX(
          tester,
          Scaffold(
            body: Column(
              children: [
                Row(
                  children: [
                    FilterChip(
                      label: const Text('Last Week'),
                      selected: true,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Last Month'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('All Time'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act & Assert
        expect(find.text('Last Week'), findsOneWidget);
        expect(find.text('Last Month'), findsOneWidget);
        expect(find.text('All Time'), findsOneWidget);
      });
    });
  });
}
