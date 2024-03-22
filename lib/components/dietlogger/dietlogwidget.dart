import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogDiet extends StatefulWidget {
  const LogDiet({Key? key}) : super(key: key);

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
    _futureData = fetchData('Cheddar Cheese');
  }

  Future<List<dynamic>> fetchData(String query) async {
    if (query.isEmpty) {
      return [];
    }
    http.Response response = await http.get(Uri.parse(
        'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=DEMO_KEY&query=${Uri.encodeQueryComponent(query)}&pageSize=2'));
    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body)['foods'];
      return responseBody;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Food Search'),
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
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<dynamic> foodItems = snapshot.data!;
                    return ListView.builder(
                      itemCount: foodItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        int fdcId = foodItems[index]['fdcId'];
                        String description = foodItems[index]['description'];
                        return ListTile(
                          title: Text('fdcId: $fdcId'),
                          subtitle: Text(description),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
