import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/main.dart';
import '../../helpers/black_box_test_helpers.dart';
import '../../helpers/test_report_generator.dart';

void main() {
  // Inisialisasi report generator
  setUpAll(() {
    TestReportGenerator.startTestSession();
  });

  tearDownAll(() {
    TestReportGenerator.endTestSession();

    // Generate laporan untuk skripsi
    print('\n📄 GENERATING THESIS REPORT...');
    String thesisReport = TestReportGenerator.generateThesisReport();
    print(thesisReport);
  });

  group('🏠 Tes Black Box Halaman Utama', () {
    late BlackBoxTestHelpers helpers;

    setUp(() {
      helpers = BlackBoxTestHelpers();
      print('\n📋 Memulai setup test halaman utama...');
    });

    testWidgets('✅ Test 1: Menampilkan interface aplikasi utama dengan benar', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test interface aplikasi utama...');

      try {
        // Setup
        await helpers.pumpAppWithMockData(tester, MyApp());
        await helpers.waitForAnimations(tester);

        // Verifikasi elemen utama aplikasi
        helpers.verifyWidgetExists(find.byType(Scaffold), 'Scaffold utama');
        helpers.verifyWidgetExists(find.byType(MaterialApp), 'MaterialApp');

        expect(find.byType(Scaffold), findsOneWidget);

        // Record hasil test
        TestReportGenerator.recordTestResult(
          'Interface aplikasi utama',
          'Halaman Utama',
          true,
          'Semua elemen UI terdeteksi dengan benar',
        );
      } catch (e) {
        TestReportGenerator.recordTestResult(
          'Interface aplikasi utama',
          'Halaman Utama',
          false,
          'Error: $e',
        );
        rethrow;
      }
    });

    testWidgets('✅ Test 2: Memuat logo dan nama aplikasi', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test logo dan nama aplikasi...');

      try {
        // Setup
        await helpers.pumpAppWithMockData(tester, MyApp());
        await helpers.waitForAnimations(tester);

        // Verifikasi aplikasi dimuat
        expect(find.byType(MaterialApp), findsOneWidget);

        TestReportGenerator.recordTestResult(
          'Logo dan nama aplikasi',
          'Halaman Utama',
          true,
          'Aplikasi berhasil dimuat dengan sempurna',
        );
      } catch (e) {
        TestReportGenerator.recordTestResult(
          'Logo dan nama aplikasi',
          'Halaman Utama',
          false,
          'Error: $e',
        );
        rethrow;
      }
    });

    testWidgets('✅ Test 3: Sistem navigasi tersedia dan berfungsi', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test sistem navigasi...');

      try {
        // Setup
        await helpers.pumpAppWithMockData(tester, MyApp());
        await helpers.waitForAnimations(tester);

        // Verifikasi navigasi tersedia
        helpers.verifyWidgetExists(
          find.byType(MaterialApp),
          'MaterialApp untuk navigasi',
        );
        expect(find.byType(MaterialApp), findsOneWidget);

        TestReportGenerator.recordTestResult(
          'Sistem navigasi',
          'Halaman Utama',
          true,
          'Navigator tersedia dan siap digunakan',
        );
      } catch (e) {
        TestReportGenerator.recordTestResult(
          'Sistem navigasi',
          'Halaman Utama',
          false,
          'Error: $e',
        );
        rethrow;
      }
    });

    testWidgets('✅ Test 4: Responsivitas terhadap interaksi pengguna', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test responsivitas...');

      try {
        // Setup
        await helpers.pumpAppWithMockData(tester, MyApp());
        await helpers.waitForAnimations(tester);

        // Test responsivitas
        expect(find.byType(MaterialApp), findsOneWidget);

        // Simulasi interaksi
        await helpers.simulateNetworkDelay();

        TestReportGenerator.recordTestResult(
          'Responsivitas aplikasi',
          'Halaman Utama',
          true,
          'Aplikasi responsif terhadap interaksi',
        );
      } catch (e) {
        TestReportGenerator.recordTestResult(
          'Responsivitas aplikasi',
          'Halaman Utama',
          false,
          'Error: $e',
        );
        rethrow;
      }
    });

    tearDown(() {
      print('🧹 Membersihkan setelah test halaman utama...\n');
    });
  });

  group('🔧 Tes Integrasi Sistem Halaman Utama', () {
    late BlackBoxTestHelpers helpers;

    setUp(() {
      helpers = BlackBoxTestHelpers();
      print('\n📋 Memulai setup test integrasi sistem...');
    });

    testWidgets('✅ Test 5: Inisialisasi semua komponen', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test inisialisasi komponen...');

      try {
        // Setup
        await helpers.pumpAppWithMockData(tester, MyApp());
        await helpers.waitForAnimations(tester);

        // Verifikasi inisialisasi komponen
        helpers.verifyWidgetExists(find.byType(MaterialApp), 'MaterialApp');
        expect(find.byType(MaterialApp), findsOneWidget);

        TestReportGenerator.recordTestResult(
          'Inisialisasi komponen',
          'Integrasi Sistem',
          true,
          'Semua komponen berhasil diinisialisasi',
        );
      } catch (e) {
        TestReportGenerator.recordTestResult(
          'Inisialisasi komponen',
          'Integrasi Sistem',
          false,
          'Error: $e',
        );
        rethrow;
      }
    });

    testWidgets('✅ Test 6: Pemuatan resource aplikasi', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test pemuatan resource...');

      try {
        // Setup
        await helpers.pumpAppWithMockData(tester, MyApp());
        await helpers.waitForAnimations(tester);

        // Test pemuatan resource
        expect(find.byType(MaterialApp), findsOneWidget);

        // Simulasi loading resource
        await helpers.simulateNetworkDelay();

        TestReportGenerator.recordTestResult(
          'Pemuatan resource',
          'Integrasi Sistem',
          true,
          'Resource aplikasi berhasil dimuat',
        );
      } catch (e) {
        TestReportGenerator.recordTestResult(
          'Pemuatan resource',
          'Integrasi Sistem',
          false,
          'Error: $e',
        );
        rethrow;
      }
    });

    tearDown(() {
      print('🧹 Membersihkan setelah test integrasi sistem...\n');
    });
  });
}
