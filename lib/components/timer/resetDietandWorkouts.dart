import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore.dart';

void deletetheUniverse() async {
  final User user = FirebaseAuth.instance.currentUser!;
  await calculateAndUpdateFitniScores(user.uid);
}

Future<void> calculateAndUpdateFitniScores(String userId) async {
  int totalFitniScore = 0;

  // Calculate workout fitni scores
  totalFitniScore += await calculateWorkoutFitniScores(userId);

  // Calculate diet fitni scores
  totalFitniScore += await calculateDietFitniScores(userId);

  // Fetch current fitniQuest document
  DocumentSnapshot fitniQuestSnapshot = await FirebaseFirestore.instance
      .collection('fitniQuest')
      .doc(userId)
      .get();

  if (fitniQuestSnapshot.exists) {
    Map<String, dynamic>? fitniQuestData =
        fitniQuestSnapshot.data() as Map<String, dynamic>?;

    int currentStreak = fitniQuestData?['streak'] ?? 1;
    int daysTracked = fitniQuestData?['daysTracked'] ?? 0;
    int caloriesBurned = fitniQuestData?['caloriesBurned'] ?? 0;
    int workoutsCompleted = fitniQuestData?['workoutsCompleted'] ?? 0;
    String rank = fitniQuestData?['rank'] ?? "The New Guy";

    // Update streak
    if (totalFitniScore == 0) {
      currentStreak = 1;
    } else {
      currentStreak += 1;
      daysTracked += 1;
      if (daysTracked == 5) {
        rank = "The Town Rumor";
      } else if (daysTracked == 10) {
        rank = "The Famous Town Rumor";
      }
    }

    // Update calories burned (assuming you want to add consumed calories from diet scores)
    caloriesBurned += await getConsumedCalories(userId);

    // Increment workouts completed
    workoutsCompleted += 1;

    // Update fitniQuest document in Firestore
    await FirestoreService().updateFitniQuest(userId, totalFitniScore,
        currentStreak, daysTracked, caloriesBurned, workoutsCompleted, rank);
  } else {
    // Create new fitniQuest document if it doesn't exist
    await FirestoreService()
        .updateFitniQuest(userId, totalFitniScore, 1, 0, 0, 0, "The New Guy");
  }
}

Future<int> calculateWorkoutFitniScores(String userId) async {
  int fitniScore = 0;
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('checkedWorkouts')
      .where('userId', isEqualTo: userId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? workoutData =
        querySnapshot.docs.first.data() as Map<String, dynamic>?;

    List<int> workoutFitniScores =
        workoutData?['workoutFitniScores']?.cast<int>() ?? [];

    for (int score in workoutFitniScores) {
      fitniScore += score;
    }

    // Clear checked workouts
    await FirestoreService().updateCheckedWorkouts(userId, [], []);
  }
  return fitniScore;
}

Future<int> calculateDietFitniScores(String userId) async {
  int fitniScore = 0;

  QuerySnapshot foodLogsSnapshot = await FirebaseFirestore.instance
      .collection('foodLogs')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  QuerySnapshot userSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  if (foodLogsSnapshot.docs.isNotEmpty && userSnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? dietData =
        foodLogsSnapshot.docs.first.data() as Map<String, dynamic>?;
    int consumedCalories = dietData?['consumedCalories'] ?? 0;

    Map<String, dynamic>? userData =
        userSnapshot.docs.first.data() as Map<String, dynamic>?;
    int requiredCalories = userData?['caloricNeed']?.toInt() ?? 0;

    int difference = (requiredCalories - consumedCalories).abs();

    if (difference < 100) {
      fitniScore = 100;
    } else if (difference < 200) {
      fitniScore = 80;
    } else if (difference < 500) {
      fitniScore = 50;
    } else {
      fitniScore = 0;
    }

    // Clear food logs
    await FirestoreService().addFoodLog(userId, [], 0);
  }

  return fitniScore;
}

Future<int> getConsumedCalories(String userId) async {
  int consumedCalories = 0;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('foodLogs')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? dietData =
        querySnapshot.docs.first.data() as Map<String, dynamic>?;
    consumedCalories = dietData?['consumedCalories'] ?? 0;
  }

  return consumedCalories;
}
