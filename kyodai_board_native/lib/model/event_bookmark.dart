import 'package:kyodai_board/utils/dynamic_cast_map.dart';

class EventBookmark{
  const EventBookmark({
    this.id,
    this.eventId,
    this.clubId,
  });

  EventBookmark.fromMap(this.id, Map<String, dynamic> map)
    : eventId = map.getString('eventId')
    , clubId = map.getString('clubId');

  final String id, eventId, clubId;
}

extension ExClubBookmark on List<EventBookmark>{
  bool containsClubAndEventId(String eventId, String clubId){
    return any((bookmark) => bookmark.eventId == eventId && bookmark.clubId == clubId);
  }

  EventBookmark getWithEventId(String eventId){
    return firstWhere((bookmark) => bookmark.eventId == eventId);
  }
}