extension StringWithBrEscape on String{
  String get escape => replaceAll('\\n', '\n');
  String get flatten => replaceAll('\\n', '');
}