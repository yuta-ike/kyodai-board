import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/model/enums/apply_method.dart';
import 'package:kyodai_board/model/enums/place.dart';
import 'package:kyodai_board/model/enums/weather_cancel.dart';
import 'package:kyodai_board/model/enums/univ_grade.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

abstract class EventBase{
  const EventBase({
    @required this.club,
    @required this.clubRef,
    @required this.title,
    @required this.description,
    @required this.descriptionUrl,
    @required this.imageUrl,
    @required this.place_display,
    @required this.meetingPlace,
    @required this.meetingPlace_display,
    @required this.weatherCancel,
    @required this.weatherCancel_display,
    @required this.contact,
    @required this.contactCurrentDay,
    @required this.belongings,
    @required this.notes,
    @required this.infectionNotes,
    @required this.hasGradesLimit,
    @required this.qualifiedGrades,
    @required this.qualifiedGrades_display,
    @required this.applyMethods,
    @required this.apply_display,
  });

  // 画像もつけれると嬉しい
  EventBase.fromMap(Map<String, dynamic> map)
    : club = Club.fromMap((map['clubRef'] as DocumentReference).id, map['club'] as Map<String, dynamic>)
    , clubRef = map['clubRef'] as DocumentReference
    , title = map.getString('title')
    , description = map.getString('description')
    , descriptionUrl = map.getString('descriptionUrl', or: null)
    , imageUrl = map.getString('imageUrl')
    , place_display = map.getString('place_display')
    , meetingPlace = map.getPlace('meetingPlace')
    , meetingPlace_display = map.getString('meetingPlace_display')
    , weatherCancel = map.getWeatherCancel('weatherCancel')
    , weatherCancel_display = map.getString('weatherCancel_display')
    , contact = map.getString('contact')
    , contactCurrentDay = map.getString('contactCurrentDay')
    , hasGradesLimit = map.getBool('hasGradesLimit')
    , qualifiedGrades = map.getUnivGrades('qualifiedGrades')
    , qualifiedGrades_display = map.getString('qualifiedGrades_display')
    , belongings = map.getString('belongings')
    , notes = map.getString('notes')
    , infectionNotes = map.getString('infectionNotes')
    , applyMethods = map.getApplyMethods('applyMethods')
    , apply_display = map.getString('apply_display');
  
  // 団体情報
  final Club club;
  // 団体ID
  final DocumentReference clubRef;
  String get clubId => clubRef.id;

  // イベントのタイトル
  final String title;
  // イベントの説明
  final String description;
  // 説明URL
  final String descriptionUrl;
  // 画像URL
  final String imageUrl;
  // 開催場所
  final String place_display;
  final Place meetingPlace;
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
  final bool hasGradesLimit;
  final List<UnivGrade> qualifiedGrades;
  final String qualifiedGrades_display;
  
  // 持ち物
  final String belongings;
  // 注意事項
  final String notes;
  // 感染症対策
  final String infectionNotes;
  // 応募方法
  final List<ApplyMethod> applyMethods;
  // 応募について
  final String apply_display;
}

class Schedule extends EventBase{
  Schedule({
    this.id,
    Club club,
    DocumentReference clubRef,
    this.eventRef,
    this.startAt,
    this.endAt,
    this.time_display,
    this.applyStartAt,
    this.applyEndAt,
    this.applyTime_display,
    String title,
    String description,
    String descriptionUrl,
    String imageUrl,
    String place_display,
    Place meetingPlace,
    String meetingPlace_display,
    WeatherCancel weatherCancel,
    String weatherCancel_display,
    String contact,
    String contactCurrentDay,
    String belongings,
    String notes,
    String infectionNotes,
    bool hasGradesLimit,
    List<UnivGrade> qualifiedGrades,
    String qualifiedGrades_display,
    List<ApplyMethod> applyMethods,
    String apply_display,
  }): super(club: club, clubRef: clubRef, title: title, description: description, descriptionUrl: descriptionUrl,
        imageUrl: imageUrl, place_display: place_display, meetingPlace: meetingPlace, meetingPlace_display: meetingPlace_display,
        weatherCancel: weatherCancel, weatherCancel_display: weatherCancel_display, contact: contact,
        contactCurrentDay: contactCurrentDay, belongings: belongings, notes: notes, infectionNotes: infectionNotes,
        hasGradesLimit: hasGradesLimit, qualifiedGrades: qualifiedGrades,
        qualifiedGrades_display: qualifiedGrades_display, applyMethods: applyMethods, apply_display: apply_display
      );
  
  Schedule.fromMap(this.id, Map<String, dynamic> map)
    : startAt = map.getDate('startAt')
    , endAt = map.getDate('endAt')
    , time_display = map.getString('time_display')
    , applyStartAt = map.getDate('applyStartAt')
    , applyEndAt = map.getDate('applyEndAt')
    , applyTime_display = map.getString('applyTime_display')
    , eventRef = map['eventRef'] as DocumentReference
    , super.fromMap(map);

  final String id;
  final DocumentReference eventRef;
  String get eventId => eventRef.id;
  final DateTime startAt;
  final DateTime endAt;
  final String time_display;
  final DateTime applyStartAt;
  final DateTime applyEndAt;
  final String applyTime_display;
}

class Event extends EventBase{
  const Event({
    this.id,
    Club club,
    DocumentReference clubRef,
    String title,
    String description,
    String descriptionUrl,
    String imageUrl,
    String place_display,
    Place meetingPlace,
    String meetingPlace_display,
    WeatherCancel weatherCancel,
    String weatherCancel_display,
    String contact,
    String contactCurrentDay,
    String belongings,
    String notes,
    String infectionNotes,
    bool hasGradesLimit,
    List<UnivGrade> qualifiedGrades,
    String qualifiedGrades_display,
    List<ApplyMethod> applyMethods,
    String apply_display,
    this.schedules,
  }): super(club: club, clubRef: clubRef, title: title, description: description, descriptionUrl: descriptionUrl,
        imageUrl: imageUrl, place_display: place_display, meetingPlace: meetingPlace, meetingPlace_display: meetingPlace_display,
        weatherCancel: weatherCancel, weatherCancel_display: weatherCancel_display, contact: contact,
        contactCurrentDay: contactCurrentDay, belongings: belongings, notes: notes, infectionNotes: infectionNotes,
        hasGradesLimit: hasGradesLimit, qualifiedGrades: qualifiedGrades,
        qualifiedGrades_display: qualifiedGrades_display, applyMethods: applyMethods, apply_display: apply_display
      );

  Event.fromMap(this.id, Map<String, dynamic> map, this.schedules)
    : super.fromMap(map);

  // ID
  final String id;
  // 日程
  final List<Schedule> schedules;
}