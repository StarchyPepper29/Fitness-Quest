import 'package:flutter/material.dart';
import 'package:fitnessquest_v1/components/goals/dietgoals.dart';

class GoalsIndex extends StatefulWidget {
  const GoalsIndex({Key? key}) : super(key: key);

  @override
  State<GoalsIndex> createState() => _GoalsIndexState();
}

class _GoalsIndexState extends State<GoalsIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Diet()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // Set height here
            ),
            child: Text('Goals'),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              //Go to Workout Pages
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // Set height here
            ),
            child: const Text('Workout Goals'),
          ),
        ],
      ),
    );
  }
}
