import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore.dart';

void resetStuff() async {
  final User user = FirebaseAuth.instance.currentUser!;
  addWorkoutFitniScores(user.uid);
  addDietFitniScores(user.uid);
  FirestoreService().updateCheckedWorkouts(user.uid, [], []);

  // _checkedExerciseNames.clear();
}

void addWorkoutFitniScores(String userId) async {
  int fitniScore = 0;
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('checkedWorkouts')
      .where('userId', isEqualTo: userId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? workoutData =
        querySnapshot.docs.first.data() as Map<String, dynamic>?;

    List<int> workoutFitniScores = workoutData!['workoutFitniScores'];

    for (int i = 0; i < workoutFitniScores.length; i++) {
      fitniScore += workoutFitniScores[i];
    }

    FirestoreService().updateFitniQuest(userId, fitniScore);
    FirestoreService().updateCheckedWorkouts(userId, [], []);
  }
}

void addDietFitniScores(String userId) async {
  int fitniScore = 0;
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('foodLogs')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
      .collection('users')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  Map<String, dynamic>? dietData =
      querySnapshot.docs.first.data() as Map<String, dynamic>?;
  int consumedCalories = dietData!['consumedCalories'];

  Map<String, dynamic>? userData =
      querySnapshot2.docs.first.data() as Map<String, dynamic>?;
  int requiredCalories = userData!['caloricNeed'].toInt();

  int difference = requiredCalories - consumedCalories;

  if (difference < 0) {
    difference = difference * -1;
  }
  if (difference < 100) {
    fitniScore = 100;
  } else if (difference < 200) {
    fitniScore = 80;
  } else if (difference < 500) {
    fitniScore = 50;
  } else {
    fitniScore = 0;
  }
  FirestoreService().updateFitniQuest(userId, fitniScore);
  FirestoreService().addFoodLog(userId, [], 0);
}
