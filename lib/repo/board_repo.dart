import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/board.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/model/value_objects/event_query/event_query.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';
import 'package:kyodai_board/repo/model/date_range_query.dart';

FutureProvider<List<Board>> boardProvider = FutureProvider((ref) async {
  final firestore = ref.read(firestoreProvider);
  final snapshots = await firestore.state.collection('boards').get();
  return snapshots.docs.map((snapshot) => Board.fromMap(snapshot.data())).toList();
});

FutureProvider<List<Event>> eventProvider = FutureProvider((ref) async {
  final firestore = ref.read(firestoreProvider);
  final snapshots = await firestore.state.collection('events').get();
  return snapshots.docs.map((snapshot) => Event.fromMap(snapshot.data())).toList();
});

// FIXME: familyを使ってリファクタ
FutureProvider<List<Event>> eventSearchProvider(EventQuery eventQuery){
  return FutureProvider((ref) async {
    final firestore = ref.read(firestoreProvider);
    var query = firestore.state.collection('events').orderBy('startAt', descending: true);

    if(eventQuery.getOnlyTrue<ClubType>().isNotEmpty){
      query = query.where('type', whereIn: eventQuery.getOnlyTrue<ClubType>().map((e) => e.keyString).toList());
    }

    final periods = eventQuery.dataChoices.getDatePeriods();
    // FIXME: 最初の選択肢しか考慮していない
    if(periods != null && periods.isNotEmpty){
      query = query
        .where('startAt', isGreaterThan: periods[0].start)
        .where('startAt', isLessThan: periods[0].end);
    }

    final snapshots = await query.get();
    return snapshots.docs.map((snapshot) => Event.fromMap(snapshot.data())).toList();
  });
}
