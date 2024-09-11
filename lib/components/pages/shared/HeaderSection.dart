// lib/widgets/header_section.dart
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String logoPath;
  final String title;
  final String subtitle;
  final String cTitle;
  final double titleFontSize;
  final double subtitleFontSize;
  final Color titleColor;
  final Color subtitleColor;

  HeaderSection({
    required this.logoPath,
    required this.title,
    required this.subtitle,
    required this.cTitle,
    this.titleFontSize = 22.0,
    this.subtitleFontSize = 12.0,
    this.titleColor = Colors.black,
    this.subtitleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height * 0.25,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height * 0.1,
            width: height * 0.1,
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(logoPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              color: titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: subtitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            cTitle,
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: subtitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
