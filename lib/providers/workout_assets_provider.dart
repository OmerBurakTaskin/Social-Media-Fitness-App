import 'package:flutter/material.dart';
import 'package:gym_application/custom_widgets/calendar/calender_controller.dart';

class WorkoutAssetsProvider extends ChangeNotifier {
  static Map<String, List<String>> _bodyPartsOfSelectedDays = {};
  double height = 0;
  double weight = 0;
  double BMIIndex = 0;
  int _stepsDone = 0;

  double get getHeight => height;
  double get getWeight => weight;
  double get getBMIIndex => BMIIndex;
  int get stepsDone => _stepsDone;

  Map<String, List<String>> get getBodyPartsOfSelectedDays =>
      _bodyPartsOfSelectedDays;

  static Map<String, List<String>> get BodyPartsOfSelectedDays =>
      _bodyPartsOfSelectedDays;

  bool isActive(String muscleName, String day) =>
      _bodyPartsOfSelectedDays[day] == null
          ? false
          : _bodyPartsOfSelectedDays[day]!.contains(muscleName);
  String selectedBodyParts(String day) =>
      (_bodyPartsOfSelectedDays[day] ?? []).join(", ");

  void setHeight(double height) {
    this.height = height;
    if (height > 0 && weight > 0)
      BMIIndex = weight / (height / 100 * height / 100);
    setStepsDone();
    notifyListeners();
  }

  void setWeight(double weight) {
    this.weight = weight;
    if (height > 0 && weight > 0)
      BMIIndex = weight / (height / 100 * height / 100);
    setStepsDone();
    notifyListeners();
  }

  void setStepsDone() {
    bool allValuesNonEmpty = false;
    int stepsDone = 0;
    if (BMIIndex != 0) {
      stepsDone++;
    }
    if (CalenderController.getSelectedDays.isNotEmpty) {
      stepsDone++;
    }
    for (var e in _bodyPartsOfSelectedDays.values) {
      if (e.isEmpty) {
        allValuesNonEmpty = false;
        break;
      }
      allValuesNonEmpty = true;
    }
    if (allValuesNonEmpty) {
      stepsDone++;
    }
    _stepsDone = stepsDone;
    notifyListeners();
  }

  void setBodyPartsSelectedDays() {
    final keys = _bodyPartsOfSelectedDays.keys;
    for (var selectedDay in CalenderController.getSelectedDays) {
      if (!keys.contains(selectedDay)) {
        _bodyPartsOfSelectedDays[selectedDay] = [];
      }
    }
    if (CalenderController.getSelectedDays.isEmpty) {
      _bodyPartsOfSelectedDays.clear();
    }
  }

  void toggleBodyPartOfDay(String day, String bodyPart) {
    if (_bodyPartsOfSelectedDays[day] != null) {
      if (_bodyPartsOfSelectedDays[day]!.contains(bodyPart)) {
        _bodyPartsOfSelectedDays[day]!.remove(bodyPart);
        if (_bodyPartsOfSelectedDays[day] == []) {
          _bodyPartsOfSelectedDays.remove(day);
        }
      } else {
        _bodyPartsOfSelectedDays[day]!.add(bodyPart);
      }
    } else {
      _bodyPartsOfSelectedDays[day] = [bodyPart];
    }
    setStepsDone();
    notifyListeners();
  }
}
