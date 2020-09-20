import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/email_edit_screen.dart';

class AuthRequireScreen extends HookWidget{
  @override
  Widget build(BuildContext context) {
    final isEmailRegistered = auth.currentUser.email != null;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('チャット'),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigation(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('チャット機能を利用するには以下のいずれかが必要です。'),
            const SizedBox(height: 16),
            Text(
              '＊どちらも、チャット相手に個人情報が伝わるものではありませんのでご安心ください。',
              style: Theme.of(context).textTheme.caption.copyWith(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AppleまたはGoogleアカウントとの連携'),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.AppleDark,
                        text: 'Appleでログイン',
                        elevation: 0,
                        onPressed: () {
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.GoogleDark,
                        text: 'Googleでログイン',
                        elevation: 0,
                        onPressed: () {
                          signInGoogle();
                        },
                      ),
                    ),
                  ],
                ),
              )
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
                      color: Colors.grey[50],
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: const Text(
                        'or',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('メールアドレスの認証'),
                    const SizedBox(height: 16),
                    isEmailRegistered ? (
                      Align(
                        alignment: Alignment.center,
                        child: SignInButton(
                          Buttons.Email,
                          text: 'メールを認証する',
                          elevation: 0,
                          onPressed: () {
                            sendCode();
                          },
                        ),
                      )
                    ) : (
                      Align(
                        alignment: Alignment.center,
                        child: SignInButton(
                          Buttons.Email,
                          text: 'メールアドレスを登録',
                          elevation: 0,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => EmailEditScreen(auth.currentUser.email),
                              )
                            );
                          },
                        ),
                      )
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
  
}