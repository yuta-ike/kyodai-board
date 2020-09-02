enum Obligation{
  obligate, free
}

const Map<Obligation, String> _map = {
  Obligation.obligate: '原則全員参加',
  Obligation.free: '自由参加',
};

extension ObligationString on Obligation{
  String get format => _map[this];
}

extension ConvertableMap on Map<String, dynamic>{
  Obligation getObligation(String key, { Obligation or }){
    final dynamic value = this[key];
    if(value is! String){
      return or;
    }
    switch(value as String){
      case 'obligate': return Obligation.obligate;
      case 'free': return Obligation.free;
      default: return or;
    }
  }
}