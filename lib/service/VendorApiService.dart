import 'dart:convert';
import 'package:Rozgar/components/models/IVendor.dart';
import 'package:http/http.dart' as http;



class VendorApiService {
  static const String baseUrl = 'https://rrnew.easwdb.com/api';

  Future<List<dynamic>>getAllVendorsBySubCategoryId(int sCateId) async {
    final response = await http.get(Uri.parse('$baseUrl/Vendor/GetVendorBysCateId/$sCateId'));
    if (response.statusCode == 200) {
     List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load products');
    }
  }
}