import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/model/chat_room.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

// CREATE: 新しいチャットルームの作成
Future<String> createChatroom(String clubId, { List<ChatMessage> initialMessages }) async {
  final uid = auth.currentUser.uid;
  final docRef = await fsinstance.collection('chats').add(<String, dynamic>{
    'lastMessageId': null,
    'lastClubReadId': null,
    'lastStudentReadId': null,
    'studentId': uid,
    'clubId': clubId,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });
  if(initialMessages != null){
    for(final message in initialMessages){
      await docRef.collection('messages').add(message.toJson());
    }
  }
  return docRef.id;
}

// POST: メッセージの投稿
Future<void> sendMessage(String chatId, ChatMessage message) async {
  await fsinstance.collection('chats').doc(chatId).collection('messages').add(
    message.toJson()
  );
}

// GET: チャットルームのUserを取得
ChatUser getChatUser() => ChatUser(
  uid: auth.currentUser.uid,
);

// GET: チャットルーム一覧の取得
// TODO: 並べ替え実装
final chatRoomProvider = StreamProvider<List<ChatRoom>>((ref) async* {
  final uid = auth.currentUser.uid;
  var chatrooms = <ChatRoom>[];

  yield [];

  final snapshots = fsinstance.collection('chats').where('studentId', isEqualTo: uid).snapshots();

  await for(final snapshot in snapshots ){
    var hasChange = false;
    final futures = <Future<void>>[];
    snapshot.docChanges.forEach((docChange){
      if(docChange.type == DocumentChangeType.added){
        futures.add(
          fsinstance.collection('clubs').doc(docChange.doc.data()['clubId'] as String).get().then((snapshot){
            final club = Club.fromMap(snapshot.id, snapshot.data());
            final chatroom = ChatRoom.fromMap(docChange.doc.id, docChange.doc.data(), club: club);
            chatrooms.add(chatroom);
          })
        );
        hasChange = true;
      }else if(docChange.type == DocumentChangeType.removed){
        chatrooms = chatrooms.where((chatroom) => chatroom.id != docChange.doc.id).toList();
        hasChange = true;
      }else if(docChange.type == DocumentChangeType.modified){
        chatrooms = chatrooms.map((chatroom) => chatroom.id == docChange.doc.id ? ChatRoom.fromMap(docChange.doc.id, docChange.doc.data(), club: chatroom.club) : chatroom).toList();
        hasChange = true;
      }
    });
    await Future.wait(futures);
    if(hasChange){
      yield chatrooms;
    }
  }
});

// GET: チャットルームの取得
Future<ChatRoom> getChatroom(String chatId) async {
  if(chatId == null){
    return null;
  }
  
  final chatSnapshot = await fsinstance.collection('chats').doc(chatId).get();
  final clubSnapshot = await fsinstance.collection('clubs').doc(chatSnapshot.data()['clubId'] as String).get();
  final club = Club.fromMap(clubSnapshot.id, clubSnapshot.data());
  return ChatRoom.fromMap(chatSnapshot.id, chatSnapshot.data(), club: club);
}

// GET: チャットの取得
final chatProvider = StreamProvider.family<List<ChatMessage>, String>((ref, chatId) async* {
  final messages = <ChatMessage>[];
  var hasChange = false;
  yield messages;
  
  final snapshots = fsinstance.collection('chats').doc(chatId).collection('messages').snapshots();
  final chatroom = await getChatroom(chatId);

  await for(final snapshot in snapshots){
    snapshot.docChanges.forEach((docChange){
      if(docChange.type == DocumentChangeType.added){
        final chatMessage = ChatMessage.fromJson(docChange.doc.data())
            ..user.name = chatroom.club.profile.name
            ..user.avatar = chatroom.club.profile.iconImageUrl;

        messages.add(chatMessage);
        hasChange = true;
      }
    });
    if(hasChange){
      yield messages;
    }
  }
});