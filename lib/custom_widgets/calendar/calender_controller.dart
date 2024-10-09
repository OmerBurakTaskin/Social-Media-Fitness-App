import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalenderController {
  static List<String> _selectedDays = [];
  static final GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();

  static final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  bool _isSelected = false;
  int day;

  CalenderController({required this.day});

  void toggleIsSelected() async {
    _isSelected = !_isSelected;
    if (_isSelected) {
      addSelectedDay();
      addAnimatedList();
    } else {
      removeAnimatedList();
      removeSelectedDay();
    }
  }

  void addAnimatedList() {
    int itemIndex = _selectedDays.indexOf(daysOfWeek[day]);
    animatedListKey.currentState!.insertItem(itemIndex);
  }

  void removeAnimatedList() {
    int itemIndex = _selectedDays.indexOf(daysOfWeek[day]);
    animatedListKey.currentState!
        .removeItem(itemIndex, (context, animation) => Container());
  }

  void addSelectedDay() {
    _selectedDays.add(daysOfWeek[day]);
    _selectedDays
        .sort((a, b) => daysOfWeek.indexOf(a) > daysOfWeek.indexOf(b) ? 1 : -1);
  }

  void removeSelectedDay() {
    _selectedDays.remove(daysOfWeek[day]);
  }

  bool getIsSelected() {
    if (_selectedDays.contains(daysOfWeek[day])) {
      _isSelected = true;
    }
    return _isSelected;
  }

  String get dayOfWeek => daysOfWeek[day].substring(0, 2);
  static List<String> get getSelectedDays => _selectedDays;
}
