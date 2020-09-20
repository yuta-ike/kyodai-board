import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';

class EmailEditScreen extends HookWidget{
  const EmailEditScreen(this.initValue);

  final String initValue;

  Future<void> _send(NavigatorState navigator, String text) async {
    await auth.currentUser.verifyBeforeUpdateEmail(text);
    //TODO: 続き
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initValue);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          'メールアドレス',
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
            const Text('新しいメールアドレスを入力してください'),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: '新しいメールアドレス',
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