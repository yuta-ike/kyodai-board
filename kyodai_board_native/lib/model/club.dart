import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/enums/day_of_week.dart';
import 'package:kyodai_board/model/enums/univ_grade.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

enum ContactType{
  email, twitter, facebook, line, phone,
}
class ContactInfo{
  const ContactInfo(this.contact, this.description, this.type);
  final String contact;
  final String description;
  final ContactType type;
}

class Club{
  const Club({
    @required this.id,
    @required this.name,
    @required this.displayName,
    @required this.genre,
    @required this.imageUrl,
    @required this.iconImageUrl,
    @required this.clubType,
    this.subClubType,
    @required this.isOfficial,
    @required this.isIntercollege,
    @required this.isCompany,
    @required this.hasSchoolRestrict,
    this.schoolRestrict_display,
    this.qualifiedGrades,
    this.qualifiedGrades_display,
    this.competition_display,
    @required this.description,
    this.memberCount,
    this.genderRatio,
    this.kuRatio,
    this.member_display,
    this.campus,
    this.place_display,
    this.cost_display,
    this.daysOfWeek,
    this.freq_display,
    this.obligation,
    this.obligation_display,
    this.motivation,
    this.motivation_display,
    this.event_display,
    this.drinking_display,
    this.trip_display,
    this.initialChatMessage,
    this.homepageUrl,
    this.contactInfo,
    this.snsInfo,
  });

  Club.fromMap(this.id, Map<String, dynamic> map)
    : name = map.getString('name')
    , displayName = map.getString('displayName')
    , genre = map.getList<String>('genre')
    , imageUrl = map.getString('imageUrl')
    , iconImageUrl = map.getString('iconImageUrl')
    , clubType = map.getClubType('clubType')
    , subClubType = map.getClubType('subClubType')
    , isOfficial = map.getBool('isOfficial')
    , isIntercollege = map.getBool('isIntercollege')
    , isCompany = map.getBool('isCompany')
    , hasSchoolRestrict = map.getBool('hasSchoolRestrict')
    , schoolRestrict_display = map.getString('schoolRestrict_display')
    , qualifiedGrades = map.getList<UnivGrade>('qualifiedGrades')
    , qualifiedGrades_display = map.getString('qualifiedGrades_display')
    , competition_display = map.getString('competition_display')
    , description = map.getString('description')
    , memberCount = map.getInt('memberCount')
    , genderRatio = map.getDouble('genderRatio')
    , kuRatio = map.getDouble('kuRatio')
    , member_display = map.getString('member_display')
    , campus = map.getCampusList('campus')
    , place_display = map.getString('place_display')
    , cost_display = map.getString('cost_display')
    , daysOfWeek = map.getDayOfWeeks('daysOfWeek')
    , freq_display = map.getString('freq_display')
    , obligation = map.getInt('obligation')
    , obligation_display = map.getString('obligation_display')
    , motivation = map.getInt('motivation')
    , motivation_display = map.getString('motivation_display')
    , event_display = map.getString('event_display')
    , drinking_display = map.getString('drinking_display')
    , trip_display = map.getString('trip_display')
    , initialChatMessage = map.getString('initialChatMessage')
    , homepageUrl = map.getString('homepageUrl')
    , contactInfo = [
        ContactInfo(map.getString('publicEmail'), map.getString('publicEmailDescription'), ContactType.email),
        ContactInfo(map.getString('publicEmail2'), map.getString('publicEmail2Description'), ContactType.email),
        ContactInfo(map.getString('publicPhoneNumber'), map.getString('publicPhoneNumberDescription'), ContactType.phone),
      ].where((info) => info.contact != null && info.contact.isNotEmpty).toList()
    , snsInfo = [
        ContactInfo(map.getString('twitterUrl'), map.getString('twitterUrlDescription'), ContactType.twitter),
        ContactInfo(map.getString('twitter2Url'), map.getString('twitter2UrlDescription'), ContactType.twitter),
        ContactInfo(map.getString('facebookUrl'), map.getString('facebookUrlDescription'), ContactType.facebook),
        ContactInfo(map.getString('lineId'), map.getString('lineIdDescription'), ContactType.line),
        ContactInfo(map.getString('lineId2'), map.getString('lineId2Description'), ContactType.line),
      ].where((info) => info.contact != null && info.contact.isNotEmpty).toList();

  // ID
  final String id;
  // 団体名
  final String name;
  // 表示名
  final String displayName;
  // ジャンル
  final List<String> genre;
  // 団体画像
  final String imageUrl;
  // 団体のアバター画像
  final String iconImageUrl;
  // 団体種別
  final ClubType clubType;
  final ClubType subClubType;
  // 公認団体か
  final bool isOfficial;
  // インカレか
  final bool isIntercollege;
  // 会社団体か
  final bool isCompany;
  // 学部制限
  final bool hasSchoolRestrict;
  final String schoolRestrict_display;
  // 学年制限
  final List<UnivGrade> qualifiedGrades;
  final String qualifiedGrades_display;

  // 他大との大会・発表会の頻度
  final String competition_display;

  // 団体の説明・アピールポイント
  final String description;
  // 部員数
  final int memberCount;
  // 男女比
  final double genderRatio;
  // 自分の大学の割合
  final double kuRatio;
  // メンバー説明
  final String member_display;
  // 練習場所
  final List<Campus> campus;
  final String place_display;
  // 費用
  final String cost_display;
  // 活動曜日
  final List<DayOfWeek> daysOfWeek;
  // 頻度（/週）
  final String freq_display;
  // 原則全員参加・自由参加
  final int obligation;
  final String obligation_display;
  // モチベーション
  final int motivation;
  final String motivation_display;
  
  // イベント数（1年あたり）
  final String event_display;
  // 飲み会頻度
  final String drinking_display;
  // 合宿・旅行頻度
  final String trip_display;
  
  // チャットの初期メッセージ
  final String initialChatMessage;

  // ホームページURL
  final String homepageUrl;
  // 連絡先
  final List<ContactInfo> contactInfo;
  final List<ContactInfo> snsInfo;
}