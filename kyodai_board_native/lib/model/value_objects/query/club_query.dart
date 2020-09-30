import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/enums/motivation.dart';
import 'package:kyodai_board/model/enums/obligation.dart';
import 'package:kyodai_board/model/enums/day_of_week.dart';
import 'package:kyodai_board/model/enums/freq.dart';

enum GenderRatioChoice{
  male, fifty, female,
}
extension StringGenderRatioChoice on GenderRatioChoice{
  String get format => this == GenderRatioChoice.male ? '男性 多' : this == GenderRatioChoice.female ? '女性 多' : '半数';
}

enum CampusChoice{
  yoshida, uji, katsura, others,
}

extension StringCampusChoice on CampusChoice{
  String get format => this == CampusChoice.yoshida ? '吉田' : this == CampusChoice.uji ? '宇治' : this == CampusChoice.katsura ? '桂' : 'その他';
}

enum FreqChoice{
  oncePerMonth, twicePerMonth, oncePerWeek, twicePerWeek, threeTimesPerWeek, fourTimesPerWeek, fiveTimesPerWeek, almostEveryday
}

const List<int> memberCountChoices = [null, 10, 30, 40, 100, null];
const List<Freq> freqChoices = [Freq.oncePerMonth, Freq.twicePerMonth, Freq.oncePerWeek, Freq.twicePerWeek, Freq.threeTimesPerWeek, Freq.fourTimesPerWeek, Freq.fiveTimesPerWeek, Freq.almostEveryday];

enum EventFreqChoice{
  twicePerMonth,
  oncePerMonth,
  oncePerTwoMonth,
  oncePerThreeMonth,
  threeTimesPerYear,
  oncePerHalfYear,
  oncePerYear,
  moreRare,
}

class ClubQuery with ChangeNotifier{
  // Constructors
  ClubQuery():
    genre = null,
    clubTypes = ClubType.values,
    isOfficial = false,
    isIntercollege = true,
    isOnlyKU = false,
    isCompany = false,
    hasSchoolRestrict = false,
    competitionFreq = null,
    memberCount = const RangeValues(0, 5),
    genderRatio = null,
    kuRatio = null,
    campus = null,
    freq = const RangeValues(0, 7),
    daysOfWeek = DayOfWeek.values,
    obligation = null
    // ,motivation = null,
    // eventFreq = const RangeValues(0, 5),
    // drinkingFreq = const RangeValues(0, 5),
    // tripFreq = const RangeValues(0, 5)
    ;
  
  ClubQuery._from({
    this.genre,
    this.clubTypes,
    this.isOfficial,
    this.isIntercollege,
    this.isOnlyKU,
    this.isCompany,
    this.hasSchoolRestrict,
    this.competitionFreq,
    this.memberCount,
    this.genderRatio,
    this.kuRatio,
    this.campus,
    this.freq,
    this.daysOfWeek,
    this.obligation,
    this.motivation,
    // this.eventFreq,
    // this.drinkingFreq,
    // this.tripFreq,
  });
  
  ClubQuery copyWith({
    final List<String> genre,
    final List<ClubType> clubTypes,
    final bool isOfficial,
    final bool isIntercollege,
    final bool isOnlyKU,
    final bool isCompany,
    final bool hasSchoolRestrict,
    final Freq competitionFreq,
    final RangeValues memberCount,
    final GenderRatioChoice genderRatio,
    final double kuRatio,
    final CampusChoice campus,
    final RangeValues freq,
    final List<DayOfWeek> dayOfWeeks,
    final Obligation obligation,
    final Motivation motivation,
    final RangeValues eventFreq,
    final RangeValues drinkingFreq,
    final RangeValues tripFreq,
  }){
    return ClubQuery._from(
      genre: genre,
      clubTypes: clubTypes,
      isOfficial: isOfficial,
      isIntercollege: isIntercollege,
      isOnlyKU: isOnlyKU,
      isCompany: isCompany,
      hasSchoolRestrict: hasSchoolRestrict,
      competitionFreq: competitionFreq,
      memberCount: memberCount,
      genderRatio: genderRatio,
      kuRatio: kuRatio,
      campus: campus,
      freq: freq,
      daysOfWeek: dayOfWeeks,
      obligation: obligation,
      motivation: motivation,
      // eventFreq: eventFreq,
      // drinkingFreq: drinkingFreq,
      // tripFreq: tripFreq,
    );
  }
  
  // ジャンル
  List<String> genre;
  // 団体種別
  List<ClubType> clubTypes;
  // 公認団体か
  bool isOfficial;
  // インカレか
  bool isIntercollege;
  // 自分の大学オンリーか
  bool isOnlyKU;
  // 会社団体か
  bool isCompany;
  // 学部制限があるか
  bool hasSchoolRestrict;
  // 他大との大会・発表会の頻度
  Freq competitionFreq;

  // 部員数
  RangeValues memberCount;
  // 男女比
  GenderRatioChoice genderRatio;
  // 自分の大学の割合
  double kuRatio;
  // 練習場所
  CampusChoice campus;
  // 頻度（/週）
  RangeValues freq;
  // 活動曜日
  List<DayOfWeek> daysOfWeek;
  // 原則全員参加・自由参加
  Obligation obligation;
  // モチベーション
  Motivation motivation;
  
  // // イベント数（1年あたり）
  // RangeValues eventFreq;
  // // 飲み会頻度
  // RangeValues drinkingFreq;
  // // 合宿・旅行頻度
  // RangeValues tripFreq;
}