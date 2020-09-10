enum WeatherCancel{
  cancelWhenRain, cancelWhenHardRain, noCancel,
}

final _tomap = Map<WeatherCancel, String>.fromEntries(WeatherCancel.values.map((e) => MapEntry(e, e.toString().split('.')[1])));
final _frommap = Map<String, WeatherCancel>.fromEntries(WeatherCancel.values.map((e) => MapEntry(e.toString().split('.')[1], e)));

extension StringUnivGrade on WeatherCancel{
  String get format => _tomap[this];
}

extension ConvertableMap on Map<String, dynamic>{
  WeatherCancel getWeatherCancel(String key, { WeatherCancel or }){
    final dynamic value = this[key];
    if(value is String){
      return _frommap[value];
    }else{
      return or;
    }
  }
}