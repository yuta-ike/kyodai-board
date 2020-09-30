import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';

class RegisterPage extends HookWidget{

  Future<void> _moveToLogin(NavigatorState navigator) async {
    await navigator.pushNamed(Routes.login);
  }

  Future<void> _register(NavigatorState navigator, String email, String password) async {
    await signUpWithEmail(email, password);
    await navigator.pushReplacementNamed(Routes.emailVerify);
  }

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
                Container(
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
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlineButton(
                          child: const Text('登録'),
                          onPressed: () => _register(Navigator.of(context), email.text, password.text),
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: OutlineButton(
                          child: const Text('戻る'),
                          onPressed: () => _moveToLogin(Navigator.of(context)),
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      ),
                    ],
                  )
                ),

                
              ],
            )
          ),
        ),
      )
    );
  }
}