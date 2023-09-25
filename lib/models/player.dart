import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Player {
  final String nickname;
  final String socketID;
  final String playerType;

  Player({
    required this.nickname,
    required this.socketID,
    required this.playerType,
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'socketID': socketID,
      'playerType': playerType,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    try {
      final nickname = map['nickname'] ?? '';
      final socketID = map['socketID'] ?? '';
      final playerType = map['playerType'] ?? '';

      return Player(
        nickname: nickname,
        socketID: socketID,
        playerType: playerType,
      );
    } catch (e) {
      print('Error in Player.fromMap: $e');
      return Player(
        nickname: '',
        socketID: '',
        playerType: '',
      );
    }
  }



  Player copyWith({
    String? nickname,
    String? socketID,
    String? playerType,
  }) {
    return Player(
      nickname: nickname ?? this.nickname,
      socketID: socketID ?? this.socketID,
      playerType: playerType ?? this.playerType,
    );
  }
}
