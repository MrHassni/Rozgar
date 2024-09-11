import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:Rozgar/components/pages/vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:Rozgar/service/sub_api_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: must_be_immutable
class Zayarat extends StatelessWidget {
  final SubApiService _apiService = SubApiService();
  Future<List<Map<String, dynamic>>> _fetchData() async {
    final List<dynamic> responseData = await _apiService.fetchData(8);
    return responseData.map((item)=>item as Map<String, dynamic>).toList();
  }
  var height, width;
  Zayarat({super.key});

  @override
    Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CommonScreen(
      HeaderSection:  HeaderSection(
          logoPath: 'assets/images/logo.png',
          title: 'A H K N',
          subtitle: 'Khawajgan Ba\'izat Rozgar',
          cTitle: 'Zayarat',
          titleFontSize: 24.0,
          subtitleFontSize: 14.0,
          titleColor: Colors.black,
          subtitleColor: Colors.black,
        ),
       bodyContent: DataList(fetchData: _fetchData,)),
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
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
        } else {
          List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
          return ListView.builder(
            itemCount: (data.length / 2).ceil(), // Calculate number of rows needed
            itemBuilder: (context, index) {
              // Calculate indices for current row
              int startIndex = index * 2;
              int endIndex = startIndex + 2 < data.length ? startIndex + 2 : data.length;

              // Create a sublist of data for current row
              List<Map<String, dynamic>> currentRowData = data.sublist(startIndex, endIndex);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: currentRowData.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                    height: 85, // Adjust height based on your design
                    width: MediaQuery.of(context).size.width, // Adjust width as needed
                    child: InkWell(
                      onTap: () {
                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorScreen(
                                    sCateId: 8,
                                    routeToPopTo: '/ZiaratPackege',
                                  ),
                                ),
                              );
                        
                      },
                      child: CachedNetworkImage(
                        imageUrl: 'https://rrnew.easwdb.com/api/UploadImage/GetImage/${item['sCateIcon']}',
                        fit: BoxFit.cover, // Adjust BoxFit as needed
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageBuilder: (context, imageProvider) => Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              scale: 1.5,
                            ),
                          ),
                        ),
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
