import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogDiet extends StatefulWidget {
  const LogDiet({super.key});

  @override
  State<LogDiet> createState() => _LogDietState();
}

class _LogDietState extends State<LogDiet> {
  late Future<List<dynamic>> _futureData;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureData = Future.value([]);
  }

  Future<List<dynamic>> fetchData(String query) async {
    if (query.isEmpty) {
      return [];
    }
    var theQuery =
        "https://api.edamam.com/api/recipes/v2?type=public&q=${Uri.encodeComponent(query)}&app_id=94eae1d7&app_key=ba328c998104494ab3c083fdb2e6ff91";
    http.Response response = await http.get(Uri.parse(theQuery));
    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body)['hits'];
      return responseBody;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Search'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search for food',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _futureData = fetchData(_searchController.text);
                  });
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<dynamic> foodItems = snapshot.data!;
                  return ListView.builder(
                    itemCount: foodItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      String foodName = foodItems[index]['recipe']['label'];
                      double caloriesDouble = foodItems[index]['recipe']
                          ['totalDaily']['ENERC_KCAL']['quantity'];
                      int calories = caloriesDouble.toInt();
                      return ListTile(
                        title: Text(foodName),
                        subtitle: Text('Calories: $calories'),
                        onTap: () {
                          Navigator.of(context)
                              .pop([calories.toString(), foodName]);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
