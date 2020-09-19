import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/util/freq.dart';
import 'package:kyodai_board/model/value_objects/query/club_query.dart';
import 'package:kyodai_board/repo/firebase_repo.dart';
import 'package:state_notifier/state_notifier.dart';

final clubSearchProvider = FutureProvider.autoDispose.family<List<Club>, ClubQuery>((ref, clubQuery) async {
  final firestore = ref.read(firestoreProvider);
  Query query = firestore.state.collection('clubs')/*.orderBy('updatedAt')*/;

  if(clubQuery.clubTypes.map((e) => e.keyString).toList().isEmpty){
    return [];
  }

  query = query.where('profile.clubType', whereIn: clubQuery.clubTypes.map((e) => e.keyString).toList());

  final snapshots = await query.get();
  if(snapshots.size == 0){
    return [];
  }
  
  var clubs = snapshots.docs.map((snapshot) => Club.fromMap(snapshot.id, snapshot.data()));


  clubs = clubs.where((club){
    return clubQuery.daysOfWeek.toSet().containsAll(club.profile.daysOfWeek);
  });

  final memberCountStart = memberCountChoices[clubQuery.memberCount.start.floor()];
  final memberCountEnd = memberCountChoices[clubQuery.memberCount.end.floor()];
  if(memberCountStart != null){
    clubs = clubs.where((club) => club.profile.memberCount >= memberCountStart);
  }
  if(memberCountEnd != null){
    clubs = clubs.where((club) => club.profile.memberCount <= memberCountEnd);
  }

  if(clubQuery.genderRatio != null){
    if(clubQuery.genderRatio == GenderRatioChoice.male){
      clubs = clubs.where((club) => club.profile.genderRatio >= 0.7);
    }else if(clubQuery.genderRatio == GenderRatioChoice.female){
      clubs = clubs.where((club) => club.profile.genderRatio <= 0.3);
    }else{
      clubs = clubs.where((club) => 0.3 <= club.profile.genderRatio && club.profile.genderRatio <= 0.7);
    }
  }

  if(clubQuery.campus != null){
    if(clubQuery.campus == CampusChoice.yoshida){
      clubs = clubs.where((club) => <Campus>[Campus.yoshidaMain, Campus.yoshidaNorth, Campus.yoshidaOthers, Campus.yoshidaSouth, Campus.yoshidaWest].contains(club.profile.campus));
    }else if(clubQuery.campus == CampusChoice.uji){
      clubs = clubs.where((club) => club.profile.campus == Campus.uji);
    }else if(clubQuery.campus == CampusChoice.katsura){
      clubs = clubs.where((club) => club.profile.campus == Campus.katsura);
    }else if(clubQuery.campus == CampusChoice.others){
      clubs = clubs.where((club) => club.profile.campus == Campus.others);
    }
  }

  if(clubQuery.isOfficial == true){
    clubs = clubs.where((club) => club.profile.isOfficial == true);
  }

  if(clubQuery.isIntercollege == false){
    clubs = clubs.where((club) => club.profile.isIntercollege == false);
  }

  if(!(clubQuery.freq.start.floor() == 0 && clubQuery.freq.end.floor() == FreqChoice.values.length - 1)){
    final freqStart = freqChoices[clubQuery.freq.start.floor()];
    final freqEnd = freqChoices[clubQuery.freq.end.floor()];
    if(clubQuery.freq.start.floor() == 0){
      final choices = Freq.values.sublist(0, Freq.values.indexOf(freqEnd) + 1);
      clubs = clubs.where((club) => choices.contains(club.profile.freq));
    }else if(clubQuery.freq.end.floor() == FreqChoice.values.length - 1){
      final choices = Freq.values.sublist(Freq.values.indexOf(freqStart), Freq.values.length);
      clubs = clubs.where((club) => choices.contains(club.profile.freq));
    }else{
      final choices = freqChoices.sublist(clubQuery.freq.start.floor(), clubQuery.freq.end.floor());
      clubs = clubs.where((club) => choices.contains(club.profile.freq));
    }
  }

  return clubs.toList();
});

class ClubListRepository extends StateNotifier<List<Club>>{
  ClubListRepository(): super([]);

  Future<void> fetch() async {
    final snapshots = await fsinstance.collection('clubs').get();
    state = snapshots.docs.map((snapshot) => Club.fromMap(snapshot.id, snapshot.data())).toList();
  }

  Future<void> filter(ClubType type) async {
    if(state == null){
      await fetch();
    }
    state = state.where((club) => club.profile.clubType == type).toList();
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
  final future = useState(getClub(clubId));
  return useFuture<Club>(future.value);
}
// async function
Future<Club> getClub(String clubId) async {
  if(clubId == null){
    return null;
  }
  final snapshot = await fsinstance.collection('clubs').doc(clubId).get();
  return Club.fromMap(snapshot.id, snapshot.data());
}