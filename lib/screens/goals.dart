import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessquest_v1/screens/editGoals.dart';
import '../../frontendComponents/statBox.dart'; // Adjust the import path as necessary
import '../../frontendComponents/goBackButton.dart'; // Adjust the import path as necessary
import '../../frontendComponents/customBanner1.dart'; // Adjust the import path as necessary
import '../../frontendComponents/topSection2.dart'; // Adjust the import path as necessary

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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.0),
                // CustomBanner(
                //   text: 'Fitness Goals',
                //   imageUrl: 'images/LoginDrawing.png',
                //   bannerColor: Color.fromARGB(255, 255, 131, 96),
                //   shadowColor: Color.fromARGB(255, 201, 87, 54),
                // ),
                TopSection(
                  onEditPressed: () {
                    Navigator.push(
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
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.0),
                      // Personal Data
                      StatBox(
                        title: 'Personal Data',
                        stats: [
                          {'name': 'Height', 'value': height ?? 'Loading...'},
                          {'name': 'Weight', 'value': weight ?? 'Loading...'},
                        ],
                      ),
                      SizedBox(height: 16.0),
                      // Preferences
                      StatBox(
                        title: 'Preferences',
                        stats: [
                          {
                            'name': 'Activity Level',
                            'value': activityLevel ?? 'Loading...'
                          },
                          {
                            'name': 'Difficulty',
                            'value': difficulty ?? 'Loading...'
                          },
                          {'name': 'Goal', 'value': goal ?? 'Loading...'},
                          {
                            'name': 'Needs Dumbbell',
                            'value': needsDumbell != null
                                ? (needsDumbell! ? 'Yes' : 'No')
                                : 'Unknown',
                          },
                        ],
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                SizedBox(
                    height: 100), // Adjust this height as needed for spacing
              ],
            ),
            // Positioned(
            //   top: 16,
            //   left: 15,
            //   child: SizedBox(
            //     height: 60,
            //     width: 60,
            //     child: Container(
            //       alignment: Alignment.topLeft,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(12.0),
            //         border: Border.all(
            //             color: Color.fromARGB(255, 255, 131, 96), width: 3.0),
            //       ),
            //       child: IconButton(
            //         icon: Image.asset('icons/edit.png'),
            //         iconSize: 10.0,
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => EditGoals(
            //                 user: widget.user,
            //                 currentActivity: activityLevel,
            //                 currentDifficulty: difficulty,
            //                 currentGoal: goal,
            //                 currentHeight: height,
            //                 currentWeight: weight,
            //                 currentNeedsDumbell: needsDumbell,
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
