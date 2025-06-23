import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';

/// Test configuration class for setting up common test settings
class TestConfig {
  /// Default timeout for tests
  static const Duration defaultTimeout = Duration(seconds: 30);
  
  /// Default pump duration for widget tests
  static const Duration defaultPumpDuration = Duration(milliseconds: 100);
  
  /// Default surface size for widget tests
  static final Size defaultSurfaceSize = const Size(800, 600);
  
  /// Landscape surface size for poker app
  static final Size landscapeSurfaceSize = const Size(1200, 800);
  
  /// Portrait surface size for testing
  static final Size portraitSurfaceSize = const Size(600, 800);
  
  /// Test device pixel ratio
  static const double testDevicePixelRatio = 1.0;
  
  /// Test platform
  static const String testPlatform = 'test';
  
  /// Setup common test configuration
  static void setupTestConfig() {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Set default surface size
    TestWidgetsFlutterBinding.instance.window.physicalSizeTestValue = 
        defaultSurfaceSize * testDevicePixelRatio;
    TestWidgetsFlutterBinding.instance.window.devicePixelRatioTestValue = 
        testDevicePixelRatio;
  }
  
  /// Setup landscape orientation for poker app
  static void setupLandscapeOrientation() {
    TestWidgetsFlutterBinding.instance.window.physicalSizeTestValue = 
        landscapeSurfaceSize * testDevicePixelRatio;
  }
  
  /// Setup portrait orientation for testing
  static void setupPortraitOrientation() {
    TestWidgetsFlutterBinding.instance.window.physicalSizeTestValue = 
        portraitSurfaceSize * testDevicePixelRatio;
  }
  
  /// Reset test configuration to defaults
  static void resetTestConfig() {
    TestWidgetsFlutterBinding.instance.window.clearPhysicalSizeTestValue();
    TestWidgetsFlutterBinding.instance.window.clearDevicePixelRatioTestValue();
  }
  
  /// Common test group setup
  static void setupTestGroup() {
    setUpAll(() {
      setupTestConfig();
    });
    
    tearDownAll(() {
      resetTestConfig();
    });
  }
  
  /// Common test setup for widget tests
  static void setupWidgetTest() {
    setupTestConfig();
  }
  
  /// Common test teardown for widget tests
  static void teardownWidgetTest() {
    resetTestConfig();
  }
} 