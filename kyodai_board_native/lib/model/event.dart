import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/util/univ_grade.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

enum ApplyType{
  app, others, none,
}

enum WeatherCancel{
  cancelWhenRain, cancelWhenHardRain, noCancel,
}

class Schedule{
  const Schedule({
    this.id,
    this.startAt,
    this.startAt_display,
    this.endAt,
    this.endAt_display,
    this.applyStartAt,
    this.applyEndAt,
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
    this.applyType,
  });
  
  Schedule.fromMap(Map<String, dynamic> map)
    : id = map.getString('id')
    , startAt = map.getDate('startAt')
    , startAt_display = map.getString('startAt_display')
    , endAt = map.getDate('endAt')
    , endAt_display = map.getString('endAt_display')
    , applyStartAt = map.getDate('applyStartAt')
    , applyEndAt = map.getDate('applyEndAt')
    , place_display = map.getString('place_display')
    , campus = map.getCampus('campus')
    , meetingPlace_display = map.getString('meetingPlace_display')
    , weatherCancel = map.get<WeatherCancel>('weatherCancel')
    , weatherCancel_display = map.getString('weatherCancel_display')
    , contact = map.getString('contact')
    , contactCurrentDay = map.getString('contactCurrentDay')
    , qualifiedGrades = map.getList<UnivGrade>('qualifiedGrades')
    , entryQualify_display = map.getString('entryQualify_display')
    , belongings = map.getString('belongings')
    , notes = map.getString('notes')
    , applyType = map.get<ApplyType>('applyType');

  // ID
  final String id;
  // 開始時刻
  final DateTime startAt;
  final String startAt_display;
  // 終了時間
  final DateTime endAt;
  final String endAt_display;
  // 申し込み開始時刻
  final DateTime applyStartAt;
  // 申し込み終了時刻
  final DateTime applyEndAt;
  
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
  final ApplyType applyType;
}

class Event{
  const Event({
    @required this.id,
    @required this.isPublic,
    @required this.hostName,
    @required this.title,
    @required this.catchphrase,
    @required this.description,
    @required this.imageUrl,
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
    @required this.applyType,
    @required this.schedules,
  });

  Event.fromMap(Map<String, dynamic> map)
    : id = map.getString('id') ?? ''
    , isPublic = map.getBool('isPublic')
    , hostName = map.getString('hostName') ?? ''
    , title = map.getString('title') ?? ''
    , catchphrase = map.getString('catchphrase')
    , description = map.getString('description') ?? ''
    , imageUrl = map.getString('imageUrl') ?? ''
    , place_display = map.getString('place_display') ?? ''
    , campus = map.getCampus('campus')
    , meetingPlace_display = map.getString('meetingPlace_display')
    , weatherCancel = map.get<WeatherCancel>('weatherCancel')
    , weatherCancel_display = map.getString('weatherCancel_display')
    , contact = map.getString('contact')
    , contactCurrentDay = map.getString('contactCurrentDay')
    , qualifiedGrades = map.getList<UnivGrade>('qualifiedGrades')
    , entryQualify_display = map.getString('entryQualify_display')
    , belongings = map.getString('belongings') ?? ''
    , notes = map.getString('notes') ?? ''
    , applyType = map.get<ApplyType>('applyType')
    , schedules = map.getList<Schedule>('schedules');
  
  // ID
  final String id;
  // 公開中か
  final bool isPublic;
  // 作成団体名
  final String hostName;
  // イベントのタイトル
  final String title;
  // キャッチフレーズ
  final String catchphrase;
  // イベントの説明
  final String description;
  // 画像URL
  final String imageUrl;
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
  final ApplyType applyType;
  
  // 日程
  final List<Schedule> schedules;
}