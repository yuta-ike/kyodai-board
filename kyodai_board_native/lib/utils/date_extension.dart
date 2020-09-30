const List<String> _map = ['月', '火', '水', '木', '金', '土', '日'];

extension FormatDateTime on DateTime{
  String dateFormat({ String separator = ' ', bool excludeWeekday = false }){
    return '${month}月${day}日${separator}${excludeWeekday ? '' : _map[weekday-1]}';
  }
  String timeFormat(){
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  bool isSameDay(DateTime other){
    return year == other.year && month == other.month && day == other.day;
  }

  String approximatelyDateFormat(){
    final today = DateTime.now();
    if(year == today.year && month == today.month){
      if(day == today.day){
        return '今日';
      }else if(day == today.day + 1){
        return '明日';
      }
    }
    return dateFormat();
  }

  String approximatelyFormat(){
    // TODO: 時間も実装
    final today = DateTime.now();
    if(year == today.year && month == today.month){
      if(day == today.day){
        return '今日';
      }else if(day == today.day + 1){
        return '明日';
      }
    }
    return dateFormat();
  }
}