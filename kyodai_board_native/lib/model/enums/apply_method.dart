enum ApplyMethod{
  app, webpage, chat, twitter, line, facebook, email, others, none,
}

final _formatmap = {
  ApplyMethod.app: 'アプリ内応募',
  ApplyMethod.webpage: 'ウェブぺージ',
  ApplyMethod.chat: 'チャット',
  ApplyMethod.twitter: 'Twitter',
  ApplyMethod.line: 'LINE',
  ApplyMethod.facebook: 'Facebook',
  ApplyMethod.email: 'メール',
  ApplyMethod.others: 'その他の方法',
  ApplyMethod.none: '応募は不要です',
};


// ignore: unused_element
final _tomap = Map<ApplyMethod, String>.fromEntries(ApplyMethod.values.map((e) => MapEntry(e, e.toString().split('.')[1])));
final _frommap = Map<String, ApplyMethod>.fromEntries(ApplyMethod.values.map((e) => MapEntry(e.toString().split('.')[1], e)));

extension StringUnivGrade on ApplyMethod{
  String get format => _formatmap[this];
}

extension StringApplyMethodList on List<ApplyMethod>{
  bool get needApply => !contains(ApplyMethod.none);
  bool get appApply => contains(ApplyMethod.app) || contains(ApplyMethod.webpage);
}

extension ConvertableMap on Map<String, dynamic>{
  List<ApplyMethod> getApplyMethods(String key, { List<ApplyMethod> or }){
    final dynamic value = this[key];
    try{
      if(value is List<dynamic>){
        return value.map((dynamic e) => _frommap[e as String]).toList();
      }else{
        return or;
      }
    }on Exception catch (_){
      return or;
    }
  }
}