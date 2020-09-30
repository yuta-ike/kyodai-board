import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';

class EmailVerifyPage extends HookWidget{

  Future<void> _moveToLogin(NavigatorState navigator) async {
    await navigator.pushNamed(Routes.login);
  }

  Future<void> _verify(NavigatorState navigator, String code) async {
    await verifyCode(code);
    await navigator.pushNamedAndRemoveUntil(Routes.mypage, (_) => false);
  }

  // ignore: unused_element
  Future<void> _sendCode() async {
    await _sendCode();
  }

  @override
  Widget build(BuildContext context) {
    final code = useTextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(32),
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        controller: code,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: '認証コード'
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlineButton(
                          child: const Text('認証'),
                          onPressed: () => _verify(Navigator.of(context), code.text),
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: OutlineButton(
                      //     child: const Text('コードを再送する'),
                      //     onPressed: _sendCode,
                      //     borderSide: const BorderSide(
                      //       color: Colors.black
                      //     ),
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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