enum Freq{
  moreRare,
  oncePerYear,
  oncePerHalfYear,
  threeTimesPerYear,
  oncePerThreeMonth,
  oncePerTwoMonth,
  oncePerMonth,
  twicePerMonth,
  oncePerWeek,
  twicePerWeek,
  threeTimesPerWeek,
  fourTimesPerWeek,
  fiveTimesPerWeek,
  almostEveryday,
}

Map<Freq, String> _map = {
  Freq.almostEveryday: 'ほぼ毎日',
  Freq.fiveTimesPerWeek: '週5回',
  Freq.fourTimesPerWeek: '週4回',
  Freq.threeTimesPerWeek: '週3回',
  Freq.twicePerWeek: '週2回',
  Freq.oncePerWeek: '週1回',
  Freq.twicePerMonth: '1ヶ月に2回',
  Freq.oncePerMonth: '1ヶ月に1回',
  Freq.oncePerTwoMonth: '2ヶ月に1回',
  Freq.oncePerThreeMonth: '3ヶ月に1回',
  Freq.threeTimesPerYear: '1年に3回',
  Freq.oncePerHalfYear: '半年に1回',
  Freq.oncePerYear: '1年に1回',
  Freq.moreRare: '1年に1回以下',
};

extension FreqString on Freq{
  String get format => _map[this];
}

extension MapFreq on Map<String, dynamic>{
  Freq getFreq(String key, { Freq or }){
    final dynamic value = this[key];
    if(value is! String){
      return or;
    }
    switch(value as String){
      case 'almostEveryday': return Freq.almostEveryday;
      case 'fiveTimesPerWeek': return Freq.fiveTimesPerWeek;
      case 'fourTimesPerWeek': return Freq.fourTimesPerWeek;
      case 'threeTimesPerWeek': return Freq.threeTimesPerWeek;
      case 'twicePerWeek': return Freq.twicePerWeek;
      case 'oncePerWeek': return Freq.fiveTimesPerWeek;
      case 'twicePerMonth': return Freq.twicePerMonth;
      case 'oncePerMonth': return Freq.oncePerMonth;
      case 'oncePerTwoMonth': return Freq.oncePerTwoMonth;
      case 'oncePerThreeMonth': return Freq.oncePerThreeMonth;
      case 'threeTimesPerYear': return Freq.threeTimesPerYear;
      case 'oncePerHalfYear': return Freq.oncePerHalfYear;
      case 'oncePerYear': return Freq.oncePerYear;
      default: return or;
    }
  }
}