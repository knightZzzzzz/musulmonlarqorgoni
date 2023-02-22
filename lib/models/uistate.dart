import 'package:flutter/material.dart';

class UiState with ChangeNotifier {
  static bool translate = false;
  static double ayahsize = 0.5;
  static double textsize = 0.5;

  set fontSize(newValue) {
    ayahsize = newValue;
    notifyListeners();
  }

  double get fontSize => ayahsize * 36;
  double get sliderFontSize => ayahsize;

  set fontSizeText(newValue) {
    textsize = newValue;
    notifyListeners();
  }

  double get fontSizeText => textsize * 32;
  double get sliderFontSizeText => textsize;
}
