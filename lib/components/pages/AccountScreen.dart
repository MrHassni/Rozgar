import 'package:Rozgar/service/ProductApiService.dart';
import 'package:flutter/material.dart';
import 'package:Rozgar/components/models/router.dart';
import 'package:Rozgar/service/sub_api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Accountscreen extends StatelessWidget {
  








  var height, width;
  Accountscreen({super.key});

  @override
    Widget build(BuildContext context) {


// FutureBuilder<String>(
//         future: _apiService.fetchData(), // async work
//       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//       switch (snapshot.connectionState) {
//         case ConnectionState.waiting: return Text('Loading....');
//         default:
//           if (snapshot.hasError)
//             return Text('Error: ${snapshot.error}');
//          else
//         return Text('Result: ${snapshot.data}');
//       }
//     },
//     );



    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.generateRouter,
        home: Scaffold(
          
        ));
     }
}
