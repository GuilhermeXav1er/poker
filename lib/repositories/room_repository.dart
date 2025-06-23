import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/room_models.dart';

class RoomRepository {
  final http.Client _httpClient;

  RoomRepository({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  /// Creates a new poker room
  /// 
  /// [request] - The room creation request containing creator name and max players
  /// Returns a [CreateRoomResponse] with room ID and player ID
  /// Throws [Exception] if the request fails
  Future<CreateRoomResponse> createRoom(CreateRoomRequest request) async {
    try {
      print(request.toJson());
      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createRoom}'),
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("teste3");
        final jsonResponse = jsonDecode(response.body);
        print("teste4");
        return CreateRoomResponse.fromJson(jsonResponse);
        print("teste5");
      } else {
        throw Exception('Failed to create room: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating room: $e');
    }
  }

  /// Joins an existing poker room
  /// 
  /// [roomId] - The ID of the room to join
  /// [request] - The join room request containing player name
  /// Returns a [JoinRoomResponse] with success status and player ID
  /// Throws [Exception] if the request fails
  Future<JoinRoomResponse> joinRoom(String roomId, JoinRoomRequest request) async {
    try {
      final url = ApiConfig.joinRoom.replaceAll('{roomId}', roomId);
      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}$url'),
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return JoinRoomResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to join room: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error joining room: $e');
    }
  }

  /// Starts a game in the specified room
  /// 
  /// [roomId] - The ID of the room to start the game in
  /// Throws [Exception] if the request fails
  Future<void> startGame(String roomId) async {
    try {
      final url = ApiConfig.startGame.replaceAll('{roomId}', roomId);
      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}$url'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 200) {
        throw Exception('Failed to start game: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error starting game: $e');
    }
  }

  /// Gets the WebSocket URL for a room
  /// 
  /// [roomId] - The ID of the room
  /// Returns the WebSocket URL as a string
  String getWebSocketUrl(String roomId) {
    final url = ApiConfig.roomWebSocket.replaceAll('{roomId}', roomId);
    return '${ApiConfig.webSocketBaseUrl}$url';
  }

  /// Disposes the HTTP client
  void dispose() {
    _httpClient.close();
  }
}