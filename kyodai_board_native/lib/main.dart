import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/router/router.dart';
import 'package:kyodai_board/view/style/theme.dart';
import 'dart:convert';

void main() {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Firebase
    await Firebase.initializeApp();
    // Remote Config
    final remoteConfig = await RemoteConfig.instance;
    try {
      await remoteConfig.fetch(expiration: const Duration(hours: 3));
      await remoteConfig.activateFetched();
      final tags = remoteConfig.getString('tags');
      
      print('tags = ${tags}');
    }catch(e){
      print("Error");
    }
    runApp(ProviderScope(child: MyApp()));
  }

  init();
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useStream<User>(auth.authStateChanges());
    
    return MaterialApp(
      title: '京大ボード',
      theme: themeData,
      onGenerateRoute: Router.generateRoute,
    );
  }
}