import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/repo/chat_repo.dart';
import 'package:kyodai_board/repo/club_repo.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';
import 'package:kyodai_board/router/router.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/mixins/club_report_dialog.dart';
import 'package:kyodai_board/view/mixins/show_snackbar.dart';

enum MenuItems {
  report
}

class ChatScreen extends HookWidget{
  // ignore: always_require_non_null_named_parameters
  ChatScreen({ this.chatId, this.clubId })
    : assert(chatId == null || clubId == null, '[chatId]と[clubId]は同時に指定できません'){
      print('instantiate');
    }

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final String chatId;
  final String clubId;
  bool get isTemporary => clubId != null;

  Future<void> _toOrdinary(BuildContext context, List<ChatMessage> initialMessages) async {
    final chatId = await createChatroom(clubId, initialMessages: initialMessages);
    await Navigator.pushReplacementNamed(context, Routes.chatDetail, arguments: RouterProp(chatId, implicit: true));
  }

  void _send(BuildContext context, ChatMessage message, [Club club]){
    // Temporary chatの場合は遷移する
    if(isTemporary){
      _toOrdinary(context, [message, ..._getinitialMessages(club)]);
      return;
    }

    sendMessage(chatId, message);
    print(message.toJson());
  }

  // FIXME: 何度もリレンダーされる問題
  @override
  Widget build(BuildContext context) {
    print('biuld');
    final chatroom = useFuture(getChatroom(chatId));
    final _club = useFuture(getClub(clubId));
    final club = chatroom.data?.club ?? _club.data;
    final messages = useProvider(chatProvider(isTemporary ? null : chatId));
    final user = useState(getChatUser()).value;

    final key = GlobalKey<ScaffoldState>();

    // TODO: コンポーネントを分離したい
    return Scaffold(
      key: key,
      // TODO: 戻るアニメーションをつける
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(club?.profile?.name ?? ''),
        actions: [
          if(club != null)
            PopupMenuButton<MenuItems>(
              initialValue: MenuItems.report,
              icon: const Icon(Icons.more_vert),
              offset: const Offset(0, 100),
              onSelected: (MenuItems item) async {
                if(item == MenuItems.report){
                  final result = await ReportDialog.showClubReport(context, club);
                  if(result ?? false){
                    ShowSnackBar.show(key.currentState, '通報を完了しました');
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                return const [PopupMenuItem(
                  child: Text('通報'),
                  value: MenuItems.report,
                )];
              },
            ),
        ],
      ),
      body: SafeArea(
        child: messages.when(
          loading: () => const Center(child: Text('loading')),
          error: (_, __) => const Center(child: Text('error')),
          data: (messages){
            return DashChat(
              key: _chatViewKey,
              onSend: (message) => _send(context, message, club),
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: user,
              inputDecoration: const InputDecoration.collapsed(hintText: 'メッセージ'),
              dateFormat: DateFormat('yyyy年 MM月dd日'),
              timeFormat: DateFormat('HH:mm'),
              messages: messages.isEmpty ? _getinitialMessages(club) : messages,
              scrollToBottom: true,
              onPressAvatar: (ChatUser user) {
                print("OnPressAvatar: ${user.name}");
              },
              inputMaxLines: 5,
              messageContainerPadding: const EdgeInsets.only(left: 5, right: 5),
              alwaysShowSend: true,
              inputTextStyle: const TextStyle(fontSize: 16),
              inputContainerStyle: BoxDecoration(
                border: Border.all(width: 0),
                color: Colors.white,
              ),
              onQuickReply: (Reply reply) {
                messages.add(
                  ChatMessage(
                    text: reply.value,
                    createdAt: DateTime.now(),
                    user: user
                  )
                );
                Timer(const Duration(milliseconds: 300), () {
                  _chatViewKey.currentState.scrollController
                    .animateTo(
                      _chatViewKey.currentState.scrollController.position
                          .maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );

                  // if (i == 0) {
                  //   systemMessage();
                  //   Timer(Duration(milliseconds: 600), () {
                  //     systemMessage();
                  //   });
                  // } else {
                  //   systemMessage();
                  // }
                });
              },
              onLoadEarlier: () {
                print('laoding...');
              },
              showTraillingBeforeSend: true,
              trailing: <Widget>[
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () async {
                    // File result = await ImagePicker.getImage(
                    //   source: ImageSource.gallery,
                    //   imageQuality: 80,
                    //   maxHeight: 400,
                    //   maxWidth: 400,
                    // );

                    // if (result != null) {
                    //   final StorageReference storageRef =
                    //       FirebaseStorage.instance.ref().child("chat_images");

                    //   StorageUploadTask uploadTask = storageRef.putFile(
                    //     result,
                    //     StorageMetadata(
                    //       contentType: 'image/jpg',
                    //     ),
                    //   );
                    //   StorageTaskSnapshot download =
                    //       await uploadTask.onComplete;

                    //   String url = await download.ref.getDownloadURL();

                    //   ChatMessage message =
                    //       ChatMessage(text: "", user: user, image: url);

                    //   var documentReference = Firestore.instance
                    //       .collection('messages')
                    //       .document(DateTime.now()
                    //           .millisecondsSinceEpoch
                    //           .toString());

                    //   Firestore.instance.runTransaction((transaction) async {
                    //     await transaction.set(
                    //       documentReference,
                    //       message.toJson(),
                    //     );
                    //   });
                    // }
                  },
                )
              ],
            );
          }
        ),
      ),
    );
  }

  List<ChatMessage> _getinitialMessages(Club club) => [
      ChatMessage(
        user: ChatUser(
          uid: null,
          name: 'スタッフ',
          // ADD avater url
        ),
        text: 'チャットルームへようこそ。\n\nこのチャットルームでは、あなたの情報が団体に知られることはありません。完全に匿名でやりとりが可能です。\n\nまた、既読通知も伝わりません。'
      ),
      if(club?.initialMessage != null)
        ChatMessage(
          user: ChatUser(
            uid: null,
            name: club.profile.name,
            avatar: club.profile.iconImageUrl,
          ),
          text: club.initialMessage,
        )
    ];
}