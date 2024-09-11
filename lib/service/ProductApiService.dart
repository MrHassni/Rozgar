import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:Rozgar/components/models/IProduct.dart';
import 'package:Rozgar/components/models/IVendor.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
class ProductApiService {
  static const String baseUrl = 'https://rrnew.easwdb.com/api';

  Future<List<Iproduct>>getAlloductsByVendorId(int vendorId) async {
    final response = await http.get(Uri.parse('$baseUrl/Product/GetAllProductsByVendorId/$vendorId'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Iproduct.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Ivendor> getVendorById(int vendorId) async {
    final response = await http.get(Uri.parse('$baseUrl/Vendor/GetVendorsById/$vendorId'));
    if (response.statusCode == 200) {
      return Ivendor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load vendor');
    }
  }
Future<void> updateProduct(Iproduct product) async {
  final resoponse = await http.post(Uri.parse('$baseUrl/Product/create'));
  body: jsonEncode(product.toString());
  if(resoponse.statusCode==200){
    print('Succeed!! ');
  }
}



 Future<bool> createProduct(Iproduct product) async {
    try {
      var url = Uri.parse('$baseUrl/Product/create');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product),
      );

      if (response.statusCode == 200) {
        // Successful creation
        return true;
      } else {
        // Handle other status codes (e.g., 400 Bad Request)
        print('Failed to create product: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Exception during product creation: $e');
      return false;
    }
  }


  Future<String> uploadImage(File imageFile) async {
    try {
      var url = Uri.parse('$baseUrl/UploadImage'); // Replace with your image upload API endpoint
      var request = http.MultipartRequest('POST', url);
      debugger();
      request.files.add(
        http.MultipartFile(
          'file',
          imageFile.readAsBytes().asStream(),
           imageFile.lengthSync(),
          filename: path.basename(imageFile.path),
          
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var imageUrl = jsonResponse['imageUrl']; // Adjust according to your API response structure
        return imageUrl;
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Exception during image upload: $e');
      return '';
    }
  }


}
