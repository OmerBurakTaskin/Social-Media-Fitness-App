import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym_application/body_part_paths.dart';
import 'package:gym_application/custom_widgets/muscle_button.dart';
import 'package:gym_application/providers/workout_assets_provider.dart';
import 'package:provider/provider.dart';

class FrontBody extends StatelessWidget {
  final String day;
  const FrontBody({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: 500,
          width: 280,
          child: Consumer<WorkoutAssetsProvider>(
            builder: (context, value, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 1.5),
                    child: SvgPicture.asset("assets/front_body.svg"),
                  ),
                  Align(
                    alignment: const Alignment(-0.24, -0.7),
                    child: SizedBox(
                      height: 18,
                      width: 25,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Traps",
                        bodyShapePath: BodyPartPaths.leftTrap,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.24, -0.7),
                    child: SizedBox(
                      height: 18,
                      width: 25,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Traps",
                        bodyShapePath: BodyPartPaths.rightTrap,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.405, -0.613),
                    child: SizedBox(
                      height: 30,
                      width: 35,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Shoulder",
                        bodyShapePath: BodyPartPaths.rightFrontShoulder,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.405, -0.613),
                    child: SizedBox(
                      height: 30,
                      width: 35,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Shoulder",
                        bodyShapePath: BodyPartPaths.leftFrontShoulder,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.575, -0.45),
                    child: SizedBox(
                      height: 50,
                      width: 30,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Biceps",
                        bodyShapePath: BodyPartPaths.rightBiceps,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.575, -0.45),
                    child: SizedBox(
                      height: 50,
                      width: 30,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Biceps",
                        bodyShapePath: BodyPartPaths.leftBiceps,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.248, -0.58),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Chest",
                        bodyShapePath: BodyPartPaths.rightChest,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.248, -0.58),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Chest",
                        bodyShapePath: BodyPartPaths.leftChest,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, -0.32),
                    child: SizedBox(
                      height: 120,
                      width: 60,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Abdominals",
                        bodyShapePath: BodyPartPaths.abdonminals,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.8, -0.274),
                    child: SizedBox(
                      height: 60,
                      width: 30,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Front Arm",
                        bodyShapePath: BodyPartPaths.rightFrontArm,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.8, -0.274),
                    child: SizedBox(
                      height: 60,
                      width: 30,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Front Arm",
                        bodyShapePath: BodyPartPaths.leftFrontArm,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.285, -0.37),
                    child: SizedBox(
                      height: 80,
                      width: 25,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Obliques",
                        bodyShapePath: BodyPartPaths.leftObliques,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.285, -0.37),
                    child: SizedBox(
                      height: 80,
                      width: 25,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Obliques",
                        bodyShapePath: BodyPartPaths.rightObliques,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.24, 0.185),
                    child: SizedBox(
                      height: 110,
                      width: 40,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Quads",
                        bodyShapePath: BodyPartPaths.rightQuad,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.24, 0.185),
                    child: SizedBox(
                      height: 110,
                      width: 40,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Quads",
                        bodyShapePath: BodyPartPaths.leftQuad,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.385, 0.93),
                    child: SizedBox(
                      height: 110,
                      width: 30,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Calf",
                        bodyShapePath: BodyPartPaths.frontRightCalf,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.385, 0.93),
                    child: SizedBox(
                      height: 110,
                      width: 30,
                      child: MuscleButton(
                        dayOfWeek: day,
                        bodyPartName: "Calf",
                        bodyShapePath: BodyPartPaths.frontLeftCalf,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const Text(
          "Front Body",
          style: TextStyle(),
        )
      ],
    ));
  }
}
