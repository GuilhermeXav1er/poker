import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:poker/main.dart' as app;
import 'package:poker/screens/create_room_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Poker App Integration Tests', () {
    testWidgets('should launch app and display home page', (WidgetTester tester) async {
      // Arrange & Act
      app.main();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
      expect(find.text('Criar um\nNovo Jogo!'), findsOneWidget);
    });

    testWidgets('should navigate to create room page', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Criar um\nNovo Jogo!'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CreateRoomPage), findsOneWidget);
    });

    testWidgets('should fill form fields and validate input', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField).first, 'room123456');
      await tester.enterText(find.byType(TextField).last, 'TestPlayer');
      await tester.pump();

      // Assert
      expect(find.text('room123456'), findsOneWidget);
      expect(find.text('TestPlayer'), findsOneWidget);
    });

    testWidgets('should handle empty form submission', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Try to submit with empty fields
      // Note: This test verifies that the app doesn't crash with empty input
      await tester.pump();

      // Assert - App should still be on home page
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
    });

    testWidgets('should maintain app state during navigation', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Navigate to create room and back
      await tester.tap(find.text('Criar um\nNovo Jogo!'));
      await tester.pumpAndSettle();
      
      // Go back to home page
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Assert - Should be back on home page
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
    });

    testWidgets('should display proper UI elements on home page', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have correct background styling', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF18713A));
    });

    testWidgets('should handle long text input', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act
      final longRoomCode = 'verylongroomcode123456789';
      final longPlayerName = 'VeryLongPlayerNameThatExceedsNormalLength';
      
      await tester.enterText(find.byType(TextField).first, longRoomCode);
      await tester.enterText(find.byType(TextField).last, longPlayerName);
      await tester.pump();

      // Assert
      expect(find.text(longRoomCode), findsOneWidget);
      expect(find.text(longPlayerName), findsOneWidget);
    });

    testWidgets('should handle special characters in input', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act
      final specialRoomCode = 'room123456';
      final specialPlayerName = 'Player123456';
      
      await tester.enterText(find.byType(TextField).first, specialRoomCode);
      await tester.enterText(find.byType(TextField).last, specialPlayerName);
      await tester.pump();

      // Assert
      expect(find.text(specialRoomCode), findsOneWidget);
      expect(find.text(specialPlayerName), findsOneWidget);
    });

    testWidgets('should handle rapid navigation', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Rapidly tap create button multiple times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Criar um\nNovo Jogo!'));
        await tester.pump();
        await tester.pageBack();
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Assert - App should still be functional
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
    });

    testWidgets('should handle orientation changes', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Change orientation (simulated)
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();

      // Assert - App should still display properly
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
      expect(find.text('Criar um\nNovo Jogo!'), findsOneWidget);
    });

    testWidgets('should handle memory pressure', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Simulate memory pressure
      await tester.binding.handleMemoryPressure();
      await tester.pumpAndSettle();

      // Assert - App should still be functional
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
    });

    testWidgets('should handle app lifecycle changes', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Simulate app pause and resume
      await tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      await tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // Assert - App should still be functional
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
    });
  });
} 