import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference checkedWorkouts =
      FirebaseFirestore.instance.collection('checkedWorkouts');
  final CollectionReference foodLogs =
      FirebaseFirestore.instance.collection('foodLogs');
  final CollectionReference fitniQuest =
      FirebaseFirestore.instance.collection('fitniQuest');

  Future<void> addCheckedWorkout(
    String userId,
    List<String> workoutName,
  ) {
    return checkedWorkouts.add({
      'userId': userId,
      'workoutName': workoutName,
    });
  }

  Future<void> updateFitniQuest(String userId, int questScore) async {
    final DocumentReference docRef = fitniQuest.doc(userId);

    try {
      await docRef.update({
        'questScore': FieldValue.increment(questScore),
      });
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        // Document does not exist, create it with the initial questScore
        await docRef.set({
          'userId': userId,
          'questScore': questScore,
        });
      } else {
        rethrow;
      }
    }
  }

  Future<void> addFoodLog(
    String userId,
    List<Map<String, dynamic>> foodLog,
    int consumedCalories,
  ) async {
    return foodLogs.doc(userId).set({
      'userId': userId,
      'foodLog': foodLog,
      'consumedCalories': consumedCalories,
    });
  }

  Future<void> updateCheckedWorkouts(
      String userId, List<String> workoutNames, List<int> workoutFitniScores) {
    return checkedWorkouts.doc(userId).set({
      'userId': userId,
      'workoutNames': workoutNames,
      'workoutFitniScores': workoutFitniScores,
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
    String gender,
    String goal,
    double caloricNeed, // New parameter for caloricNeed
  ) {
    return users.doc(userId).set({
      'userId': userId,
      'name': name,
      'nick': nick,
      'age': age,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'needsDumbell': needsDumbell,
      'difficulty': difficulty,
      'gender': gender,
      'goal': goal,
      'caloricNeed': caloricNeed, // Add caloricNeed to the Firestore document
    });
  }

  // Fetch user data
  Future<DocumentSnapshot> getUser(String userId) {
    return users.doc(userId).get();
  }

  Future<void> updateUser(
    String userId, {
    String? name,
    String? nick,
    String? age,
    String? weight,
    String? height,
    String? activityLevel,
    bool? needsDumbell,
    String? difficulty,
    String? gender,
    String? goal,
    double? caloricNeed,
  }) {
    Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (nick != null) data['nick'] = nick;
    if (age != null) data['age'] = age;
    if (weight != null) data['weight'] = weight;
    if (height != null) data['height'] = height;
    if (activityLevel != null) data['activityLevel'] = activityLevel;
    if (needsDumbell != null) data['needsDumbell'] = needsDumbell;
    if (difficulty != null) data['difficulty'] = difficulty;
    if (gender != null) data['gender'] = gender;
    if (goal != null) data['goal'] = goal;
    if (caloricNeed != null) data['caloricNeed'] = caloricNeed;

    return users.doc(userId).update(data);
  }
}
