import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';

FutureProvider<List<Club>> clubProvider = FutureProvider((ref) async {
  final firestore = ref.read(firestoreProvider);
  final snapshots = await firestore.state.collection('clubs').get();
  return snapshots.docs.map((snapshot) => Club.fromMap(snapshot.data())).toList();
});