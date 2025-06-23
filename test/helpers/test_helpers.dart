import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poker/models/room_models.dart';

/// Test helper class containing common test utilities and mock data
class TestHelpers {
  /// Mock data for testing
  static const String mockRoomId = 'room123456';
  static const String mockPlayerId = 'player789';
  static const String mockCreatorName = 'John Doe';
  static const String mockPlayerName = 'Jane Smith';
  static const int mockMaxPlayers = 6;

  /// Creates a mock CreateRoomRequest for testing
  static CreateRoomRequest createMockCreateRoomRequest({
    String? creatorName,
    int? maxPlayers,
  }) {
    return CreateRoomRequest(
      creatorName: creatorName ?? mockCreatorName,
      maxPlayers: maxPlayers ?? mockMaxPlayers,
    );
  }

  /// Creates a mock CreateRoomResponse for testing
  static CreateRoomResponse createMockCreateRoomResponse({
    String? roomId,
    String? playerId,
  }) {
    return CreateRoomResponse(
      roomId: roomId ?? mockRoomId,
      playerId: playerId ?? mockPlayerId,
    );
  }

  /// Creates a mock JoinRoomRequest for testing
  static JoinRoomRequest createMockJoinRoomRequest({
    String? playerName,
  }) {
    return JoinRoomRequest(
      playerName: playerName ?? mockPlayerName,
    );
  }

  /// Creates a mock JoinRoomResponse for testing
  static JoinRoomResponse createMockJoinRoomResponse({
    bool? success,
    String? message,
    String? playerId,
  }) {
    return JoinRoomResponse(
      success: success ?? true,
      message: message ?? 'Successfully joined room',
      playerId: playerId ?? mockPlayerId,
    );
  }

  /// Creates a mock failure JoinRoomResponse for testing
  static JoinRoomResponse createMockFailureJoinRoomResponse({
    String? message,
  }) {
    return JoinRoomResponse(
      success: false,
      message: message ?? 'Room not found',
      playerId: null,
    );
  }

  /// Test data for room IDs
  static const List<String> validRoomIds = [
    'room123',
    '123456',
    'abcdef',
    'room789',
    'test123',
  ];

  /// Test data for invalid room IDs
  static const List<String> invalidRoomIds = [
    '',
    '   ',
    '12345', // less than 6 characters
    '123',   // less than 6 characters
    'a',     // less than 6 characters
  ];

  /// Test data for valid player names
  static const List<String> validPlayerNames = [
    'John',
    'Jane Smith',
    'Alice Johnson',
    'Bob Wilson',
    'Charlie Brown',
  ];

  /// Test data for invalid player names
  static List<String> get invalidPlayerNames => [
    '',
    '   ',
    'A', // less than 2 characters
    'A' * 21, // more than 20 characters
    'A' * 25, // more than 20 characters
  ];

  /// Test data for valid max players values
  static const List<int> validMaxPlayers = [2, 3, 4, 5, 6, 7, 8, 9, 10];

  /// Test data for invalid max players values
  static const List<int> invalidMaxPlayers = [0, 1, 11, 12, 15, 20];

  /// Creates a test MaterialApp wrapper for widget tests
  static Widget createTestApp({required Widget child}) {
    return MaterialApp(
      home: child,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Gotham',
      ),
    );
  }

  /// Waits for a specific condition to be true
  static Future<void> waitForCondition(
    Future<bool> Function() condition, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final startTime = DateTime.now();
    while (DateTime.now().difference(startTime) < timeout) {
      if (await condition()) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    throw TimeoutException('Condition not met within timeout', timeout);
  }

  /// Validates that a JSON object can be serialized and deserialized
  static void validateJsonSerialization<T>(
    T object,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> Function(T) toJson,
  ) {
    final json = toJson(object);
    final deserialized = fromJson(json);
    expect(deserialized, object);
  }

  /// Creates a list of test cases for parameterized tests
  static List<Map<String, dynamic>> createTestCases({
    required String testName,
    required List<Map<String, dynamic>> cases,
  }) {
    return cases.map((testCase) {
      return {
        'testName': testName,
        ...testCase,
      };
    }).toList();
  }

  /// Asserts that an exception is thrown with the expected message
  static void expectExceptionWithMessage(
    Future<void> Function() function,
    String expectedMessage,
  ) {
    expect(
      () => function(),
      throwsA(
        predicate((e) => e.toString().contains(expectedMessage)),
      ),
    );
  }

  /// Asserts that a widget has the expected text with proper styling
  static void expectTextWithStyling(
    WidgetTester tester,
    String text, {
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    final textWidget = tester.widget<Text>(find.text(text));
    final style = textWidget.style;
    
    if (fontFamily != null) {
      expect(style?.fontFamily, fontFamily);
    }
    if (color != null) {
      expect(style?.color, color);
    }
    if (fontSize != null) {
      expect(style?.fontSize, fontSize);
    }
    if (fontWeight != null) {
      expect(style?.fontWeight, fontWeight);
    }
  }

  /// Asserts that a widget has the expected decoration properties
  static void expectDecorationProperties(
    WidgetTester tester,
    Finder finder, {
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Border? border,
  }) {
    final container = tester.widget<Container>(finder);
    final decoration = container.decoration as BoxDecoration;
    
    if (backgroundColor != null) {
      expect(decoration.color, backgroundColor);
    }
    if (borderRadius != null) {
      expect(decoration.borderRadius, borderRadius);
    }
    if (border != null) {
      expect(decoration.border, border);
    }
  }
}

/// Custom exception for test timeouts
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() => 'TimeoutException: $message (timeout: ${timeout.inSeconds}s)';
} 