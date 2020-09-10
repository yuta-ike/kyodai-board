import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/apply_type.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/enums/weather_cancel.dart';
import 'package:kyodai_board/model/util/univ_grade.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

abstract class EventBase{
  String get hostName;
  String get clubId;
  String get catchphrase;
  String get title;
  String get description;
  String get imageUrl;
  String get iconUrl;
  // 開催場所
  String get place_display;
  Campus get campus;
  // 集合場所
  String get meetingPlace_display;
  // 雨天時の対応
  WeatherCancel get weatherCancel;
  String get weatherCancel_display;
  // 連絡先
  String get contact;
  // 当日連絡先
  String get contactCurrentDay;
  // 参加可能学年
  List<UnivGrade> get qualifiedGrades;
  String get entryQualify_display;
  // 持ち物
  String get belongings;
  // 注意事項
  String get notes;
  // 予約タイプ
  List<ApplyType> get applyTypes;
  String get applyType_display;
}

class Schedule implements EventBase{
  const Schedule({
    this.id,
    this.eventRef,
    this.startAt,
    this.endAt,
    this.time_display,
    this.applyStartAt,
    this.applyEndAt,
    this.isPublic,
    this.hostName,
    this.clubId,
    this.title,
    this.catchphrase,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.place_display,
    this.campus,
    this.meetingPlace_display,
    this.weatherCancel,
    this.weatherCancel_display,
    this.contact,
    this.contactCurrentDay,
    this.qualifiedGrades,
    this.entryQualify_display,
    this.belongings,
    this.notes,
    this.applyTypes,
    this.applyType_display,
  });
  
  Schedule.fromMap(this.id, Map<String, dynamic> map)
    : eventRef = map['eventRef'] as DocumentReference
    , startAt = map.getDate('startAt')
    , endAt = map.getDate('endAt')
    , time_display = map.getString('time_display')
    , applyStartAt = map.getDate('applyStartAt')
    , applyEndAt = map.getDate('applyEndAt')
    , isPublic = map.getBool('isPublic')
    , hostName = map.getString('hostName')
    , clubId = map.getString('clubId')
    , title = map.getString('title')
    , catchphrase = map.getString('catchphrase')
    , description = map.getString('description')
    , imageUrl = map.getString('imageUrl')
    , iconUrl = map.getString('iconUrl')
    , place_display = map.getString('place_display')
    , campus = map.getCampus('campus')
    , meetingPlace_display = map.getString('meetingPlace_display')
    , weatherCancel = map.getWeatherCancel('weatherCancel')
    , weatherCancel_display = map.getString('weatherCancel_display')
    , contact = map.getString('contact')
    , contactCurrentDay = map.getString('contactCurrentDay')
    , qualifiedGrades = map.getUnivGrades('qualifiedGrades')
    , entryQualify_display = map.getString('entryQualify_display')
    , belongings = map.getString('belongings')
    , notes = map.getString('notes')
    , applyTypes = map.getApplyTypes('applyType')
    , applyType_display = map.getString('applyType_display');

  // ID
  final String id;
  // Event ref
  final DocumentReference eventRef;
  // 開始時刻
  final DateTime startAt;
  // 終了時間
  final DateTime endAt;
  final String time_display;
  // 申し込み開始時刻
  final DateTime applyStartAt;
  // 申し込み終了時刻
  final DateTime applyEndAt;
  
  final bool isPublic;
  final String hostName;
  final String clubId;
  final String title;
  final String catchphrase;
  final String description;
  final String imageUrl;
  final String iconUrl;
  // 開催場所
  final String place_display;
  final Campus campus;
  // 集合場所
  final String meetingPlace_display;
  // 雨天時の対応
  final WeatherCancel weatherCancel;
  final String weatherCancel_display;
  // 連絡先
  final String contact;
  // 当日連絡先
  final String contactCurrentDay;
  // 参加可能学年
  final List<UnivGrade> qualifiedGrades;
  final String entryQualify_display;
  // 持ち物
  final String belongings;
  // 注意事項
  final String notes;
  // 予約タイプ
  final List<ApplyType> applyTypes;
  final String applyType_display;
}

class Event implements EventBase{
  const Event({
    @required this.id,
    @required this.isPublic,
    @required this.hostName,
    @required this.clubId,
    @required this.title,
    @required this.catchphrase,
    @required this.description,
    @required this.imageUrl,
    @required this.iconUrl,
    @required this.place_display,
    @required this.campus,
    @required this.meetingPlace_display,
    @required this.weatherCancel,
    @required this.weatherCancel_display,
    @required this.contact,
    @required this.contactCurrentDay,
    @required this.qualifiedGrades,
    @required this.entryQualify_display,
    @required this.belongings,
    @required this.notes,
    @required this.applyTypes,
    @required this.applyType_display,
    @required this.schedules,
  });

  Event.fromMap(this.id, Map<String, dynamic> map, this.schedules)
    : isPublic = map.getBool('isPublic')
    , hostName = map.getString('hostName') ?? ''
    , clubId = map.getString('clubId') ?? ''
    , title = map.getString('title') ?? ''
    , catchphrase = map.getString('catchphrase')
    , description = map.getString('description') ?? ''
    , imageUrl = map.getString('imageUrl') ?? ''
    , iconUrl = map.getString('iconUrl') ?? ''
    , place_display = map.getString('place_display') ?? ''
    , campus = map.getCampus('campus')
    , meetingPlace_display = map.getString('meetingPlace_display')
    , weatherCancel = map.getWeatherCancel('weatherCancel')
    , weatherCancel_display = map.getString('weatherCancel_display')
    , contact = map.getString('contact')
    , contactCurrentDay = map.getString('contactCurrentDay')
    , qualifiedGrades = map.getUnivGrades('qualifiedGrades')
    , entryQualify_display = map.getString('entryQualify_display')
    , belongings = map.getString('belongings') ?? ''
    , notes = map.getString('notes') ?? ''
    , applyTypes = map.getApplyTypes('applyType')
    , applyType_display = map.getString('applyType_display');
  
  // ID
  final String id;
  // 公開中か
  final bool isPublic;
  // 作成団体名
  final String hostName;
  // 団体ID
  final String clubId;
  // イベントのタイトル
  final String title;
  // キャッチフレーズ
  final String catchphrase;
  // イベントの説明
  final String description;
  // 画像URL
  final String imageUrl;
  // アイコンURL
  final String iconUrl;
  // 開催場所
  final String place_display;
  final Campus campus;
  // 集合場所
  final String meetingPlace_display;
  // 雨天時の対応
  final WeatherCancel weatherCancel;
  final String weatherCancel_display;
  // 連絡先
  final String contact;
  // 当日連絡先
  final String contactCurrentDay;
  
  // 参加可能学年
  final List<UnivGrade> qualifiedGrades;
  final String entryQualify_display;
  // 持ち物
  final String belongings;
  // 注意事項
  final String notes;
  // 予約タイプ
  final List<ApplyType> applyTypes;
  final String applyType_display;
  
  // 日程
  final List<Schedule> schedules;
}