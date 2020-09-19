import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/chat_room.dart';
import 'package:kyodai_board/repo/chat_repo.dart';
import 'package:kyodai_board/router/router.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';
import 'package:kyodai_board/utils/date_extension.dart';

// TODO: 初期メッセージの順序が入れ替わったりする

class ChatPage extends HookWidget{
  
  void _moveToChatroom(NavigatorState navigator, ChatRoom chatroom){
    navigator.pushNamed(Routes.chatDetail, arguments: RouterProp(chatroom) /*chat id */);
  }

  @override
  Widget build(BuildContext context) {
    final chatrooms = useProvider(chatRoomProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('チャットルーム一覧'),
      ),
      bottomNavigationBar: BottomNavigation(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // テキスト表示に必要
        children: [
          Expanded(
            child: chatrooms.when(
              loading: () => const Center(child: Text('loading')),
              error: (dynamic _, __) => const Center(child: Text('loading')),
              data: (chatrooms) {
                if(chatrooms.isEmpty){
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 128, horizontal: 32),
                    child: Text(
                      '団体の人と匿名で直接チャットができます。\n\nお話ししたい団体を見つけたら、\n詳細ページのチャットボタンを押して\nチャットを開始しましょう。',
                      textAlign: TextAlign.center,
                    )
                  );
                }else{
                  return ListView.separated(
                    itemCount: chatrooms.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final chatroom = chatrooms[index];
                      return InkWell(
                        onTap: () => _moveToChatroom(Navigator.of(context), chatroom),
                        child: Row(
                          children: [
                            AsyncImage(
                              imageUrl: chatroom.club.profile.iconImageUrl,
                              imageBuilder: (context, image) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircleAvatar(
                                  backgroundImage: image,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(chatroom.club.profile.name),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Text(
                                    chatroom.updatedAt.approximatelyFormat(), //TODO: ちゃんとする
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if(chatroom.hasUnreadForStudent)
                                    Badge(
                                      elevation: 0,
                                      padding: const EdgeInsets.all(5),
                                      badgeContent: Container(
                                        height: 5,
                                        width: 5,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                      ),
                                    ),
                                ]
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
}