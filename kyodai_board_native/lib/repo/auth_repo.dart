import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

Future<void> registerUserData(User user) async {
  await fsinstance.collection('users').doc(user.uid).set(<String, dynamic>{
    'displayName': user.displayName,
    'email': user.email,
    'photoURL': user.photoURL,
    'chatrooms': <DocumentReference>[],
    'bookmarkedEvents': <DocumentReference>[],
    'bookmarkedClubs': <DocumentReference>[],
  });
}