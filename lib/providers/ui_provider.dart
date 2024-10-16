import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';

class UIProvider extends ChangeNotifier {
  static Color _backgroundColor = themeColor1;

  Color get backgroundColor => _backgroundColor;

  void changeBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  final List<String> _titles = [
    "Home",
    "Chat",
    "Find",
    /*"Body Stats",*/ "Profile"
  ];

  static String _title = "Home";
  String get title => _title;

  void changeTitle(int index) {
    _title = _titles[index];
    notifyListeners();
  }

  void changeHostTitle(String userName) async {
    _title = userName;
    notifyListeners();
  }
}
