import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/view/components/atom/text_with_icon.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/account_edit_screen.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/account_provider_screen.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/email_edit_screen.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/email_verify_screen.dart';

class AccountScreen extends HookWidget{
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
          _buildListTile(
            context,
            '氏名',
            Text(
              auth.currentUser.displayName,
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
          _buildListTile(
            context,
            'メールアドレス',
            Text(
              auth.currentUser.email,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EmailEditScreen(auth.currentUser.email),
              )
            ),
          ),
          const Divider(height: 1, thickness: 1,),
          _buildListTile(
            context,
            'メールアドレスの認証状態',
            TextWithIcon(
              auth.currentUser.emailVerified ? '認証済み' : '未認証',
              spacing: 8,
              iconColor: auth.currentUser.emailVerified ? Colors.green : Theme.of(context).errorColor,
              leadingIcon: auth.currentUser.emailVerified ? Icons.verified_user : null,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            () => Navigator.of(context).push(
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
            auth.currentUser.providerData.where((provider) => provider.providerId == 'apple.com').isNotEmpty,
            'Appleアカウントと連携する',
            () => print('Appleと連携'),
          ),
          const Divider(height: 1, thickness: 1,),
          _buildAccountListTile(
            context,
            'Google',
            auth.currentUser.providerData.where((provider) => provider.providerId == 'google.com').isNotEmpty,
            'Googleアカウントと連携する',
            () => print('Googleと連携'),
          ),
          const Divider(height: 1, thickness: 1,),
        ],
      ),
    );
  }

  Widget _buildAccountListTile(BuildContext context, String topic, bool isVerified, String label, void Function() send) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => AccountProviderScreen(label: label, send: () async => send(), isVerified: isVerified),
        )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
              const Icon(Icons.chevron_right),
            if(!isVerified)
              const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String topic, Widget label, void Function() onTap) {
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
}