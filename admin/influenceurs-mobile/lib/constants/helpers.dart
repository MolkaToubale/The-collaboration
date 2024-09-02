import 'dart:math';

import 'package:flutter/material.dart';


abstract class Helpers{
  static final random=Random();
  
  static String randomPictureUrl(){
    final randomInt=random.nextInt(1000);
    return 'http://picsum.photos/seed/$randomInt/300/300';
  }

  static DateTime randomDate(){
    final random=Random();
    final currentDate=DateTime.now();
    return currentDate.subtract(Duration(seconds:random.nextInt(200000)));
  }

}

const white = Colors.white;
const black = Colors.black87;
const hyperlinkColor = Color(0xFF00376B);
const secondaryColor = Color(0xFFDBDBDB);
const secondaryDarkColor = Color(0xFF8E8E8E);

// final buttonDecoration = BoxDecoration(
//   color: white,
//   border: Border.all(
//     color: secondaryColor,
//     width: 0.8,
//   ),
//   borderRadius: BorderRadius.circular(4),
// );


