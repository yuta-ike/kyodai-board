import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

class ChatRoom{
  ChatRoom({
    this.id,
    this.lastMessageId,
    this.lastClubReadId,
    this.lastStudentReadId,
    this.studentId,
    this.clubId,
    this.updatedAt,
    this.club,
  });

  ChatRoom.fromMap(this.id, Map<String, dynamic> map, { this.club })
      : lastMessageId = map.getString('lastMessageId')
      , lastClubReadId = map.getString('lastClubReadId')
      , lastStudentReadId = map.getString('lastStudentReadId')
      , studentId = map.getString('studentId')
      , updatedAt = map.getDate('updatedAt')
      , clubId = map.getString('clubId');

  final String id;
  final String lastMessageId;
  final String lastClubReadId;
  final String lastStudentReadId;
  final String studentId;
  final String clubId;
  final DateTime updatedAt;
  Club club;

  bool get hasUnreadForStudent => lastMessageId != lastStudentReadId;
}