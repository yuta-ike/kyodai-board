import 'package:flutter/material.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/model/enums/report.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/repo/report_repo.dart';
import 'package:kyodai_board/view/components/organism/report_dialog/club_report_dialog.dart';

abstract class ReportDialog{
  static Future<bool> showClubReport(BuildContext context, Club club){
    return showDialog<bool>(
      context: context,
      builder: (context){
        return ClubReportDialog<ClubReportContent>(
          ClubReportContent.values,
          (content) => content.format,
          (content, body) async {
            await sendClubReport(club.id, club.name, content.keyString, body);
          }
        );
      }
    );
  }

  static Future<bool> showEventReport(BuildContext context, Event event){
    return showDialog<bool>(
      context: context,
      builder: (context){
        return ClubReportDialog<EventReportContent>(
          EventReportContent.values,
          (content) => content.format,
          (content, body) async {
            await sendEventReport(event.id, event.title, event.clubId, event.club.name, content.keyString, body);
          }
        );
      }
    );
  }
}

