import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';

class MyPage extends HookWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
        toolbarHeight: 40,
      ),
      bottomNavigationBar: BottomNavigation(),
      body: Center(
        child: Text('Here is mypage'),
      ),
    );
  }
}