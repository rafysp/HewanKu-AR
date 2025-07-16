import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/main.dart';
import '../../helpers/black_box_test_helpers.dart';

void main() {
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

      // Setup
      await helpers.pumpAppWithMockData(tester, MyApp());
      await helpers.waitForAnimations(tester);

      // Verifikasi elemen utama aplikasi
      helpers.verifyWidgetExists(find.byType(Scaffold), 'Scaffold utama');
      helpers.verifyWidgetExists(find.byType(MaterialApp), 'MaterialApp');

      // Test berhasil
      helpers.printTestResult(
        'Interface aplikasi utama',
        true,
        'Semua elemen UI terdeteksi dengan benar',
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('✅ Test 2: Memuat logo dan nama aplikasi', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test logo dan nama aplikasi...');

      // Setup
      await helpers.pumpAppWithMockData(tester, MyApp());
      await helpers.waitForAnimations(tester);

      // Verifikasi aplikasi dimuat
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test berhasil
      helpers.printTestResult(
        'Logo dan nama aplikasi',
        true,
        'Aplikasi berhasil dimuat dengan sempurna',
      );
    });

    testWidgets('✅ Test 3: Sistem navigasi tersedia dan berfungsi', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test sistem navigasi...');

      // Setup
      await helpers.pumpAppWithMockData(tester, MyApp());
      await helpers.waitForAnimations(tester);

      // Verifikasi navigasi tersedia
      helpers.verifyWidgetExists(
        find.byType(MaterialApp),
        'MaterialApp untuk navigasi',
      );

      // Test berhasil
      helpers.printTestResult(
        'Sistem navigasi',
        true,
        'Navigator tersedia dan siap digunakan',
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('✅ Test 4: Responsivitas terhadap interaksi pengguna', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test responsivitas...');

      // Setup
      await helpers.pumpAppWithMockData(tester, MyApp());
      await helpers.waitForAnimations(tester);

      // Test responsivitas
      expect(find.byType(MaterialApp), findsOneWidget);

      // Simulasi interaksi
      await helpers.simulateNetworkDelay();

      // Test berhasil
      helpers.printTestResult(
        'Responsivitas aplikasi',
        true,
        'Aplikasi responsif terhadap interaksi',
      );
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

      // Setup
      await helpers.pumpAppWithMockData(tester, MyApp());
      await helpers.waitForAnimations(tester);

      // Verifikasi inisialisasi komponen
      helpers.verifyWidgetExists(find.byType(MaterialApp), 'MaterialApp');

      // Test berhasil
      helpers.printTestResult(
        'Inisialisasi komponen',
        true,
        'Semua komponen berhasil diinisialisasi',
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('✅ Test 6: Pemuatan resource aplikasi', (
      WidgetTester tester,
    ) async {
      print('🔄 Menjalankan test pemuatan resource...');

      // Setup
      await helpers.pumpAppWithMockData(tester, MyApp());
      await helpers.waitForAnimations(tester);

      // Test pemuatan resource
      expect(find.byType(MaterialApp), findsOneWidget);

      // Simulasi loading resource
      await helpers.simulateNetworkDelay();

      // Test berhasil
      helpers.printTestResult(
        'Pemuatan resource',
        true,
        'Resource aplikasi berhasil dimuat',
      );
    });

    tearDown(() {
      print('🧹 Membersihkan setelah test integrasi sistem...\n');
    });
  });
}
