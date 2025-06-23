import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/room_models.dart';
import '../repositories/room_repository.dart';

class RoomService {
  final RoomRepository _repository;

  RoomService({RoomRepository? repository}) 
      : _repository = repository ?? RoomRepository();

  WebSocketChannel? _channel;

  /// Creates a new poker room with the given parameters
  /// 
  /// [creatorName] - Name of the room creator
  /// [maxPlayers] - Maximum number of players allowed in the room
  /// Returns a [CreateRoomResponse] with room ID and player ID
  /// Throws [Exception] if room creation fails
  Future<CreateRoomResponse> createRoom({
    required String creatorName,
    required int maxPlayers,
  }) async {
    // Validate input parameters
    if (creatorName.trim().isEmpty) {
      throw Exception('Creator name cannot be empty');
    }
    
    if (maxPlayers < 2 || maxPlayers > 10) {
      throw Exception('Max players must be between 2 and 10');
    }

    final request = CreateRoomRequest(
      creatorName: creatorName.trim(),
      maxPlayers: maxPlayers,
    );

    print("teste");

    return await _repository.createRoom(request);
  }

  /// Joins an existing poker room
  /// 
  /// [roomId] - The ID of the room to join
  /// [playerName] - Name of the player joining
  /// Returns a [JoinRoomResponse] with success status and player ID
  /// Throws [Exception] if joining fails
  Future<JoinRoomResponse> joinRoom({
    required String roomId,
    required String playerName,
  }) async {
    // Validate input parameters
    if (roomId.trim().isEmpty) {
      throw Exception('Room ID cannot be empty');
    }
    
    if (playerName.trim().isEmpty) {
      throw Exception('Player name cannot be empty');
    }

    final request = JoinRoomRequest(
      playerName: playerName.trim(),
    );

    return await _repository.joinRoom(roomId, request);
  }

  /// Starts a game in the specified room
  /// 
  /// [roomId] - The ID of the room to start the game in
  /// Throws [Exception] if starting the game fails
  Future<void> startGame(String roomId) async {
    if (roomId.trim().isEmpty) {
      throw Exception('Room ID cannot be empty');
    }

    await _repository.startGame(roomId);
  }

  /// Gets the WebSocket URL for connecting to a room
  /// 
  /// [roomId] - The ID of the room
  /// Returns the WebSocket URL as a string
  String getWebSocketUrl(String roomId) {
    if (roomId.trim().isEmpty) {
      throw Exception('Room ID cannot be empty');
    }

    return _repository.getWebSocketUrl(roomId);
  }

  /// Validates a room ID format
  /// 
  /// [roomId] - The room ID to validate
  /// Returns true if the room ID is valid, false otherwise
  bool isValidRoomId(String roomId) {
    return roomId.trim().isNotEmpty && roomId.length >= 6;
  }

  /// Validates a player name
  /// 
  /// [playerName] - The player name to validate
  /// Returns true if the player name is valid, false otherwise
  bool isValidPlayerName(String playerName) {
    final trimmedName = playerName.trim();
    return trimmedName.isNotEmpty && 
           trimmedName.length >= 2 && 
           trimmedName.length <= 20;
  }

  /// Connects to the WebSocket for a specific room
  void connectToWebSocket(String roomId, String playerId) {
    final url = _repository.getWebSocketUrl(roomId);
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Send join message
    final joinMessage = jsonEncode({
      "message_type": "join",
      "data": {"player_id": playerId}
    });
    _channel?.sink.add(joinMessage);

    // Listen to WebSocket messages
    _channel?.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      switch (decodedMessage['type']) {
        case 'room_state':
          print('Room state: ${decodedMessage['data']}');
          break;
        case 'game_started':
          print('Game started!');
          break;
        default:
          print('Unknown message: $decodedMessage');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  /// Disconnects from the WebSocket
  void disconnectWebSocket() {
    _channel?.sink.close();
    _channel = null;
  }

  /// Disposes the service and its repository
  void dispose() {
    _repository.dispose();
  }
}