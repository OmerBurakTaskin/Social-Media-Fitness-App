import 'package:flutter/material.dart';
import 'package:gym_application/custom_widgets/bmi_index.dart';

class UserBodyAssetsPage extends StatelessWidget {
  const UserBodyAssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20),
          child: Text(
            "Calculate your BMI index",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        BMIIndexCalculator(),
        Padding(
          padding: EdgeInsets.only(bottom: 75.0),
          child: Text(
            "BMI (Body Mass Index) is a simple calculation that uses your weight and height to estimate if you are underweight, normal weight, overweight, or obese. It helps assess your overall health, but it doesn’t measure body fat directly.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
