import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';

class SettingPage extends HookWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '設定',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 50,
      ),
      bottomNavigationBar: BottomNavigation(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('アカウント情報'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(Routes.settingsAccount),
          ),
          const Divider(height: 0),
          // NOTE: 一旦通知はなし
          // ListTile(
          //   title: const Text('通知設定'),
          //   trailing: const Icon(Icons.chevron_right),
          //   onTap: () => Navigator.of(context).pushNamed(Routes.settingsNotify),
          // ),
          // const Divider(height: 0),
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
          ListTile(
            title: const Text('バージョン情報'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(Routes.version),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}