import 'package:flutter/material.dart';
import 'exercise.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

////// These  List<String> _displayedExerciseNames;
//////        List<String> _displayedExerciseSets;
////// are navigated from exercise screen to this screen

class _MyHomePageState extends State<MyHomePage> {
  late List<String> _displayedExerciseNames;
  late List<String> _displayedExerciseSets;

  @override
  void initState() {
    super.initState();
    _displayedExerciseNames = [];
    _displayedExerciseSets = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),

      ////// to fix the size of the card
      body: SizedBox(
        width: 400, // Adjust the width as needed
        height: 200, // Adjust the height as needed
        child: GestureDetector(
          onTap: () async {
            ////// The list of names, sets are navigated here to display on the card

            final Map<String, dynamic>? checkedExercises = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExerciseScreen()),
            );
            if (checkedExercises != null &&
                checkedExercises['names'] != null &&
                checkedExercises['sets'] != null) {
              setState(() {
                _displayedExerciseNames = checkedExercises['names'];
                _displayedExerciseSets = checkedExercises['sets'];
              });
            }
          },

          ////// this code is for the card , it only displays the heading of the card "Exercises"

          child: Container(
            margin: const EdgeInsets.only(left: 20.0, top: 5),
            child: Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 20, top: 10, bottom: 10, right: 20),
                    child: Text(
                      'Exercises',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),

                  ////// this displays all the names and sets on the card, in scrolling view

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 10, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            _displayedExerciseNames.length,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_displayedExerciseNames[index]} (${_displayedExerciseSets[index]})',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        5.0), // Adjust the spacing between exercises if needed
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
