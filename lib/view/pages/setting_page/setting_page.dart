import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/interactor/auth_interactor.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';

class SettingPage extends HookWidget{
  Future<void> _signOut(NavigatorState navigator) async {
    await signOut();
    await navigator.pushNamedAndRemoveUntil(Routes.login, (routes) => routes.settings.name == Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        toolbarHeight: 40,
      ),
      bottomNavigationBar: BottomNavigation(),
      body: ListView(
        children: [
          const ListTile(
            title: Text('アカウント情報設定'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          const ListTile(
            title: Text('通知設定'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          const ListTile(
            title: Text('運営からのお知らせ'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          const ListTile(
            title: Text('公式Twitter'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          const ListTile(
            title: Text('FAQ'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          const ListTile(
            title: Text('お問い合わせ'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          const ListTile(
            title: Text('利用規約'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          const ListTile(
            title: Text('バージョン情報'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 0),
          FlatButton(
            onPressed: () => _signOut(Navigator.of(context)),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
  }
}