import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';

StreamProvider<User> userProvider = StreamProvider<User>((ref) {
  return auth.authStateChanges()
      // ..listen((event) {
      //   //ルーティングをやり直したいけどcontextがないのでどうしようもない
      // })
      ;
});