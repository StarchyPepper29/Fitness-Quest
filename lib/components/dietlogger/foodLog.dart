import 'package:fitnessquest_v1/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './dietlogwidget.dart';

class Diet extends StatefulWidget {
  final User user;

  const Diet(this.user, {Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  int totalCalories = 2000;
  String recipeUri = '';
  String totalCaloriesPrintable = '2000';
  int ConsumedCalories = 0;
  List<List<String>> _data = [];
  final List<String> _foodLog = [];

  void initState() {
    super.initState();
    fetchFoods();
  }

  void fetchFoods() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('Fetching Food for ${widget.user.uid}');
      QuerySnapshot querySnapshot = await firestore
          .collection('foodLogs')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      // Check if the snapshot exists and contains data
      if (querySnapshot.docs.isNotEmpty) {
        print('Logged food found');
        Map<String, dynamic>? loggedFood =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;

        // Checking if loggedFood is not null
        if (loggedFood != null) {
          setState(() {
            // Assuming _checkedExerciseNames is a List<String> in your state
            _data = loggedFood['food'] as List<List<String>>;
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

  Future<void> _receiveData(BuildContext context) async {
    final List<String>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LogDiet(),
      ),
    );

    if (result != null && result.length == 3) {
      print(totalCalories);
      setState(() {
        _data.add(result);
        ConsumedCalories += int.parse(result[0]);
        totalCalories -= ConsumedCalories;
        totalCaloriesPrintable = totalCalories.toString();
      });
    }
  }

  void submitFoodLog(List<List<String>> data) {
    for (int i = 0; i < data.length; i++) {
      _foodLog.add(data[i][0]);
    }
    FirestoreService().addFoodLog(widget.user.uid, _foodLog);
    _foodLog.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            color: Colors.blue,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Calories Left for Today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      totalCaloriesPrintable,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                // Your other rows...
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            color: Colors.red,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add onPressed functionality
                      },
                      child: const Text('Edit Goals'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _receiveData(context);
                      },
                      child: const Text('Log Today\'s Meals'),
                    ),
                  ],
                ),
                Column(
                  children: _data.map((food) {
                    // int foodInt = int.parse(food[0]);
                    // totalCalories -= foodInt;
                    // print(totalCalories);
                    // print(ConsumedCalories);
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              food[0],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 37, 40, 197),
                                fontSize: 18,
                              ),
                            ), // Description
                          ),
                          Text(
                            food[1],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ), // Calories
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            color: Colors.green,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Log Diet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          submitFoodLog(_data);
                        },
                        child: const Text('Log Diet'))
                  ],
                ),
                // Your other rows...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
