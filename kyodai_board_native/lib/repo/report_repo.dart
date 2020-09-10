import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

Future<void> sendClubReport(String clubId, String clubName, String reportContent, String body){
  final uid = auth.currentUser.uid;
  final userName = auth.currentUser.displayName;
  return fsinstance.collection('report').add(<String, dynamic>{
    'type': 'club',
    'userId': uid,
    'userName': userName,
    'clubId': clubId,
    'clubName': clubName,
    'contentType': reportContent,
    'body': body,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

Future<void> sendEventReport(String eventId, String eventTitle, String clubId, String clubName, String reportContent, String body){
  final uid = auth.currentUser.uid;
  final userName = auth.currentUser.displayName;
  return fsinstance.collection('report').add(<String, dynamic>{
    'type': 'event',
    'userId': uid,
    'userName': userName,
    'eventId': eventId,
    'eventTitle': eventTitle,
    'clubId': clubId,
    'clubName': clubName,
    'contentType': reportContent,
    'body': body,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

Future<void> sendChatReport(String clubId, String clubName, String reportContent, String body){
  final uid = auth.currentUser.uid;
  final userName = auth.currentUser.displayName;
  return fsinstance.collection('report').add(<String, dynamic>{
    'type': 'event',
    'userId': uid,
    'userName': userName,
    'clubId': clubId,
    'clubName': clubName,
    'contentType': reportContent,
    'body': body,
    'createdAt': FieldValue.serverTimestamp(),
  });
}