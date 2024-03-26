import 'package:flutter/material.dart';
import '../dietlogger/dietlogwidget.dart';

class Diet extends StatefulWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  static const totalCalories = 2000;
  final List<List<String>> _data = [];

  Future<void> _receiveData(BuildContext context) async {
    final List<String>? result =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LogDiet(),
    ));

    if (result != null && result.length == 2) {
      setState(() {
        _data.add(result);
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
                      'Total Calories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      totalCalories.toString(),
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
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            food[0],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ), // Description
                          Text(food[1],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              )), // Calories
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
