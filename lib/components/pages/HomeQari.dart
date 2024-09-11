import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:flutter/material.dart';

class HomeQari extends StatelessWidget {
  const HomeQari({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: CommonScreen(
        HeaderSection: HeaderSection(
          logoPath: 'assets/images/logo.png',
          title: 'A H K N',
          subtitle: 'Khawajgan Ba\'izat Rozgar',
          cTitle: 'Home Qari',
          titleFontSize: 24.0,
          subtitleFontSize: 14.0,
          titleColor: Colors.black,
          subtitleColor: Colors.black,
        ),
        bodyContent:  Center(child: Text('No Data Found..', style:  TextStyle(fontSize: 16, color: Colors.white, backgroundColor: Colors.red.shade900),),), //DataList(fetchData: _fetchData),
      ),
    );
  }
}