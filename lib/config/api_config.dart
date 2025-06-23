class ApiConfig {
  static const String baseUrl = 'https://poker-api-c5cz.onrender.com';
  static const String webSocketBaseUrl = 'wss://poker-api-c5cz.onrender.com';
  
  // Room endpoints
  static const String createRoom = '/room';
  static const String joinRoom = '/room/{roomId}/join';
  static const String startGame = '/room/{roomId}/start';
  static const String roomWebSocket = '/room/{roomId}/ws';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  
  // Timeout duration
  static const Duration timeout = Duration(seconds: 30);
}