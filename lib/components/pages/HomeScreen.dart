import 'package:Rozgar/components/models/router.dart';
import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:Rozgar/service/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Rozgar/components/pages/LoginScreen.dart';






class HomeScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> _fetchData() async {
    return await _apiService.fetchData(); // Assuming fetchData() returns List<Map<String, dynamic>>
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRouter,
      title: 'Rozgar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          color: Colors.blueAccent,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Are you Vendor?", style: TextStyle(color: Colors.white)),
          actions: [
            ElevatedButton(
              child: Text("SignIn"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ),
            ),
          ],
        ),
        body: CommonScreen(
          HeaderSection: HeaderSection(
            logoPath: 'assets/images/logo.png',
            title: 'A H K N',
            subtitle: 'Khawajgan Ba\'izat Rozgar',
            cTitle: 'Home',
            titleFontSize: 24.0,
            subtitleFontSize: 14.0,
            titleColor: Colors.black,
            subtitleColor: Colors.black,
          ),
          bodyContent: DataList(fetchData: _fetchData),
        ),
      ),
    );
  }
}


class DataList extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchData;

  DataList({required this.fetchData});

  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = widget.fetchData();
  }
 Future<void> _refreshData() async {
    setState(() {
      _dataFuture = widget.fetchData();
    });
  }
  Future<void> _precacheImages (List<Map<String, dynamic>> data) async {
    for (var item in data) {
      // Adjust the path according to your assets
      final image = AssetImage('assets/images/${item['subString']}.png');
      // Pre-cache the image
      await precacheImage(image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {

  

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
                  'You are offline. Please try again.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                SizedBox(height: 16),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.blue),
                  onPressed: _refreshData,
                  iconSize: 30,
                ),
              ],
            ),
          );

        //  return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
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
           }
          // Pre-cache images after data is fetched
          _precacheImages(data);

          return ListView.builder(
            itemCount: (data.length / 2).ceil(),
            itemBuilder: (context, index) {
              int startIndex = index * 2;
              int endIndex = startIndex + 2 < data.length ? startIndex + 2 : data.length;
              List<Map<String, dynamic>> currentRowData = data.sublist(startIndex, endIndex);

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: currentRowData.map((item) {
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, item['routerLink']);
                        },
                        child: Container(
                          width: 180.0,
                          height: 60.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/${item['subString']}.png'),
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              item['title'] ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.white),
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
        }
      },
    );
  }
}


// class DataList extends StatelessWidget {
//   final Future<List<Map<String, dynamic>>> Function() fetchData;
//   final isVisible= false;
//   DataList({required this.fetchData});

//   @override
//   Widget build(BuildContext context) {
    
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: fetchData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No data available'));
//         } else {
//           List<Map<String, dynamic>> data = snapshot.data!;
//           return ListView.builder(
//             itemCount: (data.length / 2).ceil(),
//             itemBuilder: (context, index) {
//               int startIndex = index * 2;
//               int endIndex = startIndex + 2 < data.length ? startIndex + 2 : data.length;
//               List<Map<String, dynamic>> currentRowData = data.sublist(startIndex, endIndex);

//               return Container(
//                 padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: currentRowData.map((item) {
//                     return Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pushNamed(context, item['routerLink']);
//                         },
//                         child: Container(
//                           width: 180.0,
//                           height: 60.0,
//                           margin: EdgeInsets.symmetric(horizontal: 4.0),
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage('assets/images/${item['subString']}.png'),
//                               fit: BoxFit.contain, // Use cover or fit based on your needs
//                             ),
//                             borderRadius: BorderRadius.circular(8.0),
//                             color: Colors.transparent, // Ensure the background is transparent
//                           ),
//                           child: Center(
//                             child: Text(
//                               item['title'] ?? '',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 16, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
