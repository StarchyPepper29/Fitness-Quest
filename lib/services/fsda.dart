import 'package:http/http.dart' as http;
import 'dart:convert';

class FSDA {
  Future<http.Response> fetchData() {
    return http.get(Uri.parse(
        'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=DEMO_KEY&query=Cheddar%20Cheese'));
  }
}
