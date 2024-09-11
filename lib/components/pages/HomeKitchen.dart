import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:Rozgar/components/pages/vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:Rozgar/service/sub_api_services.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
// ignore: must_be_immutable
class HomeKitchen extends StatelessWidget {
  final SubApiService _apiService = SubApiService();
  Future<List<Map<String, dynamic>>> _fetchData() async {
    final List<dynamic> responseData = await _apiService.fetchData(4);
    return responseData.map((item) => item as Map<String, dynamic>).toList();
  }

  var height, width;
  HomeKitchen({super.key});

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CommonScreen(
        HeaderSection: HeaderSection(
          logoPath: 'assets/images/logo.png',
          title: 'A H K N',
          subtitle: 'Khawajgan Ba\'izat Rozgar',
          cTitle: 'Home Kitchen',
          titleFontSize: 24.0,
          subtitleFontSize: 14.0,
          titleColor: Colors.black,
          subtitleColor: Colors.black,
        ),
        bodyContent: DataList(
          fetchData: _fetchData,
        ),
      ),
    );
  }
}



class DataList extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchData;

  DataList({required this.fetchData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          );
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: Internet Connection Lost. Please Try Again later.'),
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
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No data available'),
          );
        } else {
          List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
          return ListView.builder(
            itemCount: (data.length / 2).ceil(),
            itemBuilder: (context, index) {
              int startIndex = index * 2;
              int endIndex = startIndex + 2 < data.length ? startIndex + 2 : data.length;
              List<Map<String, dynamic>> currentRowData = data.sublist(startIndex, endIndex);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: currentRowData.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
                    height: 105, // Adjust height based on your design
                    width: MediaQuery.of(context).size.width, // Adjust width as needed
                    child: InkWell(
                      onTap: () {
                        int itemSCateId = item['cid']; // Assuming item['cid'] is an integer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorScreen(
                              sCateId: itemSCateId,
                              routeToPopTo: '/HomeKitchen',
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: 'https://rrnew.easwdb.com/api/UploadImage/GetImage/${item['sCateIcon']}',
                        fit: BoxFit.cover, // Adjust BoxFit as needed
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        // Use placeholder and errorWidget to handle loading and error states
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        }
      },
    );
  }
}
