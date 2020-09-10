enum UnivGrade{
  first,
  newFirst,
  second,
  newSecond,
  third,
  newThird,
  fourth,
  newFourth,
  postFirst,
  newPostFirst,
  postSecond,
  newPostSecond,
}

final _tomap = Map<UnivGrade, String>.fromEntries(UnivGrade.values.map((e) => MapEntry(e, e.toString().split('.')[1])));
final _frommap = Map<String, UnivGrade>.fromEntries(UnivGrade.values.map((e) => MapEntry(e.toString().split('.')[1], e)));

extension StringUnivGrade on UnivGrade{
  String get format => _tomap[this];
}

extension ConvertableMap on Map<String, dynamic>{
  List<UnivGrade> getUnivGrades(String key, { List<UnivGrade> or }){
    final dynamic value = this[key];
    try{
      if(value is List<dynamic>){
        return value.map((dynamic e) => _frommap[e as String]).toList();
      }else{
        return or;
      }
    }catch(e){
      return or;
    }
  }
}