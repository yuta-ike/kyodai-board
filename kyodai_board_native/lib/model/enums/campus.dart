enum Campus{
  yoshida, uji, katsura, others,
}

const Map<Campus, String> _map = {
  Campus.yoshida: '吉田キャンパス',
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
      case 'yoshida': return Campus.yoshida;
      case 'uji': return Campus.uji;
      case 'katsura': return Campus.katsura;
      case 'others': return Campus.others;
      default: return or;
    }
  }

  List<Campus> getCampusList(String key, { List<Campus> or }){
    final dynamic value = this[key];
    try{
      if(value is List<dynamic>){
        return value
                .map<String>((dynamic e) => e as String)
                .map<Campus>((e){
                  switch(e){
                    case 'yoshida': return Campus.yoshida;
                    case 'uji': return Campus.uji;
                    case 'katsura': return Campus.katsura;
                    case 'others': return Campus.others;
                    default:
                      assert(false, 'Unexpected Error');
                      return null;
                  }
                })
                .where((e) => e != null)
                .toList();
      }
      return or;
    } on Exception catch(_){
      return or;
    }
  }
}