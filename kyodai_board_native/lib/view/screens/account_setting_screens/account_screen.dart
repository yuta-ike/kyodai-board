import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/atom/text_with_icon.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/account_edit_screen.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/email_edit_screen.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/email_verify_screen.dart';

class AccountScreen extends HookWidget{
  Future<void> _signOut(NavigatorState navigator) async {
    await signOut();
    await navigator.pushNamedAndRemoveUntil(Routes.top, (routes) => routes.settings.name == Routes.top);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('アカウント情報'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('ユーザー情報'),
          ),
          const Divider(height: 1, thickness: 1,),
          _buildUserInfoListTile(
            context,
            '氏名',
            Text(
              auth.currentUser.displayName ?? '未登録',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AccountEditScreen(
                  title: '氏名変更',
                  label: '新しい氏名を入力してください',
                  hintText: '新しい氏名',
                  initValue: auth.currentUser.displayName,
                  send: (x) async => print(x),
                ),
              )
            ),
          ),
          const Divider(height: 1, thickness: 1,),
          _buildUserInfoListTile(
            context,
            'メールアドレス',
            Text(
              auth.currentUser.email ?? '未登録',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EmailEditScreen(auth.currentUser.email),
              )
            ),
          ),
          const Divider(height: 1, thickness: 1,),
          _buildUserInfoListTile(
            context,
            'メールアドレスの認証状態',
            TextWithIcon(
              auth.currentUser.emailVerified ? '認証済み' : auth.currentUser.email == null ? '未登録' : '未認証',
              spacing: 8,
              iconColor: auth.currentUser.emailVerified ? Colors.green : Theme.of(context).errorColor,
              leadingIcon: auth.currentUser.emailVerified ? Icons.verified_user : null,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            auth.currentUser.email == null
              ? null //TODO: show error
              : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EmailVerifyScreen(),
                )
              ),
          ),
          const Divider(height: 1, thickness: 1,),

          const SizedBox(height: 64),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('アカウント連携'),
          ),
          const Divider(height: 1, thickness: 1,),
          // TODO: AppleのProvider IDを正しいものに差し替え
          _buildAccountListTile(
            context,
            'Apple',
            auth.currentUser.providerData.any((provider) => provider.providerId == 'apple.com'),
            'Appleアカウントと連携する',
            () => print('Appleと連携'),
          ),
          const Divider(height: 1, thickness: 1,),
          _buildAccountListTile(
            context,
            'Google',
            auth.currentUser.providerData.any((provider) => provider.providerId == 'google.com'),
            'Googleアカウントと連携する',
            signInGoogle,
          ),
          const Divider(height: 1, thickness: 1,),

          if(!auth.currentUser.isAnonymous) ...[
            const SizedBox(height: 64),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('その他'),
            ),
            const Divider(height: 1, thickness: 1,),
            // TODO: ダイアログを出してログアウト
            _buildActionListTile(context, const Text('ログアウト'), () => print('ログアウト')),
            const Divider(height: 1, thickness: 1,),
            // TODO: ダイアログを出して退会処理
            _buildActionListTile(context, const Text('退会'), () => print('退会')),
            const Divider(height: 1, thickness: 1,),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountListTile(BuildContext context, String topic, bool isVerified, String label, void Function() send) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(topic)
                ),
                const SizedBox(width: 32),
                if(isVerified)
                  TextWithIcon(
                    '連携済み',
                    spacing: 8,
                    iconColor: Colors.green,
                    leadingIcon: Icons.done,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                if(!isVerified)
                  TextWithIcon(
                    '未連携',
                    spacing: 8,
                    iconColor: Theme.of(context).errorColor,
                    leadingIcon: Icons.clear,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
              ],
            ),
          ),
          if(isVerified)
            FlatButton(
              onPressed: send,
              child: const Text('連携済み'),
            ),
          if(!isVerified)
            OutlineButton(
              onPressed: send,
              child: const Text('連携する'),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfoListTile(BuildContext context, String topic, Widget label, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 4),
                  label,
                ],
              ),
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }

  Widget _buildActionListTile(BuildContext context, Widget label, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  label,
                ],
              ),
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}