import 'package:flutter/material.dart';
import 'package:gym_application/providers/workout_assets_provider.dart';
import 'package:provider/provider.dart';

class BMIIndexCalculator extends StatefulWidget {
  const BMIIndexCalculator({super.key});

  @override
  State<BMIIndexCalculator> createState() => _BMIIndexCalculatorState();
}

class _BMIIndexCalculatorState extends State<BMIIndexCalculator> {
  final _weightTextFieldController = TextEditingController();
  final _heightTextFieldController = TextEditingController();
  double _padding = 0;
  double _bmiIndex = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutAssetsProvider>(context);
    return Container(
      height: 300,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 60,
                child: TextField(
                  onChanged: (value) => onchange(),
                  keyboardType: TextInputType.number,
                  controller: _heightTextFieldController,
                  style: TextStyle(color: Colors.white),
                  maxLength: 3,
                  decoration: const InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Height (cm)",
                    contentPadding: EdgeInsets.only(left: 5),
                    border: null,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              SizedBox(
                width: 150,
                height: 60,
                child: TextField(
                  onChanged: (value) {
                    onchange();
                  },
                  keyboardType: TextInputType.number,
                  controller: _weightTextFieldController,
                  style: const TextStyle(color: Colors.white),
                  maxLength: 4,
                  decoration: const InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Weight (kg)",
                    contentPadding: EdgeInsets.only(left: 5),
                    border: null,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Stack(alignment: Alignment.centerLeft, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BMIIndexContainer("Under \nWeight", Colors.blue),
                    BMIIndexContainer("Normal", Colors.green),
                    BMIIndexContainer("Pre \nObesity", Colors.orangeAccent),
                    BMIIndexContainer("Over\nWeight", Colors.deepOrange),
                    BMIIndexContainer("Obese ", Colors.red),
                  ],
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(left: _padding),
                  duration: const Duration(milliseconds: 200),
                  child: Container(height: 70, width: 4, color: Colors.white),
                )
              ]),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your BMI index is:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Text(
            "${provider.getBMIIndex.toStringAsFixed(2)}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          )
        ],
      ),
    );
  }

  Widget BMIIndexContainer(String boxText, Color color) {
    return Container(
        height: 50,
        width: MediaQuery.sizeOf(context).width / 5 - 4,
        decoration: BoxDecoration(color: color),
        child: Center(
            child: Text(
          boxText,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        )));
  }

  void onchange() {
    final provider = Provider.of<WorkoutAssetsProvider>(context, listen: false);
    provider.setStepsDone();
    double padding = 0;
    double bmi = 0;
    if (_heightTextFieldController.text.trim().isNotEmpty &&
        _weightTextFieldController.text.trim().isNotEmpty) {
      provider.setHeight(double.parse(_heightTextFieldController.text.trim()));
      provider.setWeight(double.parse(_weightTextFieldController.text.trim()));
      bmi = provider.getBMIIndex;
      double containerWidth = (MediaQuery.sizeOf(context).width - 20) / 5;
      if (bmi <= 18.5) {
        padding = (bmi * containerWidth) / 18.5;
      } else if (bmi <= 25) {
        padding = ((bmi - 18.5) * containerWidth) / 6.5 + containerWidth;
      } else if (bmi <= 30) {
        padding = ((bmi - 25) * containerWidth) / 5 + containerWidth * 2;
      } else if (bmi <= 35) {
        padding = ((bmi - 30) * containerWidth) / 5 + containerWidth * 3;
      } else {
        padding = ((bmi - 35) * containerWidth) / 5 + containerWidth * 4;
      }
      if (padding > containerWidth * 5) {
        padding = containerWidth * 5 - 5;
      }
    }
    setState(() {
      _padding = padding;
    });
  }
}
