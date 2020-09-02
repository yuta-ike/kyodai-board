import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

StreamProvider<QuerySnapshot> chatProvider = StreamProvider((ref) {
  final firestore = ref.read(firestoreProvider);
  return firestore.state.collection('chat').snapshots();
});