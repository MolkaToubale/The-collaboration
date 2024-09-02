
 

import 'package:flutter/material.dart';


class PrimaryText extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;

  const PrimaryText({
    this.text="",
    this.fontWeight: FontWeight.w400,
    this.color: AppColors.primary,
    this.size: 20,
    this.height: 1.3,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          color: color,
          height: height,
          fontFamily: 'Poppins',
          fontSize: size,
          fontWeight: fontWeight,
        ),);
  }
}
class AppColors {
  static const white = Colors.white;
  static const secondary = Color(0xffa6a6a6);
  static const iconGray = Color(0xff767676);
  static const black = Colors.black;
  static const primary = Color(0xff262626);
  static const primaryBg = Color(0xfff5f5fd);
  static const secondaryBg = Color(0xffececf6);
  static const barBg = Color(0xffe3e3ee);
}

