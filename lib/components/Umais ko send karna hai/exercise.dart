import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../services/firestore.dart';

class ExerciseScreen extends StatefulWidget {
  final User user;

  const ExerciseScreen(this.user, {super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<dynamic>? _exercises;
  List<bool> _exerciseCheckedState = [];
  final List<String> _checkedExerciseNames = [];
  bool _needsDumbbell = false;
  String _difficulty = '';
  int currentDayIndex = 1;

  @override
  void initState() {
    super.initState();
    loadDayIndex();
    fetchUserPreferences();
    fetchCheckedWorkouts();
  }

  Future<void> loadDayIndex() async {
    final int index = await timeHandler.getCurrentDayIndex();
    setState(() {
      currentDayIndex = index;
    });
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

      if (querySnapshot.docs.isNotEmpty) {
        print('User data found');
        Map<String, dynamic>? userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;
        print('User data: $userData');
        if (userData != null) {
          String difficulty = userData['difficulty'] ?? 'Beginner';
          bool needsDumbbell = userData['needsDumbell'] ?? false;
          print('User preferences: $difficulty, $needsDumbbell');
          setState(() {
            _difficulty = difficulty;
            _needsDumbbell = needsDumbbell;
          });

          if (_difficulty == 'Beginner' && !_needsDumbbell) {
            loadExercises('Beginner.json');
            print('Loading beginner exercises');
          } else if (_difficulty == 'Intermediate' && !_needsDumbbell) {
            loadExercises('Intermediate.json');
          } else if (_difficulty == 'Advanced' && !_needsDumbbell) {
            loadExercises('Hard.json');
          } else if (_needsDumbbell && _difficulty == 'Beginner') {
            print('Loading dumbbell exercises for Beginners');
            loadExercises('D_Beginner.json');
          } else if (_needsDumbbell && _difficulty == 'Intermediate') {
            loadExercises('D_Intermediate.json');
          } else if (_needsDumbbell && _difficulty == 'Advanced') {
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

      if (querySnapshot.docs.isNotEmpty) {
        print('Checked workouts found');
        Map<String, dynamic>? checkedWorkoutsData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;

        if (checkedWorkoutsData != null &&
            checkedWorkoutsData.containsKey('workoutNames')) {
          List<dynamic> workouts = checkedWorkoutsData['workoutNames'] ?? [];
          print('Checked workouts: $workouts');
          setState(() {
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
      }
    }

    print('Selected exercises: $_checkedExerciseNames');
    FirestoreService().updateCheckedWorkouts(
      widget.user.uid,
      _checkedExerciseNames,
    );
    Navigator.pop(context);
  }

  void loadExercises(String jsonFile) async {
    try {
      print('Loading exercises from: $jsonFile');
      String jsonString = await rootBundle.loadString('templates/$jsonFile');

      Map<String, dynamic> data = json.decode(jsonString);
      String currentDay = currentDayIndex.toString();
      String dayKey = 'Day_$currentDay';
      print('Day key: $dayKey');
      if (data.containsKey(dayKey)) {
        _exercises = data[dayKey]['exercises'];
        _exerciseCheckedState = List.generate(
          _exercises!.length,
          (index) => false,
        );
        setState(() {});
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
                            _checkedExerciseNames.add(exerciseName);
                          } else {
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
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
