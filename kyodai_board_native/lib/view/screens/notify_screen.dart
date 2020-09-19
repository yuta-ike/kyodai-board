
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NotifyScreen extends HookWidget{
  const NotifyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('通知設定'),
      ),
      body: ListView(
        children: [
          _buildListTile(context, '通知を受け取る', true, (_) => print('change')),
          _buildListTile(context, 'ブックマークしているイベントの更新内容の通知を受け取る', true, (_) => print('change')),
          _buildListTile(context, 'ブックマークしている団体の更新内容の通知を受け取る', true, (_) => print('change')),
        ],
      )
    );
  }

  Widget _buildListTile(BuildContext context, String text, bool isSelected, void Function(bool) onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(text),
          ),
          Switch(
            value: isSelected,
            onChanged: onChange,
          )
        ],
      ),
    );
  }
}