import 'package:flutter_test/flutter_test.dart';

// Import all black box test suites
import 'pages/home/home_page_black_box_test.dart' as home_tests;
import 'pages/quiz/quiz_black_box_test.dart' as quiz_tests;
import 'pages/animals/animals_page_black_box_test.dart' as animals_tests;
import 'pages/camera/camera_page_black_box_test.dart' as camera_tests;
import 'pages/score_tracking/score_tracking_black_box_test.dart' as score_tests;
import 'integration/app_integration_black_box_test.dart' as integration_tests;

void main() {
  // Set global test timeout to prevent hanging tests
  setUpAll(() {
    // Configure test environment
  });

  group('HewanKu AR - Complete Black Box Test Suite', () {
    group('Page-Level Tests', () {
      home_tests.main();
      quiz_tests.main();
      animals_tests.main();
      camera_tests.main();
      score_tests.main();
    });

    group('Integration Tests', () {
      integration_tests.main();
    });
  });
}
