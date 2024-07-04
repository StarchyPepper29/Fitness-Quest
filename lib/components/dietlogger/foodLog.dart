import 'package:fitnessquest_v1/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './dietlogwidget.dart';
import './caloricCalc.dart';

class Diet extends StatefulWidget {
  final User user;

  const Diet(this.user, {super.key});

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  int totalCalories = 2000;
  String recipeUri = '';
  String totalCaloriesPrintable = '2000';
  int consumedCalories = 0;
  List<List<String>> _data = [];
  final List<Map<String, dynamic>> _foodLog = [];

  @override
  void initState() {
    super.initState();
    fetchCaloricNeeds();
    fetchFoods();
  }

  void fetchCaloricNeeds() async {
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
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        if (userData != null) {
          setState(() {
            totalCalories = (userData['caloricNeed'] ?? 2000).toInt();

            totalCaloriesPrintable = totalCalories.toString();
          });
        } else {
          print('User data is null');
        }
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
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

      if (querySnapshot.docs.isNotEmpty) {
        print('Logged food found');
        Map<String, dynamic> loggedFood =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        if (loggedFood != null) {
          setState(() {
            _data = (loggedFood['foodLog'] as List<dynamic>).map((item) {
              Map<String, dynamic> foodItem = item as Map<String, dynamic>;
              return [
                foodItem['calories'].toString(),
                foodItem['uri'] as String,
                foodItem['name'] as String
              ];
            }).toList();

            consumedCalories = loggedFood['consumedCalories'] ?? 0;
            totalCalories -= consumedCalories;
            totalCaloriesPrintable = totalCalories.toString();
          });
        } else {
          print('Logged food data is null');
        }
      } else {
        print('No logged food found');
      }
    } catch (e) {
      print('Error fetching food: $e');
    }
  }

  Future<void> _receiveData(BuildContext context) async {
    final List<String>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LogDiet(),
      ),
    );

    if (result != null && result.length == 3) {
      setState(() {
        _data.add(result);
        consumedCalories += int.parse(result[0]);
        totalCalories -= int.parse(result[0]);
        totalCaloriesPrintable = totalCalories.toString();
      });
    }
  }

  void submitFoodLog(List<List<String>> data) {
    _foodLog.clear();
    for (var foodItem in data) {
      _foodLog.add({
        'name': foodItem[2],
        'uri': foodItem[1],
        'calories': int.parse(foodItem[0]),
      });
    }
    FirestoreService().addFoodLog(widget.user.uid, _foodLog, consumedCalories);
    Navigator.pop(context);
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
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food[1],
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 37, 40, 197),
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  food[1],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            food[0],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
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
                      child: const Text('Log Diet'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
