import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';

class ChatPage extends HookWidget{
  
  void _moveToChatroom(NavigatorState navigator, /* data */){
    navigator.pushNamed(Routes.chatDetail, arguments: '0'/* chat id */);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('チャットルーム一覧'),
      ),
      bottomNavigationBar: BottomNavigation(),
      body: Column(
        children: [
          const Text('TOOLBAR'),
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                onTap: () => _moveToChatroom(Navigator.of(context)),
                leading: AsyncImage(
                  imageUrl: 'https://3.bp.blogspot.com/---bC5f3l67Y/VCIkKXEkX8I/AAAAAAAAmkc/xOSiXCTwebk/s170/monster12.png',
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: const Text('京都大学フリスビーサークル'),
                trailing: Column(
                  children: [
                    const Text(
                      '昨日',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Badge(
                      elevation: 0,
                      padding: const EdgeInsets.all(5),
                      badgeContent: const Text(
                        '12',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}