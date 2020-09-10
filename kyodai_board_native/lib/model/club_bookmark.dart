import 'package:kyodai_board/utils/dynamic_cast_map.dart';

class ClubBookmark{
  const ClubBookmark({
    this.clubId,
    this.id,
  });

  ClubBookmark.fromMap(this.id, Map<String, dynamic> map)
    : clubId = map.getString('clubId');

  final String clubId, id;
}

extension ExClubBookmark on List<ClubBookmark>{
  bool containsClubId(String clubId){
    return any((bookmark) => bookmark.clubId == clubId);
  }

  ClubBookmark getWithClubId(String clubId){
    return firstWhere((bookmark) => bookmark.clubId == clubId);
  }
}