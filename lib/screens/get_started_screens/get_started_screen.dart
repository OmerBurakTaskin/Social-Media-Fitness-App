import 'package:flutter/material.dart';
import 'package:gym_application/home_page.dart';
import 'package:gym_application/providers/ui_provider.dart';

import 'package:gym_application/providers/workout_assets_provider.dart';
import 'package:gym_application/screens/get_started_screens/bodyparts_of_days_screen.dart';
import 'package:gym_application/screens/get_started_screens/select_workout_days_screen.dart';
import 'package:gym_application/screens/get_started_screens/user_body_assets_screen.dart';
import 'package:gym_application/services/local_db_service.dart';
import 'package:provider/provider.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UIProvider>(context);
    return Scaffold(
      backgroundColor: provider.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _pageIndex = value;
                });
              },
              children: const [
                UserBodyAssetsScreen(),
                SelectWorkoutDaysScreen(),
                BodypartsOfDaysScreen(),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            width: MediaQuery.sizeOf(context).width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: _pageIndicator(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: _saveButton(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _pageIndicator() {
    var indicatorDots = List.generate(
      3,
      (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: 10,
          width: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: _pageIndex == index ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(5)),
        );
      },
    );
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: indicatorDots);
  }

  Widget _saveButton() {
    final provider = Provider.of<WorkoutAssetsProvider>(context);
    return SizedBox(
      width: 120,
      height: 40,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: provider.stepsDone * 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurStyle: BlurStyle.inner,
                  color: Color.fromARGB(255, 4, 81, 145),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              minimumSize: WidgetStateProperty.all(const Size(150, 60)),
            ),
            onPressed: () async {
              if (provider.stepsDone == 3) {
                Map bodyAssetsMap = {
                  "BMIIndex": provider.BMIIndex,
                  "Height": provider.getHeight,
                  "Weight": provider.getWeight
                };
                Map workoutPlan = provider.getBodyPartsOfSelectedDays;
                LocalDbService.addBoxWithSpecificKey(
                    "bodyAssets", "workoutPlan", workoutPlan);
                LocalDbService.addBoxWithSpecificKey(
                    "bodyAssets", "bodyInfo", bodyAssetsMap);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Workout plan saved!")));
                await Future.delayed(Duration(seconds: 2));
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
