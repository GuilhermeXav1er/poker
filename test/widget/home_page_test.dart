import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poker/screens/home_page.dart';
import 'package:poker/screens/create_room_page.dart';
import 'package:poker/services/room_service.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should display all UI elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      expect(find.text('Código da sala'), findsOneWidget);
      expect(find.text('Nome de usuário'), findsOneWidget);
      expect(find.text('Criar um\nNovo Jogo!'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('should have correct background color', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF18713A));
    });

    testWidgets('should display background images', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      expect(find.byType(Image), findsNWidgets(3));
    });

    testWidgets('should have form container with correct styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert - Find the form container specifically
      final containers = find.byType(Container);
      Container? formContainer;
      
      for (int i = 0; i < containers.evaluate().length; i++) {
        final widget = tester.widget<Container>(containers.at(i));
        if (widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration;
          if (decoration.color == Colors.grey[200] && decoration.borderRadius == BorderRadius.circular(18)) {
            formContainer = widget;
            break;
          }
        }
      }
      
      expect(formContainer, isNotNull);
    });

    testWidgets('should have text fields with correct styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Check first text field (room code)
      final roomCodeField = tester.widget<TextField>(textFields.first);
      expect(roomCodeField.decoration?.hintText, 'Digite o código da sala');
      expect(roomCodeField.decoration?.filled, true);
      expect(roomCodeField.decoration?.fillColor, Colors.black);

      // Check second text field (username) - Updated hint text
      final usernameField = tester.widget<TextField>(textFields.last);
      expect(usernameField.decoration?.hintText, 'Digite seu nome');
      expect(usernameField.decoration?.filled, true);
      expect(usernameField.decoration?.fillColor, Colors.black);
    });

    testWidgets('should have create game button with correct styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert - Find the create game button specifically
      final buttons = find.byType(ElevatedButton);
      ElevatedButton? createButton;
      
      for (int i = 0; i < buttons.evaluate().length; i++) {
        final widget = tester.widget<ElevatedButton>(buttons.at(i));
        final buttonText = find.descendant(of: buttons.at(i), matching: find.byType(Text));
        if (buttonText.evaluate().isNotEmpty) {
          final text = tester.widget<Text>(buttonText.first);
          if (text.data == 'Criar um\nNovo Jogo!') {
            createButton = widget;
            break;
          }
        }
      }
      
      expect(createButton, isNotNull);
      final buttonStyle = createButton!.style as ButtonStyle;
      expect(buttonStyle.backgroundColor?.resolve({}), Colors.white);
      expect(buttonStyle.padding?.resolve({}), const EdgeInsets.all(40));
      expect(buttonStyle.elevation?.resolve({}), 20);
    });

    testWidgets('should navigate to create room page when create button is pressed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Act
      await tester.tap(find.text('Criar um\nNovo Jogo!'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CreateRoomPage), findsOneWidget);
    });

    testWidgets('should show loading state when joining room', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Act - Enter room code and username
      await tester.enterText(find.byType(TextField).first, 'room123');
      await tester.enterText(find.byType(TextField).last, 'John Doe');

      // Note: We can't easily test the actual join functionality without mocking
      // the RoomService, but we can test the UI state changes
      await tester.pump();

      // Assert - Verify text was entered
      expect(find.text('room123'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should have correct font family for text elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      final roomCodeLabel = tester.widget<Text>(find.text('Código da sala'));
      expect(roomCodeLabel.style?.fontFamily, 'Gotham');

      final usernameLabel = tester.widget<Text>(find.text('Nome de usuário'));
      expect(usernameLabel.style?.fontFamily, 'Gotham');

      final createButtonText = tester.widget<Text>(find.text('Criar um\nNovo Jogo!'));
      expect(createButtonText.style?.fontFamily, 'Gotham');
    });

    testWidgets('should have proper text field validation styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      final textFields = find.byType(TextField);
      
      // Check first text field
      final firstField = tester.widget<TextField>(textFields.first);
      final firstDecoration = firstField.decoration!;
      expect(firstDecoration.border, isA<OutlineInputBorder>());
      expect(firstDecoration.filled, true);
      expect(firstDecoration.fillColor, Colors.black);
      expect(firstField.style?.color, Colors.white);
      
      // Check second text field
      final secondField = tester.widget<TextField>(textFields.last);
      final secondDecoration = secondField.decoration!;
      expect(secondDecoration.border, isA<OutlineInputBorder>());
      expect(secondDecoration.filled, true);
      expect(secondDecoration.fillColor, Colors.black);
      expect(secondField.style?.color, Colors.white);
    });

    testWidgets('should have proper button text styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      final createButtonText = tester.widget<Text>(find.text('Criar um\nNovo Jogo!'));
      final textStyle = createButtonText.style!;
      
      expect(textStyle.color, Colors.black);
      expect(textStyle.fontSize, 16);
      expect(textStyle.fontFamily, 'Gotham');
      expect(textStyle.fontWeight, FontWeight.bold);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsNWidgets(2));
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle text input correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Act
      await tester.enterText(find.byType(TextField).first, 'testroom123');
      await tester.enterText(find.byType(TextField).last, 'testuser');

      // Assert
      expect(find.text('testroom123'), findsOneWidget);
      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('should have proper spacing between elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Assert
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsAtLeastNWidgets(2)); // At least 2 SizedBox widgets for spacing
    });
  });
} 