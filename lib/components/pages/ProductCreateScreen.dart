import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:Rozgar/components/models/IProduct.dart';
import 'package:Rozgar/components/utils/util.dart';
import 'package:Rozgar/service/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCreationScreen extends StatefulWidget {
  @override
  _ProductCreationScreenState createState() => _ProductCreationScreenState();
}

class _ProductCreationScreenState extends State<ProductCreationScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController brandController = TextEditingController();

File? _imgFile;
String? imgUrl;
dynamic? imageUrl;
File? selectedImage;
Future getImage() async {
  debugger();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
debugger();
   
    final ImagePicker picker = ImagePicker();
debugger();
final XFile? xImage = await picker.pickImage(source: ImageSource.gallery);
//TO convert Xfile into file
File file = File(xImage!.path);
//print(‘Image picked’);
 debugger();
     ImageService service=ImageService();
     debugger();
      service.submitSubscription(file:selectedImage!,filename:basename(selectedImage!.path));
    //return image;
  }

String base64String(File file) {
  List<int> imageBytes = file.readAsBytesSync();
  return base64Encode(imageBytes);
}

 Future<void> _uploadImageAndCreateProduct() async {
  try {
    
    if (imgUrl!=null) {
      setState(() {
        imgUrl = imageUrl;
      });

      SharedPreferences pref = await SharedPreferences.getInstance();
      dynamic _cid = 0;
      String _vendorName = '';
      String? vendorDataString = pref.getString('VendorData');
      if (vendorDataString != null) {
        List<dynamic> vendorData = jsonDecode(vendorDataString);
        if (vendorData.isNotEmpty) {
          _cid = vendorData[0]['cid'];
          _vendorName = vendorData[0]['vendorName'];
        }
      }

      Map<String, dynamic> newProduct = {
        'vendorId': _cid,
        'productName': productNameController.text.trim(),
        'productImage': imgUrl!,
        'price': double.tryParse(priceController.text.trim()) ?? 0.0,
        'brand': brandController.text.trim(),
        'description': descriptionController.text.trim(),
        'isActive': 1 // Example status
      };

      const String apiUrl = 'http://localhost:5000/api/Product/create';

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newProduct),
      );

      if (response.statusCode == 200) {
        print('ok'); // Product created successfully;
      } else {
       
        print('NOt ok'); // Product created successfully;
       }
    } else {
    
        print('Try Again'); // Product created successfully;
    }
  } catch (e) {
    print('Exception during image upload and product creation: $e');
    
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 24.0),
              _imgFile == null
                  ? ElevatedButton(
                      onPressed: () => getImage(),
                      child: Text('Pick Image'),
                    )
                  : Column(
                      children: [
                        Image.network(
                          imageUrl!
                          ),
                        SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () => getImage(),
                          child: Text('Change Image'),
                        ),
                      ],
                    ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _uploadImageAndCreateProduct,
                child: Text('Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
