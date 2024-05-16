import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../services/firestore.dart';

class ExerciseScreen extends StatefulWidget {
  final int day;
  final User user;

  const ExerciseScreen(this.day, this.user, {Key? key}) : super(key: key);

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<dynamic>? _exercises;
  List<bool> _exerciseCheckedState = [];
  final List<String> _checkedExerciseNames = [];
  final List<String> _checkedExerciseSets = [];
  bool _needsDumbbell = false;
  String _difficulty = '';

  @override
  void initState() {
    super.initState();
    fetchUserPreferences();
    fetchCheckedWorkouts();
  }

  void fetchUserPreferences() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('Fetching user preferences for ${widget.user.uid}');
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      // Check if the snapshot exists and contains data
      if (querySnapshot.docs.isNotEmpty) {
        // Access user preferences from the snapshot's data field
        print('User data found');
        Map<String, dynamic>? userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;
        print('User data: $userData');
        // Checking if userData is not null and contains required fields
        if (userData != null) {
          // Retrieve user preferences from userData
          String difficulty = userData['difficulty'] ?? 'Beginner';
          bool needsDumbbell = userData['needsDumbell'] ?? false;
          print('User preferences: $difficulty, $needsDumbbell');
          // Update state with fetched user preferences
          setState(() {
            _difficulty = difficulty;
            _needsDumbbell = needsDumbbell;
          });

          // Load exercises based on user preferences
          if (_difficulty == 'Beginner' && !_needsDumbbell) {
            loadExercises('Beginner.json');
            print('Loading beginner exercises');
          } else if (_difficulty == 'Intermediate' && !_needsDumbbell) {
            loadExercises('Intermediate.json');
          } else if (_difficulty == 'Hard' && !_needsDumbbell) {
            loadExercises('Hard.json');
          } else if (_needsDumbbell && _difficulty == 'Beginner') {
            print('Loading dumbbell exercises for Beginners');
            loadExercises('D_Beginner.json');
          } else if (_needsDumbbell && _difficulty == 'Intermediate') {
            loadExercises('D_Intermediate.json');
          } else if (_needsDumbbell && _difficulty == 'Hard') {
            loadExercises('D_Hard.json');
          } else {
            print('Invalid user preferences');
          }
        } else {
          print('User data is null');
        }
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error fetching user preferences: $e');
    }
  }

  void fetchCheckedWorkouts() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('Fetching checked workouts for ${widget.user.uid}');
      QuerySnapshot querySnapshot = await firestore
          .collection('checkedWorkouts')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      // Check if the snapshot exists and contains data
      if (querySnapshot.docs.isNotEmpty) {
        print('Checked workouts found');
        Map<String, dynamic>? checkedWorkoutsData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;

        // Checking if checkedWorkoutsData is not null
        if (checkedWorkoutsData != null &&
            checkedWorkoutsData.containsKey('workoutNames')) {
          List<dynamic> workouts = checkedWorkoutsData['workoutNames'] ?? [];
          // Update state with fetched checked workouts
          print('Checked workouts: $workouts');
          setState(() {
            // Assuming _checkedExerciseNames is a List<String> in your state
            _checkedExerciseNames.clear();
            _checkedExerciseNames.addAll(workouts.cast<String>());
          });
        } else {
          print('Checked workouts data is null');
        }
      } else {
        print('No checked workouts found');
      }
    } catch (e) {
      print('Error fetching checked workouts: $e');
    }
  }

  void submitSelectedExercises() {
    for (int i = 0; i < _exerciseCheckedState.length; i++) {
      if (_exerciseCheckedState[i]) {
        _checkedExerciseNames.add(_exercises![i]['name']);
        _checkedExerciseSets.add(_exercises![i]['sets']);
      }
    }

    print('Selected exercises: $_checkedExerciseNames');
    FirestoreService().updateCheckedWorkouts(
      widget.user.uid,
      _checkedExerciseNames,
    );
    // _checkedExerciseNames.clear();
    Navigator.pop(context);
  }

  void loadExercises(String jsonFile) async {
    try {
      print('Loading exercises from: $jsonFile');
      String jsonString = await rootBundle.loadString('templates/$jsonFile');

      Map<String, dynamic> data = json.decode(jsonString);
      String dayKey = 'Day_${widget.day}';
      if (data.containsKey(dayKey)) {
        _exercises = data[dayKey]['exercises'];
        _exerciseCheckedState = List.generate(
          _exercises!.length,
          (index) => false,
        );
        setState(() {}); // Trigger a rebuild
      } else {
        print('Exercises not found for day: $dayKey');
      }
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_exercises != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _exercises!.length,
                  itemBuilder: (context, index) {
                    final exerciseName = _exercises![index]['name'];
                    final isChecked =
                        _checkedExerciseNames.contains(exerciseName);

                    return CheckboxListTile(
                      title: Text(exerciseName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${_exercises![index]['instructions']}'),
                          Text('${_exercises![index]['sets']}'),
                          Text('${_exercises![index]['rest_period'] ?? 'N/A'}')
                        ],
                      ),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            // Add the exercise name to the list if checked
                            _checkedExerciseNames.add(exerciseName);
                          } else {
                            // Remove the exercise name from the list if unchecked
                            _checkedExerciseNames.remove(exerciseName);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: submitSelectedExercises,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
