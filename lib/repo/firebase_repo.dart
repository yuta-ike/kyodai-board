import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseFirestore fsinstance = FirebaseFirestore.instance;
StateProvider<FirebaseFirestore> firestoreProvider = StateProvider((ref){
  return fsinstance;
});