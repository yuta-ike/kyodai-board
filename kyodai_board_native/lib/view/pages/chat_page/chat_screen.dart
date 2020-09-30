import 'dart:async';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/chat_room.dart';
import 'package:kyodai_board/repo/chat_repo.dart';
import 'package:kyodai_board/repo/club_repo.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:kyodai_board/view/mixins/club_report_dialog.dart';
import 'package:kyodai_board/view/mixins/show_snackbar.dart';

enum MenuItems {
  report
}

class ChatScreen extends HookWidget{
  // ignore: always_require_non_null_named_parameters
  ChatScreen(this.chatroom);

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final ChatRoom chatroom;

  void _send(BuildContext context, ChatMessage message){
    sendMessage(chatroom.id, message);
    print(message.toJson());
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // final chatroom = useChatroom(chatroom.o);
    final club = chatroom.club;
    final messages = useProvider(chatProvider(chatroom.id));
    final user = useState(getChatUser()).value;

    // clubがなければclubを取得
    useEffect((){
      if(chatroom.club == null){
        getClub(chatroom.clubId).then((value){
          chatroom.club = value;
        });
      }
      return null;
    }, []);
    
    return Scaffold(
      key: _key,
      // FIXME: 戻るボタンを押した時にエラーが発生する（メモリリーク）
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(club?.name ?? ''),
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
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
                    ShowSnackBar.show(_key.currentState, '通報を完了しました');
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
              onSend: (message) => _send(context, message),
              textInputAction: TextInputAction.send,
              user: user,
              inputDecoration: const InputDecoration.collapsed(hintText: 'メッセージ'),
              dateFormat: DateFormat('yyyy年MM月dd日'),
              timeFormat: DateFormat('HH:mm'),
              messages: messages,
              scrollToBottom: true,
              onPressAvatar: (ChatUser user) {
                print('OnPressAvatar: ${user.name}');
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
}