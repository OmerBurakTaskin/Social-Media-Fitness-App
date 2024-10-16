import 'package:flutter/material.dart';
import 'package:gym_application/custom_widgets/calendar/calender_controller.dart';
import 'package:gym_application/providers/workout_assets_provider.dart';
import 'package:provider/provider.dart';

class SelectDayCalenderElement extends StatefulWidget {
  final CalenderController calenderController;
  const SelectDayCalenderElement({super.key, required this.calenderController});

  @override
  State<SelectDayCalenderElement> createState() =>
      _SelectDayCalenderElementState();
}

class _SelectDayCalenderElementState extends State<SelectDayCalenderElement> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.calenderController.getIsSelected();
    final provider = Provider.of<WorkoutAssetsProvider>(context);
    return GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            widget.calenderController.toggleIsSelected();
            provider.setBodyPartsSelectedDays();
          });
          provider.setStepsDone();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
          height: 60,
          width: MediaQuery.sizeOf(context).width / 7,
          decoration: BoxDecoration(
              borderRadius: isSelected
                  ? const BorderRadius.all(Radius.circular(2))
                  : null,
              color: isSelected ? Colors.blue : Colors.white,
              boxShadow: isSelected
                  ? [
                      const BoxShadow(
                          color: Colors.black,
                          blurRadius: 2,
                          blurStyle: BlurStyle.solid)
                    ]
                  : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.calenderController.dayOfWeek,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 16)),
              //TextButton(onPressed: null, child: Text("Select"))
            ],
          ),
        ));
  }
}
