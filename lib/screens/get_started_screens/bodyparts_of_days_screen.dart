import 'package:flutter/material.dart';
import 'package:gym_application/custom_widgets/calendar/calender_controller.dart';
import 'package:gym_application/providers/workout_assets_provider.dart';
import 'package:gym_application/custom_widgets/back_body.dart';
import 'package:gym_application/custom_widgets/front_body.dart';
import 'package:provider/provider.dart';

class BodypartsOfDaysScreen extends StatefulWidget {
  const BodypartsOfDaysScreen({super.key});
  @override
  State<BodypartsOfDaysScreen> createState() => _BodypartsOfDaysScreenState();
}

class _BodypartsOfDaysScreenState extends State<BodypartsOfDaysScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final selectedDays = CalenderController.getSelectedDays;
    if (selectedDays.isEmpty) return const Text("No workout day selected.");
    final provider = Provider.of<WorkoutAssetsProvider>(context);
    return SafeArea(
        child: SingleChildScrollView(
            child: ExpansionPanelList(
                expandIconColor: Colors.white,
                expandedHeaderPadding: const EdgeInsets.all(0),
                elevation: 1,
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    _expandedIndex = isExpanded ? panelIndex : null;
                  });
                },
                children: selectedDays.map((day) {
                  return ExpansionPanel(
                      backgroundColor: Colors.transparent,
                      headerBuilder: (context, isExpanded) => ListTile(
                            iconColor: Colors.white,
                            title: Text(
                              day,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              provider.selectedBodyParts(day),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [FrontBody(day: day), BackBody(day: day)],
                        ),
                      ),
                      isExpanded: _expandedIndex == selectedDays.indexOf(day));
                }).toList())));
  }
}
