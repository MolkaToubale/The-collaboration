import 'package:flutter/material.dart';

class TTextFormFieldTheme {
  static InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          prefixIconColor: Colors.amber,
          floatingLabelStyle: TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(width: 2, color: Colors.blue),
          ));

  static InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          prefixIconColor: Colors.amber,
          floatingLabelStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blue),
          ));
}
