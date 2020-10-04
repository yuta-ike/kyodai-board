import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/enums/day_of_week.dart';
import 'package:kyodai_board/model/enums/place.dart';

enum EventDateChoice{
  all,
  today, tomorrow, theDayAfterTomorrow,
  // third, fourth, fifth, sixth, seventh,
  thisWeek,
  // afterThisWeek,
  thisMonth,
}

Map<EventDateChoice, String> _map = {
  EventDateChoice.all: '全期間',
  EventDateChoice.today: 'きょう',
  EventDateChoice.tomorrow: 'あした',
  EventDateChoice.theDayAfterTomorrow: 'あさって',
  // EventDateChoice.third: '${DateTime.now().add(const Duration(days: 3)).day}日',
  // EventDateChoice.fourth: '${DateTime.now().add(const Duration(days: 4)).day}日',
  // EventDateChoice.fifth: '${DateTime.now().add(const Duration(days: 5)).day}日',
  // EventDateChoice.sixth: '${DateTime.now().add(const Duration(days: 6)).day}日',
  // EventDateChoice.seventh: '${DateTime.now().add(const Duration(days: 7)).day}日',
  EventDateChoice.thisWeek: '今週',
  // EventDateChoice.afterThisWeek: '来週以降',
  EventDateChoice.thisMonth: '今月',
};

extension StringEventDateChoice on EventDateChoice{
  String get format => _map[this];
}

enum EventTime{
  afterForth, afterFifth, am, lunchtime, pm, alldaylong, others,
}

Map<EventTime, String> _daymap = {
  EventTime.am: '午前',
  EventTime.lunchtime: '昼休み帯',
  EventTime.pm: '午後',
  EventTime.afterForth: '4限後',
  EventTime.afterFifth: '5限後',
  EventTime.alldaylong: '全日',
  EventTime.others: 'その他',
};

extension StringEventTime on EventTime{
  String get format => _daymap[this];
}

class EventQuery extends ChangeNotifier{
  // Constructors
  EventQuery()
    : _dateChoice = EventDateChoice.all
    , _clubTypes = { for(final e in ClubType.values) e: true }
    , _times = { for(final e in EventTime.values) e: true }
    , _places = { for(final e in Place.values) e: true };

  EventQuery._from(
    EventDateChoice dateChoices,
    Map<ClubType, bool> clubTypes,
    Map<EventTime, bool> times,
    Map<Place, bool> places,
  )
    : _dateChoice = dateChoices
    , _clubTypes = clubTypes
    , _times = times
    , _places = places;

  EventQuery copyWith({
    EventDateChoice dateChoices,
    Map<ClubType, bool> clubTypes,
    Map<EventTime, bool> times,
    Map<Place, bool> places,
  }){
    return EventQuery._from(
      _dateChoice ?? dateChoices, clubTypes ?? _clubTypes, times ?? _times, places ?? _places);
  }

  // internal values
  EventDateChoice _dateChoice;
  EventDateChoice get dateChoice => _dateChoice;
  set dateChoice (EventDateChoice value){
    _dateChoice = value;
    notifyListeners();
  }
  final Map<ClubType, bool> _clubTypes;
  Map<ClubType, bool> get clubTypes => _clubTypes;
  final Map<EventTime, bool> _times;
  Map<EventTime, bool> get times => _times;
  final Map<Place, bool> _places;
  Map<Place, bool> get places => _places;
  
  bool isSelected<T>(T item){
    if(T == EventDateChoice){
      return _dateChoice == item;
    }else if(T == ClubType){
      return _clubTypes.cast<T, bool>()[item];
    }else if(T == EventTime){
      return _times.cast<T, bool>()[item];
    }else if(T == Place){
      return _places.cast<T, bool>()[item];
    }
    throw UnimplementedError();
  }
  
  void toggle<T>(T item){
    Map<T, bool> map;
    if(T == ClubType){
      map = _clubTypes.cast<T, bool>();
    }else if(T == EventTime){
      map = _times.cast<T, bool>();
    }else if(T == Place){
      map = _places.cast<T, bool>();
    }else{
      throw UnimplementedError();
    }

    map[item] = !map[item];
    if(T == EventDateChoice){
      map.updateAll((key, value) => key == item);
    }

    notifyListeners();
  }

  List<T> getOnlyTrue<T>(){
    Map<T, bool> map;
    if(T == ClubType){
      map = _clubTypes.cast<T, bool>();
    }else if(T == EventTime){
      map = _times.cast<T, bool>();
    }else if(T == Place){
      map = _places.cast<T, bool>();
    }else{
      throw UnimplementedError();
    }

    return map.entries.map<T>((e) => e.value ? e.key : null).where((e) => e != null).toList();
  }
}