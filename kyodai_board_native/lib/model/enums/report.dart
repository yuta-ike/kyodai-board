enum ClubReportContent{
  inappropriate, spam, impersonation, unexist, others,
}

extension StringReportContent on ClubReportContent{
  String get keyString => toString().split('.')[1];
  String get format =>
      this == ClubReportContent.inappropriate ? '不適切な内容' :
      this == ClubReportContent.spam ? 'スパム' :
      this == ClubReportContent.impersonation ? 'なりすまし' :
      this == ClubReportContent.unexist ? '存在しない団体' : 'その他';
}

enum EventReportContent{
  inappropriate, spam, unexist, others,
}

extension StringEventReportContent on EventReportContent{
  String get keyString => toString().split('.')[1];
  String get format =>
      this == EventReportContent.inappropriate ? '不適切な内容' :
      this == EventReportContent.spam ? 'スパム' :
      this == EventReportContent.unexist ? '存在しないイベント' : 'その他';
}

enum TalkReportContent{
  inappropriate, spam, others,
}

extension StringTalkReportContent on TalkReportContent{
  String get keyString => toString().split('.')[1];
  String get format =>
      this == TalkReportContent.inappropriate ? '不適切な内容' :
      this == TalkReportContent.spam ? 'スパム' : 'その他';
}
