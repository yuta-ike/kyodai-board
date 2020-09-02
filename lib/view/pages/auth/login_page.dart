import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';

class LoginPage extends HookWidget{
  Future<void> _loginGoogle(NavigatorState navigator) async {
    await signInGoogle();
    await navigator.pushReplacementNamed(Routes.mypage);
  }

    void _loginApple(){
    print('Appleでログイン');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(32),
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            size: 120,
                          ),
                          Text(
                            '京  大  カ  タ  ロ  グ',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'メールアドレス'
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'パスワード'
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlineButton(
                        child: const Text('ログイン'),
                        onPressed: () => print('Appleでログイン'),
                        borderSide: const BorderSide(
                          color: Colors.black
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                      const Divider(height: 64),
                      OutlineButton(
                        child: const Text('Appleでログイン'),
                        onPressed: _loginApple,
                        borderSide: const BorderSide(
                          color: Colors.black
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                      OutlineButton(
                        child: const Text('Googleでログイン'),
                        onPressed: () => _loginGoogle(Navigator.of(context)),
                        borderSide: const BorderSide(
                          color: Colors.black
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    ],
                  )
                )
              ],
            )
          ),
        ),
      )
    );
  }
}