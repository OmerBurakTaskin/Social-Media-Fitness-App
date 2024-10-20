import 'package:flutter/material.dart';
import 'package:gym_application/custom_widgets/calendar/calender_controller.dart';
import 'package:gym_application/custom_widgets/calendar/select_day_calender.dart';

class SelectWorkoutDaysPage extends StatefulWidget {
  const SelectWorkoutDaysPage({super.key});

  @override
  State<SelectWorkoutDaysPage> createState() => _SelectWorkoutDaysPageState();
}

class _SelectWorkoutDaysPageState extends State<SelectWorkoutDaysPage> {
  final List<Widget> calenderElements = List.generate(
      7,
      (index) => SelectDayCalenderElement(
          calenderController: CalenderController(day: index)));

  List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Select your workout plan",
            style: TextStyle(
                color: Color.fromARGB(255, 225, 221, 221), fontSize: 30),
          ),
          Column(
            children: [
              Container(
                height: 25,
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.5),
                        topRight: Radius.circular(12.5))),
                child: const Center(
                  child: Text(
                    "Select your workout days:",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: calenderElements, // constructs a calender
              ),
            ],
          ),
          Column(
            children: [
              const Text("Selected days:",
                  style: TextStyle(
                      color: Color.fromARGB(255, 225, 221, 221), fontSize: 20)),
              SizedBox(
                height: 300,
                width: 150,
                child: AnimatedList(
                  key: CalenderController.animatedListKey,
                  initialItemCount: CalenderController.getSelectedDays.length,
                  itemBuilder: (context, index, animation) {
                    return _buildAnimatedItem(context,
                        CalenderController.getSelectedDays[index], animation);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedItem(
      BuildContext context, String day, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(
              -0.3, 0.0), // Yandan kayarak giriş için başlangıç pozisyonu
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
      ),
      child: FadeTransition(
        opacity: animation.drive(
          Tween<double>(
            begin: 0.0, // Başlangıç opaklığı
            end: 1.0, // Bitiş opaklığı
          ).chain(CurveTween(curve: Curves.easeInOutSine)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 10),
          child: Text(
            day,
            style: const TextStyle(color: Colors.blue, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
