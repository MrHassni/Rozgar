// ignore: file_names
import 'package:flutter/material.dart';
class CommonScreen extends StatelessWidget {
  final Widget HeaderSection;
  final Widget bodyContent; // This will be the content below the header section

  CommonScreen({
    required this.HeaderSection,
    required this.bodyContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds.png'), // Your background image
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: <Widget>[
          HeaderSection, // Place the header section
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
              child: bodyContent, // Place the body content (e.g., API data list)
            ),
          ),
        ],
      ),
    );
  }
}
