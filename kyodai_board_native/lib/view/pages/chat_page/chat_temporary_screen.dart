import 'dart:async';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/repo/chat_repo.dart';
import 'package:kyodai_board/repo/club_repo.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:kyodai_board/router/router.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/mixins/club_report_dialog.dart';
import 'package:kyodai_board/view/mixins/show_snackbar.dart';

enum MenuItems {
  report
}

class ChatTemporaryScreen extends HookWidget{
  // ignore: always_require_non_null_named_parameters
  ChatTemporaryScreen(this.clubId);

  final String clubId;


  Future<void> _send(BuildContext context, ChatMessage message, [List<ChatMessage> initialMessages]) async {
    final chatroom = await createChatroom(clubId, initialMessages: [...initialMessages, message]);
    await Navigator.pushReplacementNamed(context, Routes.chatDetail, arguments: RouterProp(chatroom, implicit: true));
  }

  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = useMemoized(getChatUser);
    final chatroom = useChatroomWithId(clubId);
    final club = useClub(clubId);
    final readyForShowMessage = useState(false);

    if(chatroom.data != null && chatroom.data.club == null){
      chatroom.data.club = club.data;
    }

    useEffect((){
      if(chatroom.connectionState == ConnectionState.done){
        if(chatroom.data == null){
          readyForShowMessage.value = true;
          return;
        }
        
        if(club.connectionState == ConnectionState.done){
          SchedulerBinding.instance.addPostFrameCallback((_){
            Navigator.of(context).pushReplacementNamed(Routes.chatDetail, arguments: RouterProp(chatroom.data, implicit: true));
          });
        }
      }
      return null;
    }, [chatroom.connectionState, club.connectionState]);

    final initialMessages = useState(<ChatMessage>[]);

    useEffect((){
      if(club.data != null){
        initialMessages.value = _getinitialMessages(club.data);
      }
      return null;
    }, [club.connectionState]);

    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>(), []);
    final chatKey = useMemoized(() => GlobalKey<DashChatState>(), []);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          readyForShowMessage.value ? (club.data?.name ?? '') : '',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 16,
            color: Colors.white,
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
                  final result = await ReportDialog.showClubReport(context, club.data);
                  if(result ?? false){
                    ShowSnackBar.show(scaffoldKey.currentState, '通報を完了しました');
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
        child:
          // chatroom.connectionState != ConnectionState.done
          // ? const Center(child: Text('loading'))
          // :
            DashChat(
              key: chatKey,
              onSend: (message) => _send(context, message, initialMessages.value),
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: user,
              inputDecoration: const InputDecoration.collapsed(
                hintText: 'メッセージ',
              ),
              inputDisabled: chatroom.connectionState != ConnectionState.done || club.connectionState != ConnectionState.done,
              dateFormat: DateFormat('yyyy年MM月dd日'),
              timeFormat: DateFormat('HH:mm'),
              messages: readyForShowMessage.value ? initialMessages.value : [],
              scrollToBottom: false,
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
              onLoadEarlier: () {},
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
            )
      ),
    );
  }

  List<ChatMessage> _getinitialMessages(Club club) => [
      ChatMessage(
        customProperties: <String, dynamic>{ 'isMeta': true },
        user: ChatUser(
          name: 'スタッフ',
          // ADD avater url
        ),
        text: 'チャットルームへようこそ。\n\nこのチャットルームでは、あなたの情報が団体に知られることはありません。完全に匿名でやりとりが可能です。\n\nまた、既読通知も伝わりません。'
      ),
      if(club?.initialChatMessage != null && club.initialChatMessage.isNotEmpty)
        ChatMessage(
          user: ChatUser(
            uid: club.id,
            name: club.name,
            avatar: club.iconImageUrl,
          ),
          text: club.initialChatMessage,
        )
    ];
}