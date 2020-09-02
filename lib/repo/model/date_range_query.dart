import 'package:kyodai_board/model/value_objects/event_query/event_query.dart';

DateTime _getDate(EventDateChoice dateChoice){
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  if(dateChoice == EventDateChoice.today){
    return today;
  }else if(dateChoice == EventDateChoice.tomorrow){
    return today.add(const Duration(days: 1));
  }else if(dateChoice == EventDateChoice.theDayAfterTomorrow){
    return today.add(const Duration(days: 2));
  }else if(dateChoice == EventDateChoice.third){
    return today.add(const Duration(days: 3));
  }else if(dateChoice == EventDateChoice.fourth){
    return today.add(const Duration(days: 4));
  }else if(dateChoice == EventDateChoice.thisWeek){
    return today;
  }else if(dateChoice == EventDateChoice.thisMonth){
    return today;
  }
  throw UnimplementedError();
}

class DatePeriod{
  const DatePeriod(this.start, this.end);
  final DateTime start;
  final DateTime end;
}

extension RangeEventDateChoice on Map<EventDateChoice, bool>{
  List<DatePeriod> getDatePeriods(){
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if(this[EventDateChoice.all]){
      return null;
    }

    if(this[EventDateChoice.thisMonth]){
      return [DatePeriod(now, today.add(const Duration(days: 31)))];
    }

    if(this[EventDateChoice.thisWeek]){
      return [DatePeriod(now, today.add(const Duration(days: 7)))];
    }

    final result = <DatePeriod>[];

    DateTime start;
    for(final dateChoice in EventDateChoice.values){
      if(this[dateChoice] && start == null){
        start = _getDate(dateChoice);
        continue;
      }
      if(start != null){
        if(!this[dateChoice]){
          final end = _getDate(dateChoice);
          result.add(DatePeriod(start, end));
          start = null;
        }
      }
    }
    return result;
  }
}