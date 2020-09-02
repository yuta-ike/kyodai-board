import 'package:flutter/material.dart';
import 'package:kyodai_board/model/club_profile.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

enum AccountType {
  temporary, normal, silver, gold
}

extension on Map<String, dynamic>{
  AccountType getAccoutType(String key, { AccountType or }){
    final dynamic value = this[key];
    if(value is! AccountType){
      return or;
    }
    switch(value as String){
      case 'temporary': return AccountType.temporary;
      case 'normal': return AccountType.normal;
      case 'silver': return AccountType.silver;
      case 'gold': return AccountType.gold;
      default: return or;
    }
  }
}

class Club{
  const Club({
    @required this.id,
    @required this.accountType,
    @required this.isValid,
    @required this.isRegisterCompleted,
    @required this.profile,
  });

  Club.fromMap(Map<String, dynamic> map)
    : id = map.getString('id')
    , accountType = map.getAccoutType('accountType')
    , isValid = map.getBool('isValid')
    , isRegisterCompleted = map.getBool('isRegisterCompleted')
    , profile = ClubProfile.fromMap(map['profile'] as Map<String, dynamic>);
    

  final String id;
  final AccountType accountType;
  final bool isValid;
  final bool isRegisterCompleted;
  final ClubProfile profile;
}