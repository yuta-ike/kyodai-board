import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:kyodai_board/model/board.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/enums/place.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/model/value_objects/query/event_query.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';
import 'package:kyodai_board/repo/model/date_range_query.dart';
import 'package:state_notifier/state_notifier.dart';

class ScheduleListRepository extends StateNotifier<List<Schedule>>{
  ScheduleListRepository(): super([]);

  int fetchCount = 0;

  Future<void> fetch() async {
    final snapshots = await fsinstance.collectionGroup('schedules').orderBy('startAt').get();
    state = snapshots.docs.map((snapshot) => Schedule.fromMap(snapshot.id, snapshot.data())).toList();
    fetchCount += 1;
  }

  Future<void> fetchIfEmpty() async {
    if(fetchCount == 0){
      await fetch();
    }
  }
}

final scheduleProvider = StateNotifierProvider(
  (ref) => ScheduleListRepository()
);


class ScheduleSearchListRepository extends StateNotifier<List<Schedule>>{
  ScheduleSearchListRepository(): super([]);

  Future<void> fetch(EventQuery eventQuery) async {
    var query = fsinstance.collectionGroup('schedules').orderBy('startAt');

    if(eventQuery.getOnlyTrue<ClubType>().isEmpty){
      state = [];
      return;
    }else{
      query = query.where('club.clubType', whereIn: eventQuery.getOnlyTrue<ClubType>().map((e) => e.keyString).toList());
    }

    final periods = eventQuery.dateChoice.getDatePeriod();
    if(periods != null){
      query = query
        .where('startAt', isGreaterThan: periods.start)
        .where('startAt', isLessThan: periods.end);
    }

    final places = eventQuery.getOnlyTrue<Place>();
    if(places.isEmpty){
      state = [];
      return;
    }else if(places.length == 1 || places.length == Place.values.length){
      if(places.length == 1){
        query = query.where('meetingPlace', isEqualTo: places.first.keyString);
      }

      // FETCH
      final snapshots = await query.get();
      state = snapshots.docs.map((snapshot) => Schedule.fromMap(snapshot.id, snapshot.data())).toList();
    }else{
      final snapshotsList = await Future.wait(
        places.map((e) => query.where('meetingPlace', isEqualTo: e.keyString).get())
      );

      // FETCH
      state = snapshotsList
          .map((e) => e.docs.map((snapshot) => Schedule.fromMap(snapshot.id, snapshot.data())).toList())
          .reduce((value, element) => [...value, ...element])
          ..sort((a, b) => a.startAt.compareTo(b.startAt));
    }

  }
}

final scheduleSearchListProvider = StateNotifierProvider(
  (ref) => ScheduleSearchListRepository()
);

// final eventScheduleProvider = FutureProvider.autoDispose.family<List<Schedule>, EventQuery>((ref, eventQuery) async {
//     final firestore = ref.read(firestoreProvider);
//     var query = firestore.state.collectionGroup('schedules').orderBy('startAt');

//     if(eventQuery.getOnlyTrue<ClubType>().isNotEmpty){
//       query = query.where('clubType', whereIn: eventQuery.getOnlyTrue<ClubType>().map((e) => e.keyString).toList());
//     }

//     final periods = eventQuery.dateChoice.getDatePeriod();
//     if(periods != null){
//       query = query
//         .where('startAt', isGreaterThan: periods.start)
//         .where('startAt', isLessThan: periods.end);
//     }

//     if(eventQuery.getOnlyTrue<DayOfWeek>().isNotEmpty){
//       // dayOfWeeksフィールド追加待ち
//       // query = query.where('type', whereIn: eventQuery.getOnlyTrue<ClubType>().map((e) => e.keyString).toList());
//     }

//     final snapshots = await query.get();
//     return snapshots.docs.map((snapshot) => Schedule.fromMap(snapshot.id, snapshot.data())).toList();
// });

// イベント詳細を取得する
class EventDetailRepository extends StateNotifier<Event>{
  EventDetailRepository(Event event) : super(event);
  
  Future<void> forceFetch(Schedule schedule) async {
    //TODO: clubIdをEventに、createdAtを全レコードに追加する
    final eventSnapshot = await schedule.eventRef.get();
    final schedulesSnapshot = await schedule.eventRef.collection('schedules').orderBy('startAt').get();
    final schedules = schedulesSnapshot.docs.map((snapshot) => Schedule.fromMap(snapshot.id, snapshot.data())).toList();
    state = Event.fromMap(eventSnapshot.id, eventSnapshot.data(), schedules);
  }

  // TODO: sheduleだけ更新するように変更したい
  Future<void> forceFetchOnlySchedules() async {
    final eventSnapshot = await fsinstance.collection('clubs').doc(state.clubId).collection('events').doc(state.id).get();
    final schedulesSnapshot = await fsinstance.collection('clubs').doc(state.clubId).collection('events').doc(state.id).collection('schedules').orderBy('startAt').get();
    final schedules = schedulesSnapshot.docs.map((snapshot) => Schedule.fromMap(snapshot.id, snapshot.data())).toList();
    state = Event.fromMap(eventSnapshot.id, eventSnapshot.data(), schedules);
  }

  Future<void> fetchIfNeed(Schedule schedule) async {
    if(state == null){
      return forceFetch(schedule);
    }else if(state.schedules == null){
      return forceFetchOnlySchedules();
    }
  }
}

final eventDetailProvider = StateNotifierProvider.autoDispose.family(
  (ref, Event event) => EventDetailRepository(event)
);

// クラブのイベント一覧を取得する
class EventListRepository extends StateNotifier<List<Event>>{
  EventListRepository(): super([]);

  Future<void> forceFetch(String clubId) async {
    final snapshots = await fsinstance.collection('clubs').doc(clubId).collection('events').orderBy('updatedAt').get();
    state = snapshots.docs.map((snapshot) => Event.fromMap(snapshot.id, snapshot.data(), null)).toList();
  }

  Future<void> fetchIfEmpty(String clubId) async {
    if(state.isEmpty){
      return forceFetch(clubId);
    }
  }
}

final eventByClubProvider = StateNotifierProvider.autoDispose(
  (ref) => EventListRepository()
);
