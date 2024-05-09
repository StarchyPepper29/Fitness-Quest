import 'package:flutter/material.dart';
import 'package:fitnessquest_v1/components/goals/dietgoals.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
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
              minimumSize: const Size(double.infinity, 50), // Set height here
            ),
            child: const Text('Goals'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              //Go to Workout Pages
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50), // Set height here
            ),
            child: const Text('Workout Goals'),
          ),
        ],
      ),
    );
  }
}
