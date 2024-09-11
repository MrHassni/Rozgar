import 'dart:convert';
import 'package:http/http.dart' as http;

class SubApiService {
  // final String baseUrl = "http://localhost:5000/api/SubCategory/GetSubCategoriesByCateId/";
  final String baseUrl = "https://rrnew.easwdb.com/api/SubCategory/GetSubCategoriesByCateId/";

  Future<List<Map<String, dynamic>>> fetchData(dynamic parameter) async {

    final response = await http.get(Uri.parse('$baseUrl${parameter}'));
    if (response.statusCode == 200) {
      // debugger();
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }
}