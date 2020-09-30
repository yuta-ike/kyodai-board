import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';

class TopPage extends HookWidget{
  Future<void> _loginAnonymously(NavigatorState navigator) async {
    await signInAnonymously();
    await navigator.pushNamedAndRemoveUntil(Routes.mypage, (_) => false);
  }

  Future<void> _moveToLoginPage(NavigatorState navigator) async {
    await navigator.pushNamed(Routes.login);
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
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlineButton(
                          child: const Text('いますぐ利用を開始'),
                          onPressed: () => _loginAnonymously(Navigator.of(context)),
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlineButton(
                          child: const Text('ログイン'),
                          onPressed: () => _moveToLoginPage(Navigator.of(context)),
                          borderSide: const BorderSide(
                            color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      ),
                      Text(
                        '機種変更時にも利用データが失われません。',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Expanded(
                      //         flex: 1,
                      //         child: OutlineButton(
                      //           child: const Text('Appleでログイン'),
                      //           onPressed: _loginApple,
                      //           borderSide: const BorderSide(
                      //             color: Colors.black
                      //           ),
                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      //         ),
                      //       ),
                      //       const SizedBox(width: 16),
                      //       Expanded(
                      //         flex: 1,
                      //         child: OutlineButton(
                      //           child: const Text('Googleでログイン'),
                      //           onPressed: () => _loginGoogle(Navigator.of(context)),
                      //           borderSide: const BorderSide(
                      //             color: Colors.black
                      //           ),
                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 32),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: OutlineButton(
                      //     child: const Text('メールアドレスでログイン'),
                      //     onPressed: () => _loginGoogle(Navigator.of(context)),
                      //     borderSide: const BorderSide(
                      //       color: Colors.black
                      //     ),
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      //   ),
                      // ),
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