# Room Service Documentation

This directory contains the service layer for managing poker room operations in the Flutter application.

## Overview

The room service provides a high-level interface for creating, joining, and managing poker rooms through the REST API backend.

## Files

### `room_service.dart`
The main service class that provides room management functionality.

**Key Features:**
- Create new poker rooms
- Join existing rooms
- Start games
- Input validation
- WebSocket URL generation

**Main Methods:**
- `createRoom(creatorName, maxPlayers)` - Creates a new room
- `joinRoom(roomId, playerName)` - Joins an existing room
- `startGame(roomId)` - Starts a game in a room
- `getWebSocketUrl(roomId)` - Gets WebSocket URL for real-time communication
- `isValidRoomId(roomId)` - Validates room ID format
- `isValidPlayerName(playerName)` - Validates player name

### `room_repository.dart`
The repository layer that handles direct API communication.

**Key Features:**
- HTTP client management
- API endpoint communication
- Error handling
- Response parsing

### `room_models.dart`
Data models for room-related operations.

**Models:**
- `CreateRoomRequest` - Request model for creating rooms
- `CreateRoomResponse` - Response model for room creation
- `JoinRoomRequest` - Request model for joining rooms
- `JoinRoomResponse` - Response model for room joining

## Usage Example

```dart
import 'package:poker/services/room_service.dart';

void main() async {
  final roomService = RoomService();
  
  try {
    // Create a new room
    final createResponse = await roomService.createRoom(
      creatorName: 'João Silva',
      maxPlayers: 6,
    );
    
    print('Room created: ${createResponse.roomId}');
    print('Player ID: ${createResponse.playerId}');
    
    // Get WebSocket URL for real-time communication
    final wsUrl = roomService.getWebSocketUrl(createResponse.roomId);
    print('WebSocket URL: $wsUrl');
    
  } catch (e) {
    print('Error: $e');
  } finally {
    roomService.dispose();
  }
}
```

## API Endpoints

The service communicates with the following backend endpoints:

- `POST /room` - Create a new room
- `POST /room/{roomId}/join` - Join an existing room
- `POST /room/{roomId}/start` - Start a game in a room
- `ws://localhost:3000/room/{roomId}/ws` - WebSocket connection

## Error Handling

The service includes comprehensive error handling:

- Input validation for room IDs and player names
- Network error handling with timeouts
- HTTP status code validation
- Descriptive error messages

## Dependencies

- `http` - For HTTP requests
- `json_annotation` - For JSON serialization
- `json_serializable` - For code generation (dev dependency)
- `build_runner` - For code generation (dev dependency)

## Setup

1. Add dependencies to `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
  json_annotation: ^4.8.1

dev_dependencies:
  json_serializable: ^6.7.1
  build_runner: ^2.4.7
```

2. Run `flutter pub get` to install dependencies

3. Generate JSON serialization code:
```bash
flutter packages pub run build_runner build
```

## Configuration

The API configuration is defined in `lib/config/api_config.dart`:

- Base URL: `http://localhost:3000`
- Timeout: 30 seconds
- Default headers: `Content-Type: application/json`

## Testing

See `lib/examples/room_service_example.dart` for usage examples and testing scenarios. 