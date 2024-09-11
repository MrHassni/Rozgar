
import 'dart:convert';
import 'package:http/http.dart' as http;

class Allproductapiservice{
static const String baseUrl = 'https://rrnew.easwdb.com/api';

  Future<List<Map<String, dynamic>>>getAllProductsByVendorId(int vendorId) async {
    final response = await http.get(Uri.parse('$baseUrl/Product/GetAllProductsByVendorId/$vendorId'));
    if (response.statusCode == 200) {
       List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
