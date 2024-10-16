import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym_application/body_part_paths.dart';
import 'package:gym_application/custom_widgets/muscle_button.dart';

class BackBody extends StatelessWidget {
  final String day;
  const BackBody({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 500,
        width: 280,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.1),
            child: SvgPicture.asset("assets/back_body.svg"),
          ),
          Align(
            alignment: Alignment(0.435, -0.62),
            child: SizedBox(
              height: 30,
              width: 35,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Shoulder",
                bodyShapePath: BodyPartPaths.rearShoulderRight,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.415, -0.62),
            child: SizedBox(
              height: 30,
              width: 35,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Shoulder",
                bodyShapePath: BodyPartPaths.rearShoulderLeft,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.592, -0.468),
            child: SizedBox(
              height: 50,
              width: 30,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Triceps",
                bodyShapePath: BodyPartPaths.leftTriceps,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.602, -0.458),
            child: SizedBox(
              height: 40,
              width: 30,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Triceps",
                bodyShapePath: BodyPartPaths.rightTriceps,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.85, -0.26),
            child: SizedBox(
              height: 70,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Forearm",
                bodyShapePath: BodyPartPaths.leftForearm,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.865, -0.26),
            child: SizedBox(
              height: 70,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Forearm",
                bodyShapePath: BodyPartPaths.rightForearm,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.01, -0.674),
            child: SizedBox(
              height: 20,
              width: 70,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Upper Back",
                bodyShapePath: BodyPartPaths.backTraps,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.00, -0.57),
            child: SizedBox(
              height: 60,
              width: 45,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Middle Back",
                bodyShapePath: BodyPartPaths.middleTraps,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.305),
            child: SizedBox(
              height: 60,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Lower Back",
                bodyShapePath: BodyPartPaths.lowerback,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.26, -0.475),
            child: SizedBox(
              height: 120,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Back Lats",
                bodyShapePath: BodyPartPaths.rightBackLat,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.25, -0.475),
            child: SizedBox(
              height: 120,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Back Lats",
                bodyShapePath: BodyPartPaths.leftBackLat,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.17, -0.052),
            child: SizedBox(
              height: 50,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Glutes",
                bodyShapePath: BodyPartPaths.leftGlute,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.18, -0.052),
            child: SizedBox(
              height: 50,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Glutes",
                bodyShapePath: BodyPartPaths.rightGlute,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.255, 0.2),
            child: SizedBox(
              height: 110,
              width: 50,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: MuscleButton(
                  dayOfWeek: day,
                  bodyPartName: "Hamstring",
                  bodyShapePath: BodyPartPaths.leftHamstring,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.25, 0.2),
            child: SizedBox(
              height: 100,
              width: 50,
              child: Padding(
                padding: EdgeInsets.only(bottom: 9.0, left: 5),
                child: MuscleButton(
                  dayOfWeek: day,
                  bodyPartName: "Hamstring",
                  bodyShapePath: BodyPartPaths.rightHamstring,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.345, 0.65),
            child: SizedBox(
              height: 40,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Calf",
                bodyShapePath: BodyPartPaths.leftCalf,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.362, 0.65),
            child: SizedBox(
              height: 40,
              width: 40,
              child: MuscleButton(
                dayOfWeek: day,
                bodyPartName: "Calf",
                bodyShapePath: BodyPartPaths.rightCalf,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
