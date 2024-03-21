import 'package:http/http.dart' as http;
import 'dart:convert';

class FSDA {
  static const String baseUrl =
      'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=DEMO_KEY&query=Cheddar%20Cheese';
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/data'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error
      throw Exception('Failed to load data');
    }
  }
}
