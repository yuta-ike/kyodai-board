enum DayOfWeek{
  sunday, monday, tuesday, wednesday, thursday, friday, saturday,
}

Map<DayOfWeek, String> _map = {
  DayOfWeek.sunday: '日曜',
  DayOfWeek.monday: '月曜',
  DayOfWeek.tuesday: '火曜',
  DayOfWeek.wednesday: '水曜',
  DayOfWeek.thursday: '木曜',
  DayOfWeek.friday: '金曜',
  DayOfWeek.saturday: '土曜',
};

Map<DayOfWeek, int> _intmap = {
  DayOfWeek.sunday: 0,
  DayOfWeek.monday: 1,
  DayOfWeek.tuesday: 2,
  DayOfWeek.wednesday: 3,
  DayOfWeek.thursday: 4,
  DayOfWeek.friday: 5,
  DayOfWeek.saturday: 6,
};

final _frommap = Map<String, DayOfWeek>.fromEntries(DayOfWeek.values.map((e) => MapEntry(e.toString().split('.')[1], e)));

extension StringDayOfWeek on DayOfWeek{
  String get format => _map[this];
}

extension SortIterable<DayOfWeek> on List<DayOfWeek>{
  List<DayOfWeek> sortInDayOrder({ DayOfWeek start }){
    final offset = _intmap[start];
    return [...this]
      ..sort((a, b){
        final aid = (_intmap[a] - offset) % 7;
        final bid = (_intmap[b] - offset) % 7;
        return aid > bid ? 1 : aid == bid ? 0 : -1;
      });
  }
}

extension ConvertableMap on Map<String, dynamic>{
  List<DayOfWeek> getDayOfWeeks(String key, { List<DayOfWeek> or }){
    final dynamic value = this[key];
    try{
      if(value is List<dynamic>){
        return value.map((dynamic e) => _frommap[e as String]).toList();
      }else{
        return or;
      }
    }catch(e){
      return or;
    }
  }
}