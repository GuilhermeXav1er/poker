import 'package:flutter_test/flutter_test.dart';
import 'package:poker/models/room_models.dart';

void main() {
  group('CreateRoomRequest', () {
    test('should create CreateRoomRequest with valid data', () {
      final request = CreateRoomRequest(
        creatorName: 'John Doe',
        maxPlayers: 6,
      );

      expect(request.creatorName, 'John Doe');
      expect(request.maxPlayers, 6);
    });

    test('should serialize and deserialize CreateRoomRequest', () {
      final request = CreateRoomRequest(
        creatorName: 'Jane Smith',
        maxPlayers: 8,
      );

      final json = request.toJson();
      final fromJson = CreateRoomRequest.fromJson(json);

      expect(fromJson.creatorName, request.creatorName);
      expect(fromJson.maxPlayers, request.maxPlayers);
    });

    test('should handle JSON with different field names', () {
      final json = {
        'creator_name': 'Alice',
        'max_players': 4,
      };

      final request = CreateRoomRequest.fromJson(json);

      expect(request.creatorName, 'Alice');
      expect(request.maxPlayers, 4);
    });
  });

  group('CreateRoomResponse', () {
    test('should create CreateRoomResponse with valid data', () {
      final response = CreateRoomResponse(
        roomId: 'room123',
        playerId: 'player456',
      );

      expect(response.roomId, 'room123');
      expect(response.playerId, 'player456');
    });

    test('should serialize and deserialize CreateRoomResponse', () {
      final response = CreateRoomResponse(
        roomId: 'room789',
        playerId: 'player101',
      );

      final json = response.toJson();
      final fromJson = CreateRoomResponse.fromJson(json);

      expect(fromJson.roomId, response.roomId);
      expect(fromJson.playerId, response.playerId);
    });

    test('should handle JSON with different field names', () {
      final json = {
        'room_id': 'room456',
        'player_id': 'player789',
      };

      final response = CreateRoomResponse.fromJson(json);

      expect(response.roomId, 'room456');
      expect(response.playerId, 'player789');
    });
  });

  group('JoinRoomRequest', () {
    test('should create JoinRoomRequest with valid data', () {
      final request = JoinRoomRequest(
        playerName: 'Bob Wilson',
      );

      expect(request.playerName, 'Bob Wilson');
    });

    test('should serialize and deserialize JoinRoomRequest', () {
      final request = JoinRoomRequest(
        playerName: 'Charlie Brown',
      );

      final json = request.toJson();
      final fromJson = JoinRoomRequest.fromJson(json);

      expect(fromJson.playerName, request.playerName);
    });

    test('should handle JSON with different field names', () {
      final json = {
        'player_name': 'David Lee',
      };

      final request = JoinRoomRequest.fromJson(json);

      expect(request.playerName, 'David Lee');
    });
  });

  group('JoinRoomResponse', () {
    test('should create JoinRoomResponse with success', () {
      final response = JoinRoomResponse(
        success: true,
        message: 'Successfully joined room',
        playerId: 'player123',
      );

      expect(response.success, true);
      expect(response.message, 'Successfully joined room');
      expect(response.playerId, 'player123');
    });

    test('should create JoinRoomResponse with failure', () {
      final response = JoinRoomResponse(
        success: false,
        message: 'Room not found',
        playerId: null,
      );

      expect(response.success, false);
      expect(response.message, 'Room not found');
      expect(response.playerId, null);
    });

    test('should serialize and deserialize JoinRoomResponse', () {
      final response = JoinRoomResponse(
        success: true,
        message: 'Joined successfully',
        playerId: 'player456',
      );

      final json = response.toJson();
      final fromJson = JoinRoomResponse.fromJson(json);

      expect(fromJson.success, response.success);
      expect(fromJson.message, response.message);
      expect(fromJson.playerId, response.playerId);
    });

    test('should handle JSON with null playerId', () {
      final json = {
        'success': false,
        'message': 'Room is full',
        'playerId': null,
      };

      final response = JoinRoomResponse.fromJson(json);

      expect(response.success, false);
      expect(response.message, 'Room is full');
      expect(response.playerId, null);
    });
  });
} 