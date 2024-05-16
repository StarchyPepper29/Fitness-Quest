import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference checkedWorkouts =
      FirebaseFirestore.instance.collection('checkedWorkouts');
  final CollectionReference foodLogs =
      FirebaseFirestore.instance.collection('foodLogs');

  Future<void> addCheckedWorkout(
    String userId,
    List<String> workoutName,
  ) {
    return checkedWorkouts.add({
      'userId': userId,
      'workoutName': workoutName,
    });
  }

  Future<void> addFoodLog(String userId, List<String> foodLog) {
    return foodLogs.add({
      'userId': userId,
      'foodLog': foodLog,
    });
  }

  Future<void> updateCheckedWorkouts(String userId, List<String> workoutNames) {
    return checkedWorkouts.doc(userId).set({
      'userId': userId,
      'workoutNames': workoutNames,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addUser(
    String userId,
    String name,
    String nick,
    String age,
    String weight,
    String height,
    String activityLevel,
    bool needsDumbell,
    String difficulty,
  ) {
    return users.add({
      'userId': userId,
      'name': name,
      'nick': nick,
      'age': age,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'needsDumbell': needsDumbell,
      'difficulty': difficulty,
    });
  }
}
