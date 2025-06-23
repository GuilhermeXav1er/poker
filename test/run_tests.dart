import 'dart:io';
import 'package:test/test.dart';

/// Test runner for the poker app
/// This script can be used to run different types of tests
void main(List<String> args) async {
  print('🎯 Poker App Test Runner');
  print('========================');
  
  if (args.isEmpty) {
    printUsage();
    return;
  }
  
  final command = args[0];
  
  switch (command) {
    case 'unit':
      await runUnitTests();
      break;
    case 'widget':
      await runWidgetTests();
      break;
    case 'integration':
      await runIntegrationTests();
      break;
    case 'all':
      await runAllTests();
      break;
    case 'coverage':
      await runTestsWithCoverage();
      break;
    default:
      print('❌ Unknown command: $command');
      printUsage();
  }
}

void printUsage() {
  print('''
Usage: dart test/run_tests.dart <command>

Commands:
  unit        - Run unit tests only
  widget      - Run widget tests only
  integration - Run integration tests only
  all         - Run all tests
  coverage    - Run all tests with coverage report

Examples:
  dart test/run_tests.dart unit
  dart test/run_tests.dart all
  dart test/run_tests.dart coverage
''');
}

Future<void> runUnitTests() async {
  print('🧪 Running Unit Tests...');
  
  try {
    final result = await Process.run('flutter', [
      'test',
      'test/unit/',
      '--reporter=expanded',
    ]);
    
    if (result.exitCode == 0) {
      print('✅ Unit tests passed!');
    } else {
      print('❌ Unit tests failed!');
      print(result.stderr);
    }
  } catch (e) {
    print('❌ Error running unit tests: $e');
  }
}

Future<void> runWidgetTests() async {
  print('🎨 Running Widget Tests...');
  
  try {
    final result = await Process.run('flutter', [
      'test',
      'test/widget/',
      '--reporter=expanded',
    ]);
    
    if (result.exitCode == 0) {
      print('✅ Widget tests passed!');
    } else {
      print('❌ Widget tests failed!');
      print(result.stderr);
    }
  } catch (e) {
    print('❌ Error running widget tests: $e');
  }
}

Future<void> runIntegrationTests() async {
  print('🔗 Running Integration Tests...');
  
  try {
    final result = await Process.run('flutter', [
      'test',
      'integration_test/',
      '--reporter=expanded',
    ]);
    
    if (result.exitCode == 0) {
      print('✅ Integration tests passed!');
    } else {
      print('❌ Integration tests failed!');
      print(result.stderr);
    }
  } catch (e) {
    print('❌ Error running integration tests: $e');
  }
}

Future<void> runAllTests() async {
  print('🚀 Running All Tests...');
  
  try {
    final result = await Process.run('flutter', [
      'test',
      '--reporter=expanded',
    ]);
    
    if (result.exitCode == 0) {
      print('✅ All tests passed!');
    } else {
      print('❌ Some tests failed!');
      print(result.stderr);
    }
  } catch (e) {
    print('❌ Error running tests: $e');
  }
}

Future<void> runTestsWithCoverage() async {
  print('📊 Running Tests with Coverage...');
  
  try {
    // Run tests with coverage
    final testResult = await Process.run('flutter', [
      'test',
      '--coverage',
      '--reporter=expanded',
    ]);
    
    if (testResult.exitCode == 0) {
      print('✅ Tests passed!');
      
      // Generate coverage report
      final coverageResult = await Process.run('genhtml', [
        'coverage/lcov.info',
        '-o',
        'coverage/html',
      ]);
      
      if (coverageResult.exitCode == 0) {
        print('📈 Coverage report generated at coverage/html/index.html');
      } else {
        print('⚠️  Could not generate coverage report: ${coverageResult.stderr}');
      }
    } else {
      print('❌ Tests failed!');
      print(testResult.stderr);
    }
  } catch (e) {
    print('❌ Error running tests with coverage: $e');
  }
}

/// Test statistics helper
class TestStats {
  int totalTests = 0;
  int passedTests = 0;
  int failedTests = 0;
  int skippedTests = 0;
  
  void addTestResult(String result) {
    totalTests++;
    switch (result.toLowerCase()) {
      case 'pass':
      case 'passed':
        passedTests++;
        break;
      case 'fail':
      case 'failed':
        failedTests++;
        break;
      case 'skip':
      case 'skipped':
        skippedTests++;
        break;
    }
  }
  
  void printStats() {
    print('\n📊 Test Statistics:');
    print('Total: $totalTests');
    print('Passed: $passedTests');
    print('Failed: $failedTests');
    print('Skipped: $skippedTests');
    
    if (totalTests > 0) {
      final passRate = (passedTests / totalTests * 100).toStringAsFixed(1);
      print('Pass Rate: $passRate%');
    }
  }
} 