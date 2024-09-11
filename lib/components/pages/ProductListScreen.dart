import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Rozgar/components/models/IProduct.dart';
import 'package:Rozgar/service/AllProductApiService.dart';
import 'package:Rozgar/components/pages/ProductCreateScreen.dart';
import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the ProductList widget
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

        // Make HTTP request to fetch products
        final response = await http.get(Uri.parse('$baseUrl/Product/GetAllProductsByVendorId/$_cid'));

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Assuming the response body contains JSON array of products
          List<dynamic> jsonData = jsonDecode(response.body);

          // Convert JSON data to List<Iproduct>
          return jsonData.map((data) => Iproduct.fromJson(data)).toList();
        } else {
          // Handle error response
          throw Exception('Failed to load products');
        }
      }
    }
    // Return an empty list if vendor data is not available
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
                content: Text('Error: Internet Connection Lost. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          });
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You are offline. Please try again.',
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
          return Center(child: Text('No products available.',
           style: TextStyle(fontSize: 20, color: Colors.red)
          )
         );
        } else {
          List<Iproduct> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Iproduct product = products[index];
              return ListTile(
                title: Text(product.productImage),
                subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implement edit functionality or navigate to edit screen
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
