import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// Test helper utilities for black box testing
class BlackBoxTestHelpers {
  /// Pumps the widget with GetMaterialApp wrapper
  static Future<void> pumpWidgetWithGetX(
    WidgetTester tester,
    Widget widget, {
    List<Bind> bindings = const [],
  }) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialBinding: BindingsBuilder(() {
          for (var binding in bindings) {
            Get.put(binding.dependency, permanent: binding.permanent);
          }
        }),
        home: widget,
      ),
    );
  }

  /// Finds a widget by its text content
  static Finder findByText(String text) {
    return find.text(text);
  }

  /// Finds a widget by its key
  static Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  /// Finds a widget by its icon
  static Finder findByIcon(IconData icon) {
    return find.byIcon(icon);
  }

  /// Finds a widget by its type
  static Finder findByType<T>() {
    return find.byType(T);
  }

  /// Taps a widget and pumps the frame
  static Future<void> tapAndPump(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Taps a widget and pumps until settled
  static Future<void> tapAndPumpAndSettle(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Safely taps a widget if it exists and is tappable
  static Future<bool> safeTap(WidgetTester tester, Finder finder) async {
    try {
      if (finder.evaluate().isNotEmpty) {
        await tester.tap(finder, warnIfMissed: false);
        await tester.pumpAndSettle();
        return true;
      }
      return false;
    } catch (e) {
      // If tap fails for any reason, return false but don't crash the test
      return false;
    }
  }

  /// Enters text into a text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Scrolls to find a widget
  static Future<void> scrollToFind(
    WidgetTester tester,
    Finder finder,
    Finder scrollable,
  ) async {
    await tester.scrollUntilVisible(finder, 100.0, scrollable: scrollable);
  }

  /// Verifies that a widget exists
  static void verifyWidgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Verifies that a widget does not exist
  static void verifyWidgetNotExists(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verifies that multiple widgets exist
  static void verifyMultipleWidgetsExist(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }

  /// Verifies that at least one widget exists
  static void verifyAtLeastOneWidgetExists(Finder finder) {
    expect(finder, findsAtLeastNWidgets(1));
  }

  /// Waits for a specific duration
  static Future<void> wait(Duration duration) async {
    await Future.delayed(duration);
  }

  /// Pumps frames for a specific duration
  static Future<void> pumpFor(WidgetTester tester, Duration duration) async {
    await tester.pump(duration);
  }

  /// Common test setup for pages
  static Future<void> setupTestEnvironment(WidgetTester tester) async {
    // Reset GetX state
    Get.reset();

    // Set up any common test configurations
    // Additional setup can be added here as needed
  }

  /// Clean up after tests
  static Future<void> tearDownTestEnvironment() async {
    Get.reset();
  }
}

/// Binding helper for dependency injection in tests
class Bind {
  final dynamic dependency;
  final bool permanent;

  const Bind(this.dependency, {this.permanent = false});
}

/// Common test data for black box testing
class TestData {
  // Sample quiz data
  static const Map<String, dynamic> sampleQuizQuestion = {
    'question': 'What sound does a cat make?',
    'options': ['Meow', 'Bark', 'Moo', 'Roar'],
    'correctAnswer': 'Meow',
  };

  // Sample animal data
  static const Map<String, dynamic> sampleAnimal = {
    'name': 'Cat',
    'habitat': 'Domestic',
    'sound': 'Meow',
    'description': 'A small domesticated carnivorous mammal',
  };

  // Test navigation routes
  static const String homeRoute = '/home';
  static const String quizRoute = '/quiz';
  static const String animalsRoute = '/animals';
  static const String cameraRoute = '/camera';
  static const String scoreRoute = '/score';
}

/// Test matchers for custom assertions
class BlackBoxMatchers {
  /// Matches if the widget is displayed on screen
  static Matcher isDisplayed() {
    return findsOneWidget;
  }

  /// Matches if the widget is not displayed on screen
  static Matcher isNotDisplayed() {
    return findsNothing;
  }

  /// Matches if multiple widgets are displayed
  static Matcher displaysCount(int count) {
    return findsNWidgets(count);
  }

  /// Matches if at least one widget is displayed
  static Matcher displaysAtLeast(int count) {
    return findsAtLeastNWidgets(count);
  }
}
