import '../services/room_service.dart';
import '../models/room_models.dart';

/// Example usage of the RoomService for creating and managing poker rooms
class RoomServiceExample {
  final RoomService _roomService = RoomService();

  /// Example of creating a new room
  Future<void> createRoomExample() async {
    try {
      print('Creating a new poker room...');
      
      final response = await _roomService.createRoom(
        creatorName: 'João Silva',
        maxPlayers: 6,
      );

      print('Room created successfully!');
      print('Room ID: ${response.roomId}');
      print('Player ID: ${response.playerId}');
      
      // Get WebSocket URL for real-time communication
      final wsUrl = _roomService.getWebSocketUrl(response.roomId);
      print('WebSocket URL: $wsUrl');
      
    } catch (e) {
      print('Error creating room: $e');
    }
  }

  /// Example of joining an existing room
  Future<void> joinRoomExample(String roomId) async {
    try {
      print('Joining room: $roomId');
      
      final response = await _roomService.joinRoom(
        roomId: roomId,
        playerName: 'Maria Santos',
      );

      if (response.success) {
        print('Successfully joined the room!');
        print('Player ID: ${response.playerId}');
        print('Message: ${response.message}');
      } else {
        print('Failed to join room: ${response.message}');
      }
      
    } catch (e) {
      print('Error joining room: $e');
    }
  }

  /// Example of starting a game
  Future<void> startGameExample(String roomId) async {
    try {
      print('Starting game in room: $roomId');
      
      await _roomService.startGame(roomId);
      print('Game started successfully!');
      
    } catch (e) {
      print('Error starting game: $e');
    }
  }

  /// Example of input validation
  void validationExample() {
    // Valid room ID
    print('Is "abc12345" a valid room ID? ${_roomService.isValidRoomId("abc12345")}');
    
    // Invalid room ID
    print('Is "abc" a valid room ID? ${_roomService.isValidRoomId("abc")}');
    
    // Valid player name
    print('Is "João" a valid player name? ${_roomService.isValidPlayerName("João")}');
    
    // Invalid player name
    print('Is "A" a valid player name? ${_roomService.isValidPlayerName("A")}');
  }

  /// Clean up resources
  void dispose() {
    _roomService.dispose();
  }
}

/// Usage example:
/// 
/// ```dart
/// void main() async {
///   final example = RoomServiceExample();
///   
///   // Create a room
///   await example.createRoomExample();
///   
///   // Join a room (replace with actual room ID)
///   await example.joinRoomExample('abc12345');
///   
///   // Start a game
///   await example.startGameExample('abc12345');
///   
///   // Test validation
///   example.validationExample();
///   
///   // Clean up
///   example.dispose();
/// }
/// ``` 