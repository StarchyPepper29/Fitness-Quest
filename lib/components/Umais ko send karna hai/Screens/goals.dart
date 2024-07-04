import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessquest_v1/screens/editGoals.dart';

class Goals extends StatefulWidget {
  final User user;

  const Goals({Key? key, required this.user}) : super(key: key);

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  String? activityLevel;
  String? difficulty;
  String? goal;
  String? height;
  String? weight;
  bool? needsDumbell;

  @override
  void initState() {
    super.initState();
    fetchUserPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserPreferences();
  }

  Future<void> fetchUserPreferences() async {
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
          setState(() {
            activityLevel = userData['activityLevel'] ?? 'Unknown';
            difficulty = userData['difficulty'] ?? 'Unknown';
            goal = userData['goal'] ?? 'Unknown';
            height = userData['height'] ?? 'Unknown';
            weight = userData['weight'] ?? 'Unknown';
            needsDumbell = userData['needsDumbell'];
          });
        }
      } else {
        print('No user data found');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGoals(
                    user: widget.user,
                    currentActivity: activityLevel,
                    currentDifficulty: difficulty,
                    currentGoal: goal,
                    currentHeight: height,
                    currentWeight: weight,
                    currentNeedsDumbell: needsDumbell,
                  ),
                ),
              );
              fetchUserPreferences(); // Refresh the data when returning
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  GoalsDetail(title: 'Activity Level', value: activityLevel),
                  GoalsDetail(title: 'Difficulty', value: difficulty),
                  GoalsDetail(title: 'Goal', value: goal),
                  GoalsDetail(title: 'Height', value: height),
                  GoalsDetail(title: 'Weight', value: weight),
                  GoalsDetail(
                      title: 'Needs Dumbbell',
                      value: needsDumbell != null
                          ? (needsDumbell! ? 'Yes' : 'No')
                          : 'Unknown'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalsDetail extends StatelessWidget {
  final String title;
  final String? value;

  const GoalsDetail({required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? 'Loading...',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
