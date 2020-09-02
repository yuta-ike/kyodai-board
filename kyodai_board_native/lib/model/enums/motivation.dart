enum Motivation{
  forWin, forJoy, both, others,
}

const Map<Motivation, String> _map = {
  Motivation.forWin: 'ガチ勢',
  Motivation.forJoy: 'エンジョイ勢',
  Motivation.both: 'ガチ勢エンジョイ勢の両方',
  Motivation.others: 'その他',
};

extension MotivationString on Motivation{
  String get format => _map[this];
}

extension ConvertableMap on Map<String, dynamic>{
  Motivation getMotivation(String key, { Motivation or }){
    final dynamic value = this[key];
    if(value is! String){
      return or;
    }
    switch(value as String){
      case 'forWin': return Motivation.forWin;
      case 'forJoy': return Motivation.forJoy;
      case 'both': return Motivation.both;
      case 'others': return Motivation.others;
      default: return or;
    }
  }
}