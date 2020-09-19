import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';

class LoginPage extends HookWidget{
  Future<void> _loginWithEmail(NavigatorState navigator, String email, String password) async {
    await signInWithEmail(email, password);
    await navigator.pushReplacementNamed(Routes.mypage);
  }

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

  Future<void> _moveToRegister(NavigatorState navigator) async {
    await navigator.pushNamed(Routes.register);
  }

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final email = useTextEditingController();
    final password = useTextEditingController();

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
                      Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: email,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(focusNode); // 変更
                              },
                              decoration: const InputDecoration(
                                labelText: 'メールアドレス'
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: password,
                              focusNode: focusNode,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'パスワード'
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                child: Text(
                                  'パスワードを忘れた',
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                onPressed: () => print('パスワードを忘れた'),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                              ),
                            ),
                            OutlineButton(
                              child: const Text('ログイン'),
                              onPressed: (){
                                if(_form.currentState.validate()){
                                  _loginWithEmail(Navigator.of(context), email.text, password.text);
                                }
                              },
                              borderSide: const BorderSide(
                                color: Colors.black
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        child: const Text('新規登録'),
                        onPressed: () => _moveToRegister(Navigator.of(context)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                      
                      Stack(
                        children: [
                          const Divider(
                            height: 64,
                            color: Colors.grey,
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 48),
                                child: const Text(
                                  'or',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    backgroundColor: Colors.white,
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlineButton(
                              child: const Text('Appleでログイン'),
                              onPressed: _loginApple,
                              borderSide: const BorderSide(
                                color: Colors.black
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlineButton(
                              child: const Text('Googleでログイン'),
                              onPressed: () => _loginGoogle(Navigator.of(context)),
                              borderSide: const BorderSide(
                                color: Colors.black
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            ),
                          ),
                        ],
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