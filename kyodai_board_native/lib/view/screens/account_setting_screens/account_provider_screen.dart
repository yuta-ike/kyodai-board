import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountProviderScreen extends HookWidget{
  const AccountProviderScreen({ this.label, this.isVerified, this.send });

  final String label;
  final bool isVerified;
  final Future<void> Function() send;

  Future<void> _send(NavigatorState navigator) async {
    await send();
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('アカウント連携'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: OutlineButton(
                onPressed: isVerified ? null : () => _send(Navigator.of(context)),
                child: Text(
                  isVerified ? '連携済みです' : '連携',
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}