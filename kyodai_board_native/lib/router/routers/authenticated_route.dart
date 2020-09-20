import 'package:flutter/material.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/view/screens/auth_require_screen.dart';

PageRoute<T> authenticatedRoute<T> (PageRoute<T> main){
  final isAnonymous = auth.currentUser.isAnonymous;
  final isVerified = auth.currentUser.emailVerified;
  if(!isAnonymous && isVerified){
    return main;
  }else{
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => AuthRequireScreen(),
    );
  }
}