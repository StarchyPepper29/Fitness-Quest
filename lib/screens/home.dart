import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/dietlogger/foodLog.dart';
import 'package:fitnessquest_v1/components/IbrahimsStuff/lib/exercise.dart';
import '../components/timer/timeHandler.dart';
import '../components/timer/resetDietandWorkouts.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    int day = TimeHandler().day;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      // bottomNavigationBar: BottomNavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.displayName}!', // Display user's display name
              style: const TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to LogDiet screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Diet(user)));
              },
              child: const Text('Log Diet'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to LogDiet screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExerciseScreen(day, user)));
              },
              child: const Text('Log Workout'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Sign Out'),
            ),
            // ElevatedButton(
            //   onPressed: () => resetStuff(user),
            //   child: const Text('Delete the Universe'),
            // ),
          ],
        ),
      ),
    );
  }
}
