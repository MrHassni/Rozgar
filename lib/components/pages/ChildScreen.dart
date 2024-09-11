import 'dart:async';
import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:flutter/material.dart';
import 'package:Rozgar/components/models/router.dart';
import 'package:Rozgar/service/child_api_services.dart';

class ChildScreen extends StatelessWidget {
  final ChildApiService _apiService = ChildApiService();

  Future<List<Map<String, dynamic>>> _fetchData() async {
    return await _apiService.fetchData(); // Assuming fetchData() returns List<Map<String, dynamic>>
  }
  var height, width;
  ChildScreen({super.key});
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body:  CommonScreen(
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
    return  FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ]);
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Map<String, dynamic>> data =
                            snapshot.data as List<Map<String, dynamic>>;
                        return ListView.builder(
  itemCount: (data.length / 2).ceil(), // Calculate number of rows needed
  itemBuilder: (context, index) {
    // Calculate indices for current row
    int startIndex = index * 2;
    int endIndex = startIndex + 2 < data.length ? startIndex + 2 : data.length;

    // Create a sublist of data for current row
    List<Map<String, dynamic>> currentRowData = data.sublist(startIndex, endIndex);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: currentRowData.map((item) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 12, // Adjust height as needed
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    AspectRatio(
                      aspectRatio: 1, // Maintain aspect ratio (square)
                      child: Image.network(
                        'https://rrnew.easwdb.com/api/UploadImage/GetImage/${item['postIcon']}',
                        fit: BoxFit.cover, // Cover the entire space
                      ),
                    ),
                    // Overlay text
                    Positioned(
                      bottom: 3,
                      left: 0,
                      right: 0,
                      child: Container(
                       // padding: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${item['contactName']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              '${item['pAddress']}',
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

