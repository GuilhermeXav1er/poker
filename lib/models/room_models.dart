import 'package:json_annotation/json_annotation.dart';

part 'room_models.g.dart';

@JsonSerializable()
class CreateRoomRequest {
  @JsonKey(name: 'creator_name')
  final String creatorName;
  @JsonKey(name: 'max_players')
  final int maxPlayers;

  CreateRoomRequest({
    required this.creatorName,
    required this.maxPlayers,
  });

  factory CreateRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRoomRequestToJson(this);
}

@JsonSerializable()
class CreateRoomResponse {
  @JsonKey(name: 'room_id')
  final String roomId;
  @JsonKey(name: 'player_id')
  final String playerId;

  CreateRoomResponse({
    required this.roomId,
    required this.playerId,
  });

  factory CreateRoomResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRoomResponseToJson(this);
}

@JsonSerializable()
class JoinRoomRequest {
  @JsonKey(name: 'player_name')
  final String playerName;

  JoinRoomRequest({
    required this.playerName,
  });

  factory JoinRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinRoomRequestToJson(this);
}

@JsonSerializable()
class JoinRoomResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'player_id')
  final String? playerId;

  JoinRoomResponse({
    required this.success,
    required this.message,
    this.playerId,
  });

  factory JoinRoomResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JoinRoomResponseToJson(this);
}