import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

/// Class untuk menghasilkan laporan test yang siap untuk skripsi
class TestReportGenerator {
  static final List<TestResult> _testResults = [];
  static DateTime? _startTime;
  static DateTime? _endTime;

  /// Mulai session testing
  static void startTestSession() {
    _startTime = DateTime.now();
    _testResults.clear();
    print('\n' + '=' * 60);
    print('    MEMULAI SESI BLACK BOX TESTING');
    print('    Aplikasi HewanKu AR - Flutter Framework');
    print('=' * 60);
    print('Waktu Mulai: ${_formatDateTime(_startTime!)}');
    print('');
  }

  /// Akhiri session testing
  static void endTestSession() {
    _endTime = DateTime.now();
    print('\n' + '=' * 60);
    print('    RINGKASAN HASIL TESTING');
    print('=' * 60);
    _generateSummaryReport();
    print('=' * 60);
    print('Waktu Selesai: ${_formatDateTime(_endTime!)}');
    print('Durasi Total: ${_calculateDuration()}');
    print('');
  }

  /// Catat hasil test
  static void recordTestResult(
    String testName,
    String groupName,
    bool passed,
    String details,
  ) {
    final result = TestResult(
      testName: testName,
      groupName: groupName,
      passed: passed,
      details: details,
      timestamp: DateTime.now(),
    );
    _testResults.add(result);

    String status = passed ? '✅ BERHASIL' : '❌ GAGAL';
    print('$status: $testName');
    if (details.isNotEmpty) {
      print('   📝 Detail: $details');
    }
  }

  /// Generate summary report
  static void _generateSummaryReport() {
    int totalTests = _testResults.length;
    int passedTests = _testResults.where((r) => r.passed).length;
    int failedTests = totalTests - passedTests;
    double successRate = totalTests > 0 ? (passedTests / totalTests) * 100 : 0;

    print('📊 STATISTIK TESTING:');
    print('   Total Test Cases: $totalTests');
    print('   Test Berhasil: $passedTests');
    print('   Test Gagal: $failedTests');
    print('   Tingkat Keberhasilan: ${successRate.toStringAsFixed(1)}%');
    print('');

    // Group by test groups
    Map<String, List<TestResult>> groupedResults = {};
    for (var result in _testResults) {
      if (!groupedResults.containsKey(result.groupName)) {
        groupedResults[result.groupName] = [];
      }
      groupedResults[result.groupName]!.add(result);
    }

    print('📋 HASIL PER MODUL:');
    groupedResults.forEach((groupName, results) {
      int groupPassed = results.where((r) => r.passed).length;
      int groupTotal = results.length;
      print('   🔸 $groupName: $groupPassed/$groupTotal test berhasil');
    });
    print('');

    if (failedTests > 0) {
      print('❌ TEST YANG GAGAL:');
      for (var result in _testResults.where((r) => !r.passed)) {
        print('   • ${result.testName} (${result.groupName})');
        print('     Alasan: ${result.details}');
      }
      print('');
    }

    print('✅ KESIMPULAN:');
    if (failedTests == 0) {
      print('   Semua test berhasil dijalankan dengan sukses!');
      print('   Aplikasi HewanKu AR siap untuk production.');
    } else {
      print('   $failedTests test memerlukan perbaikan.');
      print('   Silakan periksa detail error di atas.');
    }
  }

  /// Format datetime untuk display
  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// Hitung durasi testing
  static String _calculateDuration() {
    if (_startTime == null || _endTime == null) return 'Tidak diketahui';

    Duration duration = _endTime!.difference(_startTime!);
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit ${duration.inSeconds % 60} detik';
    } else {
      return '${duration.inSeconds} detik';
    }
  }

  /// Generate laporan untuk skripsi
  static String generateThesisReport() {
    StringBuffer report = StringBuffer();

    report.writeln('LAPORAN HASIL BLACK BOX TESTING');
    report.writeln('Aplikasi HewanKu AR - Flutter Framework');
    report.writeln('=' * 50);
    report.writeln('');
    report.writeln(
      'Tanggal Testing: ${_formatDateTime(_startTime ?? DateTime.now())}',
    );
    report.writeln('Platform: Windows');
    report.writeln('Framework: Flutter');
    report.writeln('Metode Testing: Black Box Testing');
    report.writeln('');

    // Statistik
    int totalTests = _testResults.length;
    int passedTests = _testResults.where((r) => r.passed).length;
    double successRate = totalTests > 0 ? (passedTests / totalTests) * 100 : 0;

    report.writeln('RINGKASAN HASIL:');
    report.writeln('- Total Test Cases: $totalTests');
    report.writeln('- Test Berhasil: $passedTests');
    report.writeln('- Test Gagal: ${totalTests - passedTests}');
    report.writeln(
      '- Tingkat Keberhasilan: ${successRate.toStringAsFixed(1)}%',
    );
    report.writeln('');

    // Detail per test
    report.writeln('DETAIL HASIL TESTING:');
    Map<String, List<TestResult>> groupedResults = {};
    for (var result in _testResults) {
      if (!groupedResults.containsKey(result.groupName)) {
        groupedResults[result.groupName] = [];
      }
      groupedResults[result.groupName]!.add(result);
    }

    groupedResults.forEach((groupName, results) {
      report.writeln('');
      report.writeln('Modul: $groupName');
      report.writeln('-' * 30);
      for (var result in results) {
        String status = result.passed ? 'BERHASIL' : 'GAGAL';
        report.writeln('• ${result.testName}: $status');
        if (result.details.isNotEmpty) {
          report.writeln('  Detail: ${result.details}');
        }
      }
    });

    return report.toString();
  }

  /// Get all test results
  static List<TestResult> getTestResults() => List.unmodifiable(_testResults);
}

/// Class untuk menyimpan hasil test
class TestResult {
  final String testName;
  final String groupName;
  final bool passed;
  final String details;
  final DateTime timestamp;

  TestResult({
    required this.testName,
    required this.groupName,
    required this.passed,
    required this.details,
    required this.timestamp,
  });
}
