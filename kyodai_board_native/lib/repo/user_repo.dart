import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/club_bookmark.dart';
import 'package:kyodai_board/model/event_bookmark.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

User getCurrentUser(){
  return auth.currentUser;
}

StreamProvider<User> userProvider = StreamProvider<User>((ref) {
  return auth.authStateChanges();
});

// bookmark
Future<void> bookmarkClub(String clubId) async {
  final uid = auth.currentUser.uid;
  await fsinstance.collection('users').doc(uid).collection('bookmarkClubs').add(<String, dynamic>{
    'createdAt': FieldValue.serverTimestamp(),
    'clubId': clubId,
    'ref': fsinstance.collection('clubs').doc(clubId),
  });
}

Future<void> unbookmarkClub(ClubBookmark bookmark) async {
  final uid = auth.currentUser.uid;
  await fsinstance.collection('users').doc(uid).collection('bookmarkClubs').doc(bookmark.id).delete();
}

final bookmarkClubProvider = StreamProvider<List<ClubBookmark>>((ref) async* {
  final uid = auth.currentUser.uid;
  var bookmarks = <ClubBookmark>[];
  yield [];

  await for(final snapshot in fsinstance.collection('users').doc(uid).collection('bookmarkClubs').orderBy('createdAt').snapshots()){
    var hasChange = false;
    snapshot.docChanges.forEach((docChange){
      if(docChange.type == DocumentChangeType.added){
        bookmarks = [...bookmarks, (ClubBookmark.fromMap(docChange.doc.id, docChange.doc.data()))];
        hasChange = true;
      }else if(docChange.type == DocumentChangeType.removed){
        bookmarks = bookmarks.where((bookmark) => bookmark.id != docChange.doc.id).toList();
        hasChange = true;
      }
    });
    if(hasChange){
      yield bookmarks;
    }
  }
});

Future<void> bookmarkEvent(String eventId, String clubId) async {
  final uid = auth.currentUser.uid;
  await fsinstance.collection('users').doc(uid).collection('bookmarkEvents').add(<String, dynamic>{
    'createdAt': FieldValue.serverTimestamp(),
    'clubId': clubId,
    'eventId': eventId,
    'ref': fsinstance.collection('clubs').doc(eventId).collection('events').doc(eventId),
  });
}

Future<void> unbookmarkEvent(EventBookmark bookmark) async {
  final uid = auth.currentUser.uid;
  await fsinstance.collection('users').doc(uid).collection('bookmarkEvents').doc(bookmark.id).delete();
}

final bookmarkEventProvider = StreamProvider<List<EventBookmark>>((ref) async* {
  final uid = auth.currentUser.uid;
  var bookmarks = <EventBookmark>[];

  yield [];

  await for(final snapshot in fsinstance.collection('users').doc(uid).collection('bookmarkEvents').orderBy('createdAt').snapshots()){
    var hasChange = false;
    snapshot.docChanges.forEach((docChange){
      if(docChange.type == DocumentChangeType.added){
        bookmarks.add(EventBookmark.fromMap(docChange.doc.id, docChange.doc.data()));
        hasChange = true;
      }else if(docChange.type == DocumentChangeType.removed){
        bookmarks = bookmarks.where((bookmark) => bookmark.id != docChange.doc.id).toList();
        hasChange = true;
      }
    });
    if(hasChange){
      yield bookmarks;
    }
  }
});
