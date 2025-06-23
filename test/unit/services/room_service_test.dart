import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:poker/models/room_models.dart';
import 'package:poker/repositories/room_repository.dart';
import 'package:poker/services/room_service.dart';

import 'room_service_test.mocks.dart';

@GenerateMocks([RoomRepository])
void main() {
  late RoomService roomService;
  late MockRoomRepository mockRepository;

  setUp(() {
    mockRepository = MockRoomRepository();
    roomService = RoomService(repository: mockRepository);
  });

  tearDown(() {
    roomService.dispose();
  });

  group('RoomService - createRoom', () {
    test('should create room successfully with valid parameters', () async {
      // Arrange
      const creatorName = 'John Doe';
      const maxPlayers = 6;
      final expectedResponse = CreateRoomResponse(
        roomId: 'room123',
        playerId: 'player456',
      );

      when(mockRepository.createRoom(any))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await roomService.createRoom(
        creatorName: creatorName,
        maxPlayers: maxPlayers,
      );

      // Assert
      expect(result, expectedResponse);
      verify(mockRepository.createRoom(any)).called(1);
    });

    test('should throw exception when creator name is empty', () async {
      // Act & Assert
      expect(
        () => roomService.createRoom(
          creatorName: '',
          maxPlayers: 6,
        ),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.createRoom(any));
    });

    test('should throw exception when creator name is only whitespace', () async {
      // Act & Assert
      expect(
        () => roomService.createRoom(
          creatorName: '   ',
          maxPlayers: 6,
        ),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.createRoom(any));
    });

    test('should throw exception when max players is less than 2', () async {
      // Act & Assert
      expect(
        () => roomService.createRoom(
          creatorName: 'John Doe',
          maxPlayers: 1,
        ),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.createRoom(any));
    });

    test('should throw exception when max players is greater than 10', () async {
      // Act & Assert
      expect(
        () => roomService.createRoom(
          creatorName: 'John Doe',
          maxPlayers: 11,
        ),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.createRoom(any));
    });

    test('should trim creator name before creating room', () async {
      // Arrange
      const creatorName = '  John Doe  ';
      const maxPlayers = 6;
      final expectedResponse = CreateRoomResponse(
        roomId: 'room123',
        playerId: 'player456',
      );

      when(mockRepository.createRoom(any))
          .thenAnswer((_) async => expectedResponse);

      // Act
      await roomService.createRoom(
        creatorName: creatorName,
        maxPlayers: maxPlayers,
      );

      // Assert
      verify(mockRepository.createRoom(argThat(
        predicate((CreateRoomRequest request) => 
            request.creatorName == 'John Doe'),
      ))).called(1);
    });
  });

  group('RoomService - joinRoom', () {
    test('should join room successfully with valid parameters', () async {
      // Arrange
      const roomId = 'room123';
      const playerName = 'Jane Smith';
      final expectedResponse = JoinRoomResponse(
        success: true,
        message: 'Successfully joined room',
        playerId: 'player789',
      );

      when(mockRepository.joinRoom(any, any))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await roomService.joinRoom(
        roomId: roomId,
        playerName: playerName,
      );

      // Assert
      expect(result, expectedResponse);
      verify(mockRepository.joinRoom(roomId, any)).called(1);
    });

    test('should throw exception when room ID is empty', () async {
      // Act & Assert
      expect(
        () => roomService.joinRoom(
          roomId: '',
          playerName: 'Jane Smith',
        ),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.joinRoom(any, any));
    });

    test('should throw exception when player name is empty', () async {
      // Act & Assert
      expect(
        () => roomService.joinRoom(
          roomId: 'room123',
          playerName: '',
        ),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.joinRoom(any, any));
    });

    test('should trim player name before joining room', () async {
      // Arrange
      const roomId = 'room123';
      const playerName = '  Jane Smith  ';
      final expectedResponse = JoinRoomResponse(
        success: true,
        message: 'Successfully joined room',
        playerId: 'player789',
      );

      when(mockRepository.joinRoom(any, any))
          .thenAnswer((_) async => expectedResponse);

      // Act
      await roomService.joinRoom(
        roomId: roomId,
        playerName: playerName,
      );

      // Assert
      verify(mockRepository.joinRoom(roomId, argThat(
        predicate((JoinRoomRequest request) => 
            request.playerName == 'Jane Smith'),
      ))).called(1);
    });
  });

  group('RoomService - startGame', () {
    test('should start game successfully with valid room ID', () async {
      // Arrange
      const roomId = 'room123';
      when(mockRepository.startGame(any)).thenAnswer((_) async {});

      // Act
      await roomService.startGame(roomId);

      // Assert
      verify(mockRepository.startGame(roomId)).called(1);
    });

    test('should throw exception when room ID is empty', () async {
      // Act & Assert
      expect(
        () => roomService.startGame(''),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.startGame(any));
    });
  });

  group('RoomService - getWebSocketUrl', () {
    test('should return WebSocket URL for valid room ID', () {
      // Arrange
      const roomId = 'room123';
      const expectedUrl = 'ws://localhost:8080/room123';
      when(mockRepository.getWebSocketUrl(any)).thenReturn(expectedUrl);

      // Act
      final result = roomService.getWebSocketUrl(roomId);

      // Assert
      expect(result, expectedUrl);
      verify(mockRepository.getWebSocketUrl(roomId)).called(1);
    });

    test('should throw exception when room ID is empty', () {
      // Act & Assert
      expect(
        () => roomService.getWebSocketUrl(''),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRepository.getWebSocketUrl(any));
    });
  });

  group('RoomService - validation methods', () {
    group('isValidRoomId', () {
      test('should return true for valid room ID', () {
        expect(roomService.isValidRoomId('room123'), true);
        expect(roomService.isValidRoomId('123456'), true);
        expect(roomService.isValidRoomId('abcdef'), true);
      });

      test('should return false for invalid room ID', () {
        expect(roomService.isValidRoomId(''), false);
        expect(roomService.isValidRoomId('   '), false);
        expect(roomService.isValidRoomId('12345'), false); // less than 6 characters
        expect(roomService.isValidRoomId('123'), false); // less than 6 characters
      });
    });

    group('isValidPlayerName', () {
      test('should return true for valid player name', () {
        expect(roomService.isValidPlayerName('John'), true);
        expect(roomService.isValidPlayerName('Jane Smith'), true);
        expect(roomService.isValidPlayerName('A' * 20), true); // exactly 20 characters
      });

      test('should return false for invalid player name', () {
        expect(roomService.isValidPlayerName(''), false);
        expect(roomService.isValidPlayerName('   '), false);
        expect(roomService.isValidPlayerName('A'), false); // less than 2 characters
        expect(roomService.isValidPlayerName('A' * 21), false); // more than 20 characters
      });
    });
  });

  group('RoomService - dispose', () {
    test('should dispose repository when service is disposed', () {
      // Act
      roomService.dispose();

      // Assert
      verify(mockRepository.dispose()).called(1);
    });
  });
} 