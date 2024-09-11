
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChildApiService {
  // final String baseUrl = "http://localhost:5000/api/Post/GetAllPosts";
  final String baseUrl = "https://rrnew.easwdb.com/api/Post/GetAllPosts";

  Future<List<Map<String, dynamic>>> fetchData() async {

    final response = await http.get(Uri.parse('$baseUrl'));
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