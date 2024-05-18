import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore.dart';

void resetStuff(User user) async {
  FirestoreService().updateCheckedWorkouts(user.uid, []);
  // _checkedExerciseNames.clear();
}
