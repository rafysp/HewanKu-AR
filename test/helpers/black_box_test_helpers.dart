import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class BlackBoxTestHelpers {
  /// Helper untuk memuat aplikasi dengan data mock
  Future<void> pumpAppWithMockData(WidgetTester tester, Widget app) async {
    await tester.pumpWidget(app);
    await tester.pump();
  }

  /// Helper untuk menunggu animasi selesai
  Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Helper untuk mensimulasikan tap pada widget
  Future<void> tapWidget(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Helper untuk verifikasi widget ada
  void verifyWidgetExists(Finder finder, String description) {
    expect(
      finder,
      findsOneWidget,
      reason: 'Widget $description harus ditemukan',
    );
  }

  /// Helper untuk verifikasi teks ada
  void verifyTextExists(String text, String description) {
    expect(
      find.text(text),
      findsWidgets,
      reason: 'Teks "$text" harus ditemukan untuk $description',
    );
  }

  /// Helper untuk print hasil test
  void printTestResult(String testName, bool passed, [String? message]) {
    String status = passed ? '✅ BERHASIL' : '❌ GAGAL';
    print('$status: $testName');
    if (message != null) {
      print('   Detail: $message');
    }
  }

  /// Helper untuk simulasi delay network
  Future<void> simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Helper untuk scroll ke widget
  Future<void> scrollToWidget(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 100.0);
    await tester.pump();
  }
}
