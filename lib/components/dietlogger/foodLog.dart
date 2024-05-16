import 'package:flutter/material.dart';
import './dietlogwidget.dart';

class Diet extends StatefulWidget {
  const Diet({super.key, Key? customKey});

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  int totalCalories = 2000;
  String totalCaloriesPrintable = '2000';
  int ConsumedCalories = 0;
  final List<List<String>> _data = [];

  Future<void> _receiveData(BuildContext context) async {
    final List<String>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LogDiet(),
      ),
    );

    if (result != null && result.length == 2) {
      print(totalCalories);
      setState(() {
        _data.add(result);
        ConsumedCalories += int.parse(result[0]);
        totalCalories -= ConsumedCalories;
        totalCaloriesPrintable = totalCalories.toString();
      });
    }
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
                        onPressed: () {}, child: const Text('Log Diet'))
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
