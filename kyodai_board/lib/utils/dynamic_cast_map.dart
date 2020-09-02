import 'package:cloud_firestore/cloud_firestore.dart';

extension DynamicCastMap on Map<String, dynamic>{
  T get<T>(String key, { T or }){
    final dynamic value = this[key];
    if(value is T){
      return this[key] as T;
    }else{
      return or;
    }
  }

  String getString(String key, { String or }) => get<String>(key, or: or);
  int getInt(String key, { int or }) => get<int>(key, or: or);
  double getDouble(String key, { double or }) => get<double>(key, or: or);
  bool getBool(String key, { bool or }) => get<bool>(key, or: or);
  List<T> getList<T>(String key, { List<T> or }){
    final dynamic value = this[key];
    if(value is List<dynamic>){
      try{
        return value.cast<T>();
      }catch(e){
        return or;
      }
    }else{
      return or;
    }
  }
  DateTime getDate(String key, { DateTime or }){
    final dynamic value = this[key];
    if(value is DateTime){
      return value;
    }else if(value is Timestamp){
      return value.toDate();
    }else{
      return or;
    }
  }
}