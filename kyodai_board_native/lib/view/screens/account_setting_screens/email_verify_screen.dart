import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';

class EmailVerifyScreen extends HookWidget{
  const EmailVerifyScreen();


  Future<void> _send(NavigatorState navigator) async {
    await auth.currentUser.sendEmailVerification();
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('メールアドレス認証'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: [
            const Text(
              '下記メールアドレスを認証しますか？',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                auth.currentUser.email,
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: OutlineButton(
                onPressed: () => _send(Navigator.of(context)),
                child: const Text('認証'),
              ),
            ),
          ],
        ),
      )
    );
  }
}