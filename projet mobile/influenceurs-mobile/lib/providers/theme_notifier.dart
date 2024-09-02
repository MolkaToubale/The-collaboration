import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../services/shared_data.dart';


class ThemeNotifier with ChangeNotifier {
  Color bgColor = lightBgColor;
  TextStyle text18 = text18black;
  TextStyle title = titleblack;
  bool darkMode = false;
  Color invertedColor = darkBgColor;
  Color navBarColor = lightnavBarColor;
  Color panelColor = lightPanelColor;

  void changeDarkMode(value) async {
    switch (value) {
      case true:
        bgColor = darkBgColor;
        panelColor = darkPanelColor;
        text18 = text18white;
        title = titleWhite;
        invertedColor = lightBgColor;
        navBarColor = darknavBarColor;

        break;
      case false:
        bgColor = lightBgColor;
        panelColor = lightPanelColor;
        text18 = text18black;
        title = titleblack;
        invertedColor = darkBgColor;
        navBarColor = lightnavBarColor;

        break;
      default:
        break;
    }
    darkMode = value;
    notifyListeners();
    DataPrefrences.setDarkMode(darkMode);
  }

  initTheme(value) {
    switch (value) {
      case true:
        bgColor = darkBgColor;
        panelColor = darkPanelColor;
        text18 = text18white;
        title = titleWhite;
        invertedColor = lightBgColor;
        navBarColor = darknavBarColor;

        break;
      case false:
        bgColor = lightBgColor;
        panelColor = lightPanelColor;
        text18 = text18black;
        title = titleblack;
        invertedColor = darkBgColor;
        navBarColor = lightnavBarColor;

        break;
      default:
        break;
    }
    darkMode = value;
  }
}
