import 'package:flutter/material.dart';
import 'package:gym_application/utils.dart';

class ProfilePicture extends StatelessWidget {
  final String userId;
  final int radius;
  const ProfilePicture({super.key, required this.userId, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProfilePictureURL(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              minRadius: radius.toDouble(),
              backgroundImage: NetworkImage(snapshot.data.toString()),
            );
          }
          return SizedBox(height: 2.0 * radius, width: 2.0 * radius);
        });
  }
}
