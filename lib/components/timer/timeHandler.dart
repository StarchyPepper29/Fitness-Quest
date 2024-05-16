import 'dart:async';
import './resetDietandWorkouts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeHandler {
  final User user = FirebaseAuth.instance.currentUser!;
  late Timer _timer;
  late int _day; // Declare the day variable
  late String _calories;

  TimeHandler() {
    _day = 1; // Initialize day variable
  }

  // Getter method for day variable
  int get day => _day;

  void start() {
    // Start the timer to update day variable every 24 hours
    _timer = Timer.periodic(Duration(hours: 24), (timer) {
      _day++; // Increment day variable every 24 hours
      resetStuff(user); // Reset diet and workouts every 24 hours
    });
  }

  void stop() {
    // Cancel the timer when needed
    _timer.cancel();
  }
}
