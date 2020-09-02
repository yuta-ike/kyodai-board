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

extension StringClubTabs on ClubTabs{
  String get format => _map[this];
}
