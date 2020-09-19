import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info/package_info.dart';

class VersionScreen extends HookWidget{
  const VersionScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('バージョン情報'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) => ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('アプリ名'),
                trailing: Text(snapshot.data?.appName ?? ''),
              ),
              const Divider(height: 0),
              ListTile(
                title: const Text('バージョン'),
                trailing: Text(snapshot.data?.version ?? ''),
              ),
              const Divider(height: 0),
              ListTile(
                title: const Text('ビルド番号'),
                trailing: Text(snapshot.data?.buildNumber ?? ''),
              ),
              const Divider(height: 0),
            ],
          ),
        ),
      )
    );
  }
}