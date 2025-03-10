import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/router/routes.dart';

final routes = {
  // const BottomNavigationBarItem(icon: Icon(Icons.face), title: Text('マイページ')): Routes.mypage,
  const BottomNavigationBarItem(icon: Icon(Icons.palette), title: Text('団体')): Routes.clubs,
  const BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('イベント')): Routes.boards,
  const BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text('チャット')): Routes.chat,
  const BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('設定')): Routes.settings,
};

final items = routes.keys.toList();

StateProvider<int> currentPageIndex = StateProvider((ref){
  return 0;
});

class BottomNavigation extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final pageIndex = useProvider(currentPageIndex);

    return Hero(
      tag: 'hero',
      child: BottomNavigationBar(
        elevation: 4,
        items: items,
        currentIndex: pageIndex.state,
        onTap: (index) async {
          pageIndex.state = index;
          await Navigator.of(context).pushReplacementNamed(routes[items[index]]);
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}