import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String nick, String age, String weight,
      String height, String activityLevel) {
    return users.add({
      'name': name,
      'nick': nick,
      'age': age,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
    });
  }
}
