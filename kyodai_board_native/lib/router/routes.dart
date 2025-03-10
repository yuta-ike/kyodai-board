// ignore: avoid_classes_with_only_static_members
class Routes{
  const Routes();
  static String get top => '/top';
  static String get login => '/login';
  static String get logout => '/logout';
  static String get register => '/register';
  static String get emailVerify => '/emailVerify';
  static String get passwordReset => '/password/reset';
  static String get passwordResend => '/password/resend';
  static String get boards => '/boards';
  static String get boardsSearch => '/boards/search';
  static String get boardsResult => '/boards/result';
  static String get chat => '/chat';
  static String get chatDetail => '/chat/detail';
  static String get chatDetailTemporary => '/chat/temporary';
  static String get clubs => '/clubs';
  static String get clubsSearch => '/clubs/search';
  static String get clubsResult => '/clubs/result';
  static String get mypage => '/mypage';
  static String get settings => '/settings';
  static String get settingsAccount => '/settings/account';
  static String get settingsNotify => '/settings/notify';
  static String get announce => '/settings/account';
  static String get version => '/settings/version';
}