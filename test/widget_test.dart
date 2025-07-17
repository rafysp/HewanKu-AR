// HewanKu AR Widget Test
// Test untuk memastikan aplikasi HewanKu AR dapat berjalan dengan baik

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('HewanKu AR App loads successfully', (WidgetTester tester) async {
    // Build aplikasi HewanKu AR dan trigger frame
    await tester.pumpWidget(const MyApp());
    
    // Tunggu sampai semua widget selesai di-render
    await tester.pumpAndSettle();

    // Verifikasi bahwa aplikasi berhasil dimuat
    // Cek apakah ada AppBar atau title aplikasi
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verifikasi bahwa HomePage berhasil dimuat
    // Bisa jadi ada text "HewanKu" atau elemen UI lainnya
    final finder = find.byType(Scaffold);
    expect(finder, findsAtLeastNWidgets(1));
    
    print('✅ HewanKu AR App widget test passed successfully');
  });

  testWidgets('App initializes without crashing', (WidgetTester tester) async {
    // Test sederhana untuk memastikan app tidak crash saat startup
    await tester.pumpWidget(const MyApp());
    
    // Tunggu beberapa frame untuk memastikan tidak ada error
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    
    // Jika sampai sini tanpa exception, berarti test berhasil
    expect(true, isTrue);
    
    print('✅ App initialization test passed');
  });
}
