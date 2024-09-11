import 'package:flutter/material.dart';
import 'package:Rozgar/components/pages/AllProductScreen.dart';
import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:Rozgar/service/VendorApiService.dart';
 // Ensure you import the correct DataList widget

class VendorScreen extends StatelessWidget {
  final int sCateId;
  final String routeToPopTo;
  final VendorApiService _apiService = VendorApiService();

  VendorScreen({required this.sCateId, required this.routeToPopTo});

  Future<List<Map<String, dynamic>>> _fetchData() async {
     final List<dynamic> responseData = await _apiService.getAllVendorsBySubCategoryId(sCateId);

    // Convert List<dynamic> to List<Map<String, dynamic>>
    return responseData.map((item) => item as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CommonScreen(
        HeaderSection: HeaderSection(
          logoPath: 'assets/images/logo.png',
          title: 'A H K N',
          subtitle: 'Khawajgan Ba\'izat Rozgar',
          cTitle: 'Vendor',
          titleFontSize: 24.0,
          subtitleFontSize: 14.0,
          titleColor: Colors.black,
          subtitleColor: Colors.black,
        ),
        bodyContent: DataList(fetchData: _fetchData),
      ),
    );
  }
}



class DataList extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchData;

  DataList({required this.fetchData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
         WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: Internet Connection Lost. Please Try Again later.'),
                backgroundColor: Colors.red,
              ),
            );
          });
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                   'You are offline. Please try again.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available',
          style: TextStyle(fontSize: 20, color: Colors.red),));
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;

          return ListView.builder(
            itemCount: (data.length / 2).ceil(),
            itemBuilder: (context, index) {
              int startIndex = index * 2;
              int endIndex = startIndex + 2 < data.length ? startIndex + 2 : data.length;
              List<Map<String, dynamic>> currentRowData = data.sublist(startIndex, endIndex);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: currentRowData.map((item) {
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          int vId = item['cid'];
                          String vName = item['vendorName'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen()
                            ),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                'https://rrnew.easwdb.com/api/UploadImage/GetImage/${item['vendorIcon']}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 3,
                              left: 0,
                              right: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    item['vendorName'] ?? 'Name Not Found',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    item['vAddress'] ?? 'Address Not Found',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        }
      },
    );
  }
}
