enum Place{
  yoshida, katsura, uji, online, others,
}

Map<Place, String> _map = {
  Place.yoshida: '吉田キャンパス',
  Place.katsura: '桂キャンパス',
  Place.uji: '宇治キャンパス',
  Place.online: 'オンライン',
  Place.others: 'その他',
};

Map<String, Place> _frommap = Map.fromEntries(Place.values.map((e) => MapEntry(e.keyString, e)));

extension PlaceString on Place{
  String get format => _map[this];
  String get keyString => toString().split('.')[1];
}

extension ExMap on Map<String, dynamic>{
  Place getPlace(String key, { Place or }){
    final dynamic value = this[key];
    if(value is String){
      return _frommap[value];
    }else{
      return or;
    }
  }
}