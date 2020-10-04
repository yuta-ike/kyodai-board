import 'package:kyodai_board/model/enums/club_type.dart';

enum ClubFilterType{
  sportsUnion, sports, culture, music, tech, study, business, job, others
}

extension ConvertableClubFilterType on ClubFilterType{
  ClubType get asClubType {
    switch(this){
      case ClubFilterType.sportsUnion: return ClubType.sportsUnion;
      case ClubFilterType.sports: return ClubType.sports;
      case ClubFilterType.culture: return ClubType.sportsUnion;
      case ClubFilterType.music: return ClubType.music;
      case ClubFilterType.tech: return ClubType.tech;
      case ClubFilterType.study: return ClubType.study;
      case ClubFilterType.business: return ClubType.business;
      case ClubFilterType.job: return ClubType.job;
      case ClubFilterType.others: return ClubType.others;
    }
    return null;
  }
}