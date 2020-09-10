enum Campus{
  yoshidaMain, yoshidaNorth, yoshidaSouth, yoshidaWest, yoshidaOthers, uji, katsura, others,
}

const Map<Campus, String> _map = {
  Campus.yoshidaMain: '本部キャンパス',
  Campus.yoshidaNorth: '農学部キャンパス',
  Campus.yoshidaSouth: '吉田南キャンパス',
  Campus.yoshidaWest: '西部構内',
  Campus.yoshidaOthers: 'その他の吉田キャンパス',
  Campus.uji: '宇治キャンパス',
  Campus.katsura: '桂キャンパス',
  Campus.others: 'その他',
};

extension CampusString on Campus{
  String get format => _map[this];
  String get keyString => toString().split('.')[1];
}

extension ConvertableMap on Map<String, dynamic>{
  Campus getCampus(String key, { Campus or }){
    final dynamic value = this[key];
    if(value is! String){
      return or;
    }
    switch(value as String){
      case 'yoshidaMain': return Campus.yoshidaMain;
      case 'yoshidaNorth': return Campus.yoshidaNorth;
      case 'yoshidaSouth': return Campus.yoshidaSouth;
      case 'yoshidaWest': return Campus.yoshidaWest;
      case 'yoshidaOthers': return Campus.yoshidaOthers;
      case 'uji': return Campus.uji;
      case 'katsura': return Campus.katsura;
      default: return or;
    }
  }
}