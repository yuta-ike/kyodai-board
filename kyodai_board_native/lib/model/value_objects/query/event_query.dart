import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/enums/day_of_week.dart';

enum EventDateChoice{
  all,
  today, tomorrow, theDayAfterTomorrow, third, fourth,
  // fifth, sixth, seventh,
  thisWeek,
  // afterThisWeek,
  thisMonth,
}

Map<EventDateChoice, String> _map = {
  EventDateChoice.all: '全期間',
  EventDateChoice.today: '今日',
  EventDateChoice.tomorrow: '明日',
  EventDateChoice.theDayAfterTomorrow: '明後日',
  EventDateChoice.third: '${DateTime.now().add(const Duration(days: 3)).day}日',
  EventDateChoice.fourth: '${DateTime.now().add(const Duration(days: 4)).day}日',
  // EventDateChoice.fifth: '${DateTime.now().add(const Duration(days: 5)).day}日',
  // EventDateChoice.sixth: '${DateTime.now().add(const Duration(days: 6)).day}日',
  // EventDateChoice.seventh: '${DateTime.now().add(const Duration(days: 7)).day}日',
  EventDateChoice.thisWeek: '1週間',
  // EventDateChoice.afterThisWeek: '来週以降',
  EventDateChoice.thisMonth: '1か月',
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
    , _clubTypes = { for(final e in ClubType.values) e: false }
        ..update(ClubType.values[0], (_) => true)
    , _daysOfWeek = { for(final e in DayOfWeek.values) e: true }
    , _times = { for(final e in EventTime.values) e: true };

  EventQuery._from(
    EventDateChoice dateChoices,
    Map<ClubType, bool> clubTypes,
    Map<DayOfWeek, bool> daysOfWeek,
    Map<EventTime, bool> times,
  )
    : _dateChoice = dateChoices
    , _clubTypes = clubTypes
    , _daysOfWeek = daysOfWeek
    , _times = times;

  EventQuery copyWith({
    EventDateChoice dateChoices,
    Map<ClubType, bool> clubTypes,
    Map<DayOfWeek, bool> daysOfWeek,
    Map<EventTime, bool> times,
  }){
    return EventQuery._from(
      _dateChoice ?? dateChoices, clubTypes ?? _clubTypes, daysOfWeek ?? _daysOfWeek, times ?? _times);
  }

  // internal values
  EventDateChoice _dateChoice;
  EventDateChoice get dateChoice => _dateChoice;
  set dateChoice (EventDateChoice value){
    _dateChoice = value;
    notifyListeners();
  }
  final Map<ClubType, bool> _clubTypes;
  final Map<DayOfWeek, bool> _daysOfWeek;
  final Map<EventTime, bool> _times;
  Map<ClubType, bool> get clubTypes => _clubTypes;
  Map<DayOfWeek, bool> get daysOfWeek => _daysOfWeek;
  Map<EventTime, bool> get times => _times;
  
  bool isSelected<T>(T item){
    if(T == EventDateChoice){
      return _dateChoice == item;
    }else if(T == ClubType){
      return _clubTypes.cast<T, bool>()[item];
    }else if(T == DayOfWeek){
      return _daysOfWeek.cast<T, bool>()[item];
    }else if(T == EventTime){
      return _times.cast<T, bool>()[item];
    }
    throw UnimplementedError();
  }
  
  void toggle<T>(T item){
    Map<T, bool> map;
    if(T == ClubType){
      map = _clubTypes.cast<T, bool>();
    }else if(T == DayOfWeek){
      map = _daysOfWeek.cast<T, bool>();
    }else if(T == EventTime){
      map = _times.cast<T, bool>();
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
    }else if(T == DayOfWeek){
      map = _daysOfWeek.cast<T, bool>();
    }else if(T == EventTime){
      map = _times.cast<T, bool>();
    }else{
      throw UnimplementedError();
    }

    return map.entries.map<T>((e) => e.value ? e.key : null).where((e) => e != null).toList();
  }
}