import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/repo/chat_repo.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

enum MenuItems {
  report
}

class ChatScreen extends HookWidget{
  ChatScreen(this.chatId);
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final String chatId;

  void _send(ChatMessage message){
    fsinstance.collection('chat').add(
      message.toJson()
    );
    print(message.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final chatData = useProvider(chatProvider);

    final user = ChatUser(
      name: "Fayeed",
      firstName: "Fayeed",
      lastName: "Pawaskar",
      uid: "11111111",
      avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('京都大学フリスビー同好会'),
        actions: [
          PopupMenuButton<MenuItems>(
            initialValue: MenuItems.report,
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 100),
            onSelected: (MenuItems item) {
              if(item == MenuItems.report){
                print('通報処理');
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
        child: chatData.when(
          loading: () => const Center(child: Text('loading')),
          error: (_, __) => const Center(child: Text('error')),
          data: (chatSnapshot){
            final List<DocumentSnapshot> items = chatSnapshot.docs;
            final messages = items.map((i) => ChatMessage.fromJson(i.data())).toList();
              return DashChat(
                key: _chatViewKey,
                onSend: (message) => _send(message),
                sendOnEnter: true,
                textInputAction: TextInputAction.send,
                user: user,
                inputDecoration: const InputDecoration.collapsed(hintText: "Add message here..."),
                dateFormat: DateFormat('yyyy-MMM-dd'),
                timeFormat: DateFormat('HH:mm'),
                messages: messages,
                scrollToBottom: true,
                onPressAvatar: (ChatUser user) {
                  print("OnPressAvatar: ${user.name}");
                },
                onLongPressAvatar: (ChatUser user) {
                  print("OnLongPressAvatar: ${user.name}");
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