import 'package:firebase_auth/firebase_auth.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

// TODO: ユーザーモデルを定義する

Future<void> registerUserData(User user, { bool isAnonymous = false }) async {
  await fsinstance.collection('users').doc(user.uid).set(<String, dynamic>{
    'displayName': user.displayName,
    'email': user.email,
    'photoURL': user.photoURL,
    'isAnonymous': isAnonymous,
  });
}