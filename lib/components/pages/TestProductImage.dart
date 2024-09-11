import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCreateScreen extends StatefulWidget {
  @override
  _ProductCreateScreenState createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _imageFile;
  String? _uploadedImageUrl;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        print('User canceled image picking');
      }
    } catch (e) {
      print('$e');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to pick an image. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _uploadImageAndCreateProduct() async {
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('No Image Selected'),
          content:
              Text('Please select an image before creating the product.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    try {
      String imageUrl = await _uploadImage(_imageFile!);

      if (imageUrl.isNotEmpty) {
        setState(() {
          _uploadedImageUrl = imageUrl;
        });

        SharedPreferences pref = await SharedPreferences.getInstance();
        int vendorId = pref.getInt('cid') ?? 0;

        // Create product object with uploaded image URL
        // Replace with your model and API service logic
        Map<String, dynamic> productData = {
          'cid': 0, // Replace with actual cid if needed
          'vendorId': vendorId,
          'productName': nameController.text.trim(),
          'productImage': _uploadedImageUrl!,
          'price': double.tryParse(priceController.text.trim()) ?? 0.0,
          'brand': brandController.text.trim(),
          'pDescription': descriptionController.text.trim(),
          'pStatus': 0, // Example status
        };

        // Example API endpoint URL (replace with your actual endpoint)
        const String apiUrl = 'http://localhost:5000/api/CreateProduct';

        http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(productData),
        );

        if (response.statusCode == 200) {
          // Product created successfully, do something (e.g., navigate back)
          Navigator.of(context).pop();
        } else {
          // Handle error, show alert or retry
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Failed to create product'),
              content: Text('Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } else {
        // Handle image upload failure
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Failed to upload image'),
            content: Text('Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Exception during image upload and product creation: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to create product. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    // Example API endpoint URL (replace with your actual endpoint)
    const String uploadUrl = 'http://localhost:5000/api/UploadImage';

    // Encode image to base64
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    try {
      // Make POST request to upload image
      http.Response response = await http.post(
        Uri.parse(uploadUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        // Parse response to get imageURL
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String imageUrl = responseData['imageUrl'];
        return imageUrl;
      } else {
        // Handle HTTP error
        throw Exception('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      throw Exception('Error uploading image: $e');
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
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
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
                controller: brandController,
                decoration: InputDecoration(labelText: 'Brand'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 24.0),
              _imageFile == null
                  ? ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text('Pick Image'),
                    )
                  : Column(
                      children: [
                        Image.file(
                          _imageFile!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
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
