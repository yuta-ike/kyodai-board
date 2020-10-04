import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountEditScreen extends HookWidget{
  const AccountEditScreen({this.title, this.initValue, this.label, this.hintText, this.send});

  final String title, initValue, label, hintText;
  final Future<void> Function(String) send;

  Future<void> _send(NavigatorState navigator, String text) async {
    await send(text);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initValue);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: [
            Text(label),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clear,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: OutlineButton(
                onPressed: () => _send(Navigator.of(context), controller.text),
                child: const Text('保存'),
              ),
            ),
          ],
        ),
      )
    );
  }
}