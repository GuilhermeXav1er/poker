// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRoomRequest _$CreateRoomRequestFromJson(Map<String, dynamic> json) =>
    CreateRoomRequest(
      creatorName: json['creator_name'] as String,
      maxPlayers: (json['max_players'] as num).toInt(),
    );

Map<String, dynamic> _$CreateRoomRequestToJson(CreateRoomRequest instance) =>
    <String, dynamic>{
      'creator_name': instance.creatorName,
      'max_players': instance.maxPlayers,
    };

CreateRoomResponse _$CreateRoomResponseFromJson(Map<String, dynamic> json) =>
    CreateRoomResponse(
      roomId: json['room_id'] as String,
      playerId: json['player_id'] as String,
    );

Map<String, dynamic> _$CreateRoomResponseToJson(CreateRoomResponse instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'player_id': instance.playerId,
    };

JoinRoomRequest _$JoinRoomRequestFromJson(Map<String, dynamic> json) =>
    JoinRoomRequest(
      playerName: json['player_name'] as String,
    );

Map<String, dynamic> _$JoinRoomRequestToJson(JoinRoomRequest instance) =>
    <String, dynamic>{
      'player_name': instance.playerName,
    };

JoinRoomResponse _$JoinRoomResponseFromJson(Map<String, dynamic> json) =>
    JoinRoomResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      playerId: json['playerId'] as String?,
    );

Map<String, dynamic> _$JoinRoomResponseToJson(JoinRoomResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'playerId': instance.playerId,
    };
