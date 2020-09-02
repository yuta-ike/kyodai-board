import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/enums/motivation.dart';
import 'package:kyodai_board/model/enums/obligation.dart';
import 'package:kyodai_board/model/util/freq.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

class ClubProfile{
  const ClubProfile({
    @required this.name,
    this.nickname,
    @required this.genre,
    @required this.imageUrl,
    @required this.iconImageUrl,
    @required this.clubType,
    @required this.isSportsUnion,
    @required this.isOfficial,
    @required this.isIntercollege,
    @required this.isOnlyKU,
    @required this.isCompany,
    @required this.hasSchoolRestrict,
    this.allowanceSchools,
    this.competitionFreq,
    // ignore: non_constant_identifier_names
    this.competition_display,
    @required this.memberCount,
    this.genderRatio,
    this.kuRatio,
    // ignore: non_constant_identifier_names
    @required this.place_display,
    this.campus,
    @required this.freq,
    // ignore: non_constant_identifier_names
    this.freq_display,
    @required this.description,
    this.obligation,
    // ignore: non_constant_identifier_names
    this.obligation_display,
    this.motivation,
    // ignore: non_constant_identifier_names
    this.motivation_display,
    this.eventFreq,
    // ignore: non_constant_identifier_names
    this.event_display,
    this.drinkingFreq,
    // ignore: non_constant_identifier_names
    this.drinking_display,
    this.tripFreq,
    // ignore: non_constant_identifier_names
    this.trip_display,
    this.publicEmail,
    this.publicEmailDescription,
    this.publicEmail2,
    this.publicEmail2Description,
    this.publicPhoneNumber,
    this.publicPhoneNumberDescription,
    this.twitterUrl,
    this.twitterUrlDescription,
    this.twitterUrl2,
    this.twitterUrl2Description,
    this.facebookUrl,
    this.facebookUrlDescription,
    this.lineId,
    this.lineIdDescription,
    this.lineId2,
    this.lineId2Description,
  });

  ClubProfile.fromMap(Map<String, dynamic> map)
    : name = map.getString('name')
    , nickname = map.getString('nickname')
    , genre = map.getList<String>('genre')
    , imageUrl = map.getString('imageUrl')
    , iconImageUrl = map.getString('iconImageUrl')
    , clubType = map.getClubType('clubType')
    , isSportsUnion = map.getBool('name')
    , isOfficial = map.getBool('isOfficial')
    , isIntercollege = map.getBool('isIntercollege')
    , isOnlyKU = map.getBool('isOnlyKU')
    , kuRatio = map.getDouble('kuRatio')
    , isCompany = map.getBool('isCompany')
    , hasSchoolRestrict = map.getBool('hasSchoolRestrict')
    , allowanceSchools = map.getList<String>('allowanceSchools')
    , competitionFreq = map.getFreq('hasCompetition')
    , competition_display = map.getString('competition_display')
    , description = map.getString('description')
    , memberCount = map.getInt('memberCount')
    , genderRatio = map.getDouble('genderRatio')
    , place_display = map.getString('place_display')
    , campus = map.getCampus('campus')
    , freq = map.getFreq('freq')
    , freq_display = map.getString('freq_display')
    , obligation = map.getObligation('obligation')
    , obligation_display = map.getString('obligation_display')
    , motivation = map.getMotivation('motivation')
    , motivation_display = map.getString('motivation_display')
    , eventFreq = map.getFreq('eventFreq')
    , event_display = map.getString('event_display')
    , drinkingFreq = map.getFreq('drinkingFreq')
    , drinking_display = map.getString('drinking_display')
    , tripFreq = map.getFreq('tripFreq')
    , trip_display = map.getString('trip_display')
    , publicEmail = map.getString('publicEmail')
    , publicEmailDescription = map.getString('publicEmailDescription')
    , publicEmail2 = map.getString('publicEmail2')
    , publicEmail2Description = map.getString('publicEmail2Description')
    , publicPhoneNumber = map.getString('publicPhoneNumber')
    , publicPhoneNumberDescription = map.getString('publicPhoneNumberDescription')
    , twitterUrl = map.getString('twitterUrl')
    , twitterUrlDescription = map.getString('twitterUrlDescription')
    , twitterUrl2 = map.getString('twitter2Url')
    , twitterUrl2Description = map.getString('twitter2UrlDescription')
    , facebookUrl = map.getString('facebookUrl')
    , facebookUrlDescription = map.getString('facebookUrlDescription')
    , lineId = map.getString('lineId')
    , lineIdDescription = map.getString('lineIdDescription')
    , lineId2 = map.getString('lineId2')
    , lineId2Description = map.getString('lineId2Description');

  // 団体名
  final String name;
  // 団体名（呼称）
  final String nickname;
  // ジャンル
  final List<String> genre;
  // 団体画像
  final String imageUrl;
  // 団体のアバター画像
  final String iconImageUrl;
  // 団体種別
  final ClubType clubType;
  // 体育会か
  final bool isSportsUnion;
  // 公認団体か
  final bool isOfficial;
  // インカレか
  final bool isIntercollege;
  // 自分の大学オンリーか
  final bool isOnlyKU;
  // 会社団体か
  final bool isCompany;
  // 学部制限があるか
  final bool hasSchoolRestrict;
  // 制限された学部
  final List<String> allowanceSchools;
  // 他大との大会・発表会の頻度
  final Freq competitionFreq;
  // ignore: non_constant_identifier_names
  final String competition_display;

  // 団体の説明
  final String description;
  // 部員数
  final int memberCount;
  // 男女比
  final double genderRatio;
  // 自分の大学の割合
  final double kuRatio;
  // 練習場所
  // ignore: non_constant_identifier_names
  final String place_display;
  final Campus campus;
  // 頻度（/週）
  final Freq freq;
  // ignore: non_constant_identifier_names
  final String freq_display;
  // 原則全員参加・自由参加
  final Obligation obligation;
  // ignore: non_constant_identifier_names
  final String obligation_display;
  // モチベーション
  final Motivation motivation;
  // ignore: non_constant_identifier_names
  final String motivation_display;
  
  // イベント数（1年あたり）
  final Freq eventFreq;
  // ignore: non_constant_identifier_names
  final String event_display;
  // 飲み会頻度
  final Freq drinkingFreq;
  // ignore: non_constant_identifier_names
  final String drinking_display;
  // 合宿・旅行頻度
  final Freq tripFreq;
  // ignore: non_constant_identifier_names
  final String trip_display;

  // 連絡先
  final String publicEmail;
  final String publicEmailDescription;
  final String publicEmail2;
  final String publicEmail2Description;
  final String publicPhoneNumber;
  final String publicPhoneNumberDescription;
  final String twitterUrl;
  final String twitterUrlDescription;
  final String twitterUrl2;
  final String twitterUrl2Description;
  final String facebookUrl;
  final String facebookUrlDescription;
  final String lineId;
  final String lineIdDescription;
  final String lineId2;
  final String lineId2Description;
}