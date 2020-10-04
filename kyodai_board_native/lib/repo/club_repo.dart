import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/value_objects/query/club_query.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';
import 'package:state_notifier/state_notifier.dart';

final clubSearchProvider = FutureProvider.autoDispose.family<List<Club>, ClubQuery>((ref, clubQuery) async {
  final firestore = ref.read(firestoreProvider);
  var query = firestore.state.collection('clubs').orderBy('updatedAt');

  // ClubType
  if(clubQuery.clubTypes.map((e) => e.keyString).toList().isEmpty){
    return [];
  }
  query = query.where('clubType', whereIn: clubQuery.clubTypes.map((e) => e.keyString).toList());

  final snapshots = await query.get();
  if(snapshots.size == 0){
    return [];
  }
  
  var clubs = snapshots.docs.map((snapshot) => Club.fromMap(snapshot.id, snapshot.data()));

  // daysOfWeek
  clubs = clubs.where((club){
    return clubQuery.daysOfWeek.toSet().containsAll(club.daysOfWeek);
  });

  // memberCount
  final memberCountStart = memberCountChoices[clubQuery.memberCount.start.floor()];
  final memberCountEnd = memberCountChoices[clubQuery.memberCount.end.floor()];
  if(memberCountStart != null){
    clubs = clubs.where((club) => club.memberCount >= memberCountStart);
  }
  if(memberCountEnd != null){
    clubs = clubs.where((club) => club.memberCount <= memberCountEnd);
  }

  // genderRatio
  if(clubQuery.genderRatio != null){
    if(clubQuery.genderRatio == GenderRatioChoice.male){
      clubs = clubs.where((club) => club.genderRatio >= 0.7);
    }else if(clubQuery.genderRatio == GenderRatioChoice.female){
      clubs = clubs.where((club) => club.genderRatio <= 0.3);
    }else{
      clubs = clubs.where((club) => 0.3 <= club.genderRatio && club.genderRatio <= 0.7);
    }
  }

  // campus
  if(clubQuery.campus != null){
    if(clubQuery.campus == CampusChoice.yoshida){
      clubs = clubs.where((club) => club.campus.contains(Campus.yoshida));
    }else if(clubQuery.campus == CampusChoice.uji){
      clubs = clubs.where((club) => club.campus.contains(Campus.uji));
    }else if(clubQuery.campus == CampusChoice.katsura){
      clubs = clubs.where((club) => club.campus.contains(Campus.katsura));
    }else if(clubQuery.campus == CampusChoice.others){
      clubs = clubs.where((club) => club.campus.contains(Campus.others));
    }
  }

  // isOfficial
  if(clubQuery.isOfficial == true){
    clubs = clubs.where((club) => club.isOfficial == true);
  }

  // isIntercollege
  if(clubQuery.isIntercollege == false){
    clubs = clubs.where((club) => club.isIntercollege == false);
  }

  // if(!(clubQuery.freq.start.floor() == 0 && clubQuery.freq.end.floor() == FreqChoice.values.length - 1)){
  //   final freqStart = freqChoices[clubQuery.freq.start.floor()];
  //   final freqEnd = freqChoices[clubQuery.freq.end.floor()];
  //   if(clubQuery.freq.start.floor() == 0){
  //     final choices = Freq.values.sublist(0, Freq.values.indexOf(freqEnd) + 1);
  //     clubs = clubs.where((club) => choices.contains(club.freq));
  //   }else if(clubQuery.freq.end.floor() == FreqChoice.values.length - 1){
  //     final choices = Freq.values.sublist(Freq.values.indexOf(freqStart), Freq.values.length);
  //     clubs = clubs.where((club) => choices.contains(club.freq));
  //   }else{
  //     final choices = freqChoices.sublist(clubQuery.freq.start.floor(), clubQuery.freq.end.floor());
  //     clubs = clubs.where((club) => choices.contains(club.freq));
  //   }
  // }
  print(clubs);

  return clubs.toList();
});

class ClubListRepository extends StateNotifier<List<Club>>{
  ClubListRepository(): super([]);

  int fetchCount = 0;

  Future<void> fetch() async {
    print("fetch");
    final snapshots = await fsinstance.collection('clubs').get();
    state = snapshots.docs.map((snapshot) => Club.fromMap(snapshot.id, snapshot.data())).toList();
    fetchCount += 1;
  }

  Future<void> fetchIfEmpty() async {
    if(fetchCount == 0){
      await fetch();
    }
  }

  Future<void> filter(ClubType type) async {
    if(state == null){
      await fetch();
    }
    state = state.where((club) => club.clubType == type).toList();
  }
}

final clubListProvider = StateNotifierProvider(
  (ref) => ClubListRepository()
);

class ClubRepository extends StateNotifier<Club>{
  ClubRepository({ Club club }): super(club);

  Future<void> forceFetch(String clubId) async {
    final snapshot = await fsinstance.collection('clubs').doc(clubId).get();
    state = Club.fromMap(snapshot.id, snapshot.data());
  }

  Future<void> fetchIfNull(String clubId) async {
    print(state);
    if(state == null){
      return forceFetch(clubId);
    }
  }
}

final clubProvider = StateNotifierProvider.autoDispose.family(
  (ref, Club club) => ClubRepository(club: club)
);


// GET: Clubを取得
// hooks
AsyncSnapshot<Club> useClub(String clubId){
  // final future = useState(getClub(clubId));
  return useFuture<Club>(useMemoized(() => getClub(clubId), []));
}
// async function
Future<Club> getClub(String clubId) async {
  if(clubId == null){
    return null;
  }
  final snapshot = await fsinstance.collection('clubs').doc(clubId).get();
  return Club.fromMap(snapshot.id, snapshot.data());
}