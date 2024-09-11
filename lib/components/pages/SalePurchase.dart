import 'dart:async';
import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:Rozgar/components/pages/vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:Rozgar/components/models/router.dart';
import 'package:Rozgar/service/sub_api_services.dart';

// ignore: must_be_immutable
class SalePurchase extends StatelessWidget {
  final SubApiService _apiService = SubApiService();
  Future<List<Map<String, dynamic>>> _fetchData() async {
    final List<dynamic> responseData = await _apiService.fetchData(7);
    return responseData.map((item) => item as Map<String, dynamic>).toList();
  }

  var height, width;
  SalePurchase({super.key});
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
          cTitle: 'Sale & Purchase',
          titleFontSize: 24.0,
          subtitleFontSize: 14.0,
          titleColor: Colors.black,
          subtitleColor: Colors.black,
        ),
        bodyContent: DataList(
          fetchData: _fetchData
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for data
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Show a Snackbar for error messages
         

             WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                //${snapshot.error}
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
                  'Error occurred. Please try again.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                
              ],
            ),
          );

        } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // Display the data when it's fully loaded
          List<Map<String, dynamic>> data = snapshot.data!;

          if (data.isEmpty) {
            // Show an AlertDialog for no data available
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('No Data'),
                    content: Text('No data available to display.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
            return Center(
              child: Text('No data available'),
            );
          }

          return ListView.builder(
            itemCount: (data.length / 2).ceil(), // Calculate number of rows needed
            itemBuilder: (context, index) {
              // Calculate indices for the current row
              int startIndex = index * 2;
              int endIndex = startIndex + 2 < data.length ? startIndex + 2 : data.length;

              // Create a sublist of data for the current row
              List<Map<String, dynamic>> currentRowData = data.sublist(startIndex, endIndex);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: currentRowData.map((item) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                        child: SizedBox(
                          height: 100,
                          child: InkWell(
                            onTap: () {
                              int itemSCateId = item['cid']; // Assuming item['cid'] is an integer
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorScreen(
                                    sCateId: itemSCateId,
                                    routeToPopTo: '/SalePurchase',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://rrnew.easwdb.com/api/UploadImage/GetImage/${item['sCateIcon']}',
                                  ),
                                  fit: BoxFit.contain, // Fit the image within the container
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        } else {
          // Handle unexpected cases
          return Center(
            child: Text('Unexpected state'),
          );
        }
      },
    );
  }
}
