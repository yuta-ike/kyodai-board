import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';

class LoginPage extends HookWidget{
  Future<void> _loginGoogle(NavigatorState navigator) async {
    final result = await signInGoogle();
    if(result){
      await navigator.pushReplacementNamed(Routes.mypage);
    }
  }

  void _loginApple(){
    print('Appleでログイン');
  }

  Future<void> _moveToTop(NavigatorState navigator) async {
    await navigator.popAndPushNamed(Routes.top);
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
                        children: const [
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
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlineButton(
                          child: const Text('Appleでログイン'),
                          onPressed: _loginApple,
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlineButton(
                          child: const Text('Googleでログイン'),
                          onPressed: () => _loginGoogle(Navigator.of(context)),
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      ),
                      const Divider(
                        height: 64,
                        color: Colors.grey,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlineButton(
                          child: const Text('戻る'),
                          onPressed: () => _moveToTop(Navigator.of(context)),
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
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