# Poker App Testing Guide

This directory contains comprehensive tests for the Poker Flutter app, including unit tests, widget tests, and integration tests.

## 📁 Test Structure

```
test/
├── unit/                    # Unit tests for business logic
│   ├── models/             # Model tests
│   └── services/           # Service tests
├── widget/                 # Widget tests for UI components
├── helpers/                # Test utilities and helpers
├── test_config.dart        # Test configuration
├── run_tests.dart          # Test runner script
└── README.md              # This file

integration_test/
└── app_test.dart          # End-to-end integration tests
```

## 🧪 Test Types

### 1. Unit Tests (`test/unit/`)
- **Purpose**: Test individual functions, classes, and business logic
- **Location**: `test/unit/`
- **Examples**: 
  - Model serialization/deserialization
  - Service validation logic
  - Repository methods
  - Utility functions

### 2. Widget Tests (`test/widget/`)
- **Purpose**: Test UI components and user interactions
- **Location**: `test/widget/`
- **Examples**:
  - Widget rendering
  - User input handling
  - Navigation
  - State management

### 3. Integration Tests (`integration_test/`)
- **Purpose**: Test complete user flows and app behavior
- **Location**: `integration_test/`
- **Examples**:
  - Complete user journeys
  - Cross-screen navigation
  - Real device testing

## 🚀 Running Tests

### Prerequisites
```bash
# Install dependencies
flutter pub get

# Generate mock files (if using mockito)
flutter packages pub run build_runner build
```

### Running All Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Running Specific Test Types
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests only
flutter test integration_test/
```

### Using the Test Runner Script
```bash
# Run all tests
dart test/run_tests.dart all

# Run unit tests only
dart test/run_tests.dart unit

# Run widget tests only
dart test/run_tests.dart widget

# Run integration tests only
dart test/run_tests.dart integration

# Run with coverage
dart test/run_tests.dart coverage
```

## 📊 Test Coverage

To generate and view test coverage:

```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🛠️ Test Utilities

### TestHelpers (`test/helpers/test_helpers.dart`)
Provides common utilities for testing:

```dart
import 'package:poker/test/helpers/test_helpers.dart';

// Create mock data
final request = TestHelpers.createMockCreateRoomRequest();
final response = TestHelpers.createMockCreateRoomResponse();

// Validate JSON serialization
TestHelpers.validateJsonSerialization(
  object,
  fromJson,
  toJson,
);

// Test styling
TestHelpers.expectTextWithStyling(
  tester,
  'Text',
  fontFamily: 'Gotham',
  color: Colors.black,
);
```

### TestConfig (`test/test_config.dart`)
Manages test configuration:

```dart
import 'package:poker/test/test_config.dart';

// Setup test environment
TestConfig.setupTestConfig();

// Setup landscape orientation for poker app
TestConfig.setupLandscapeOrientation();
```

## 📝 Writing Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:poker/models/room_models.dart';

void main() {
  group('CreateRoomRequest', () {
    test('should create with valid data', () {
      final request = CreateRoomRequest(
        creatorName: 'John Doe',
        maxPlayers: 6,
      );

      expect(request.creatorName, 'John Doe');
      expect(request.maxPlayers, 6);
    });

    test('should serialize and deserialize', () {
      final request = CreateRoomRequest(
        creatorName: 'Jane Smith',
        maxPlayers: 8,
      );

      final json = request.toJson();
      final fromJson = CreateRoomRequest.fromJson(json);

      expect(fromJson.creatorName, request.creatorName);
      expect(fromJson.maxPlayers, request.maxPlayers);
    });
  });
}
```

### Widget Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:poker/screens/home_page.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should display all UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should navigate to create room page', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      await tester.tap(find.text('Criar um\nNovo Jogo!'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateRoomPage), findsOneWidget);
    });
  });
}
```

### Integration Test Example
```dart
import 'package:integration_test/integration_test.dart';
import 'package:poker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Poker App Integration Tests', () {
    testWidgets('should launch app and display home page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
    });
  });
}
```

## 🔧 Mocking with Mockito

For testing services and repositories:

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([RoomRepository])
void main() {
  late MockRoomRepository mockRepository;
  late RoomService roomService;

  setUp(() {
    mockRepository = MockRoomRepository();
    roomService = RoomService(repository: mockRepository);
  });

  test('should create room successfully', () async {
    when(mockRepository.createRoom(any))
        .thenAnswer((_) async => expectedResponse);

    final result = await roomService.createRoom(
      creatorName: 'John Doe',
      maxPlayers: 6,
    );

    expect(result, expectedResponse);
    verify(mockRepository.createRoom(any)).called(1);
  });
}
```

## 📋 Best Practices

### 1. Test Organization
- Group related tests using `group()`
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### 2. Test Data
- Use `TestHelpers` for common test data
- Create meaningful test scenarios
- Test edge cases and error conditions

### 3. Widget Testing
- Test user interactions
- Verify UI state changes
- Test navigation flows
- Check styling and layout

### 4. Integration Testing
- Test complete user journeys
- Verify cross-screen functionality
- Test real device behavior

### 5. Performance
- Keep tests fast and focused
- Use `setUp()` and `tearDown()` for common setup
- Avoid unnecessary async operations

## 🐛 Debugging Tests

### Common Issues
1. **Mock files not generated**: Run `flutter packages pub run build_runner build`
2. **Asset loading errors**: Ensure assets are properly declared in `pubspec.yaml`
3. **Navigation issues**: Use `tester.pumpAndSettle()` for async navigation

### Debug Commands
```bash
# Run tests with verbose output
flutter test --verbose

# Run specific test file
flutter test test/unit/models/room_models_test.dart

# Run tests with coverage and verbose output
flutter test --coverage --verbose
```

## 📈 Continuous Integration

For CI/CD pipelines, add these commands:

```yaml
# Example GitHub Actions step
- name: Run tests
  run: |
    flutter pub get
    flutter test --coverage
    genhtml coverage/lcov.info -o coverage/html
```

## 🤝 Contributing

When adding new features:
1. Write unit tests for business logic
2. Write widget tests for UI components
3. Write integration tests for user flows
4. Ensure all tests pass before submitting PR
5. Maintain or improve test coverage

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing Guide](https://docs.flutter.dev/cookbook/testing/integration/introduction)
- [Mockito Documentation](https://pub.dev/packages/mockito) 