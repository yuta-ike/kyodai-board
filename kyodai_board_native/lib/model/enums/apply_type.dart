enum ApplyType{
  app, webpage, chat, twitter, line, facebook, email, others, none,
}

final _formatmap = {
  ApplyType.app: 'アプリ内応募',
  ApplyType.webpage: 'ウェブぺージ',
  ApplyType.chat: 'チャット',
  ApplyType.twitter: 'Twitter',
  ApplyType.line: 'LINE',
  ApplyType.facebook: 'Facebook',
  ApplyType.email: 'メール',
  ApplyType.others: 'その他の方法',
  ApplyType.none: '応募は不要です',
};


final _tomap = Map<ApplyType, String>.fromEntries(ApplyType.values.map((e) => MapEntry(e, e.toString().split('.')[1])));
final _frommap = Map<String, ApplyType>.fromEntries(ApplyType.values.map((e) => MapEntry(e.toString().split('.')[1], e)));

extension StringUnivGrade on ApplyType{
  String get format => _formatmap[this];
}

extension StringApplyTypeList on List<ApplyType>{
  bool get needApply => !contains(ApplyType.none);
  bool get appApply => contains(ApplyType.app) || contains(ApplyType.webpage);
}

extension ConvertableMap on Map<String, dynamic>{
  List<ApplyType> getApplyTypes(String key, { List<ApplyType> or }){
    final dynamic value = this[key];
    try{
      if(value is List<dynamic>){
        return value.map((dynamic e) => _frommap[e as String]).toList();
      }else{
        return or;
      }
    }catch (e){
      return or;
    }
  }
}