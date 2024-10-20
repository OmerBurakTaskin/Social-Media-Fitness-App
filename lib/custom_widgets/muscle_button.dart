import 'package:flutter/material.dart';
import 'package:gym_application/providers/workout_assets_provider.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';

class MusclePathPainter extends CustomPainter {
  String pathData;
  bool isAcitve;
  MusclePathPainter({required this.pathData, required this.isAcitve});
  @override
  void paint(Canvas canvas, Size size) {
    Path path = parseSvgPathData(pathData);
    path = path.transform(Matrix4.diagonal3Values(0.4, 0.4, 1.0).storage);

    // Ortalamak için x ve y eksenindeki offset değerlerini hesaplıyoruz
    Offset offset = Offset(
      (size.width - path.getBounds().width) / 2 - path.getBounds().left,
      (size.height - path.getBounds().height) / 2 - path.getBounds().top,
    );

    // Path'i merkezde tutmak için hesaplanan offset ile kaydırıyoruz
    path = path.shift(offset);

    final paint = Paint()
      ..color = isAcitve ? Colors.red : Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as MusclePathPainter).isAcitve != isAcitve ||
        (oldDelegate as MusclePathPainter).pathData != pathData;
  }
}

class MuscleButton extends StatelessWidget {
  final String bodyShapePath;
  final String bodyPartName;
  final String dayOfWeek;
  const MuscleButton(
      {super.key,
      required this.bodyShapePath,
      required this.bodyPartName,
      required this.dayOfWeek});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutAssetsProvider>(context);
    bool isActive = provider.isActive(bodyPartName, dayOfWeek);
    return GestureDetector(
      onTap: () {
        provider.toggleBodyPartOfDay(dayOfWeek, bodyPartName);
      },
      child: CustomPaint(
        painter: MusclePathPainter(pathData: bodyShapePath, isAcitve: isActive),
      ),
    );
  }
}
