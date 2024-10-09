import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';

class BackgroundProvider extends ChangeNotifier {
  static Color _backgroundColor = themeColor1;

  Color get backgroundColor => _backgroundColor;

  void changeBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }
}
