import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Rozgar/components/models/IProduct.dart';
import 'package:Rozgar/service/AllProductApiService.dart';
import 'package:Rozgar/components/pages/ProductCreateScreen.dart';
import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatefulWidget {
  @override
 
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final Allproductapiservice _apiService = Allproductapiservice();
  late Future<List<Iproduct>> _productsFuture;
  dynamic _cid = 0;
  String _vendorName = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  static const String baseUrl = 'https://rrnew.easwdb.com/api';

  Future<List<Iproduct>> _fetchProducts() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? vendorDataString = pref.getString('VendorData');
      if (vendorDataString != null) {
        List<dynamic> vendorData = jsonDecode(vendorDataString);
        if (vendorData.isNotEmpty) {
          _cid = vendorData[0]['cid'];
          _vendorName = vendorData[0]['vendorName'];
          print('Vendor ID: $_cid');
          print('Vendor Name: $_vendorName');

          final response = await http.get(Uri.parse('$baseUrl/Product/GetAllProductsByVendorId/$_cid'));

          if (response.statusCode == 200) {
            List<dynamic> jsonData = jsonDecode(response.body);
            return jsonData.map((data) => Iproduct.fromJson(data)).toList();
          } else {
            throw Exception('Failed to load products');
          }
        }
      }
      return [];
    } catch (error) {
      print('Error fetching products: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_vendorName),
        actions: [
          ElevatedButton(
            child: Text("Create"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductCreationScreen()),
            ),
          ),
        ],
      ),
      body: CommonScreen(
        HeaderSection: HeaderSection(
          logoPath: 'assets/images/logo.png',
          title: 'Product List',
          subtitle: 'Products for $_vendorName',
          cTitle: 'Products',
          titleFontSize: 24.0,
          subtitleFontSize: 14.0,
          titleColor: Colors.black,
          subtitleColor: Colors.black,
        ),
        bodyContent: ProductList(fetchProducts: _fetchProducts),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  final Future<List<Iproduct>> Function() fetchProducts;

  ProductList({required this.fetchProducts});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Iproduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = widget.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Iproduct>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${snapshot.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error occurred. Please try again.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                SizedBox(height: 16),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.blue),
                  onPressed: _refreshProducts,
                  iconSize: 30,
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products available'));
        } else {
          List<Iproduct> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Iproduct product = products[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AspectRatio(
                        aspectRatio: 1, // Maintain aspect ratio (square)
                        child: Image.network(
                          'https://rrnew.easwdb.com/api/UploadImage/GetImage/${product.productImage}',
                          fit: BoxFit.cover, // Cover the entire space
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
