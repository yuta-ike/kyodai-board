enum ClubType{
  sportsUnion, sports, culture, music, tech, study, business, job, none, others
}

const Map<ClubType, String> _map = {
  ClubType.sportsUnion: '体育会',
  ClubType.sports: '運動',
  ClubType.culture: '文化',
  ClubType.music: '音楽',
  ClubType.tech: '技術',
  ClubType.study: '研究',
  ClubType.business: 'ビジネス',
  ClubType.job: 'アルバイト・インターン',
  ClubType.none: '未選択',
  ClubType.others: 'その他',
};

extension ClubTypeString on ClubType{
  String get format => _map[this];
  String get keyString => toString().split('.')[1];
}


extension ConvertableMap on Map<String, dynamic>{
  ClubType getClubType(String key, { ClubType or }){
    final dynamic value = this[key];
    if(value is! String){
      return or;
    }
    switch(value as String){
      case 'sportsUnion': return ClubType.sportsUnion;
      case 'sports': return ClubType.sports;
      case 'culture': return ClubType.sportsUnion;
      case 'music': return ClubType.music;
      case 'tech': return ClubType.tech;
      case 'study': return ClubType.study;
      case 'business': return ClubType.business;
      case 'job': return ClubType.job;
      case 'none': return ClubType.none;
      case 'others': return ClubType.others;
      default: return or;
    }
  }
}