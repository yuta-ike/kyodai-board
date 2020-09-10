import 'package:kyodai_board/model/enums/club_type.dart';

enum ClubTabs{
  home, sportsUnion, sports, culture, music, study, business, job, others
}

const Map<ClubTabs, String> _map = {
  ClubTabs.home: 'Home',
  ClubTabs.sportsUnion: '体育会',
  ClubTabs.sports: '運動',
  ClubTabs.music: '音楽',
  ClubTabs.culture: '文化',
  ClubTabs.study: '研究',
  ClubTabs.business: 'ビジネス',
  ClubTabs.job: 'アルバイト\nインターン',
  ClubTabs.others: 'その他',
};

const Map<ClubTabs, ClubType> _clubTypeMap = {
  ClubTabs.home: null,
  ClubTabs.sportsUnion: ClubType.sportsUnion,
  ClubTabs.sports: ClubType.sports,
  ClubTabs.music: ClubType.music,
  ClubTabs.culture: ClubType.culture,
  ClubTabs.study: ClubType.study,
  ClubTabs.business: ClubType.business,
  ClubTabs.job: ClubType.job,
  ClubTabs.others: ClubType.others,
};

extension StringClubTabs on ClubTabs{
  String get format => _map[this];

  ClubType get clubType => _clubTypeMap[this];
}
