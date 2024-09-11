import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/screens/view_profile_screen.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:gym_application/utils.dart';

class FindUserScreen extends StatefulWidget {
  const FindUserScreen({super.key});

  @override
  State<FindUserScreen> createState() => _FindUserScreenState();
}

class _FindUserScreenState extends State<FindUserScreen> {
  final TextEditingController _controller = TextEditingController();
  final UserDbService _userDbService = UserDbService();
  String wantedUserName = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_findUserContainer(), _buildFoundUsersListView()],
    );
  }

  Widget _buildFoundUsersListView() {
    return Expanded(
        child: FutureBuilder(
      future: _userDbService.getSearchedUsers(wantedUserName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.blue));
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error while loading posts!"));
        } else if (snapshot.hasData && snapshot.data != null) {
          return ListView(
              children: snapshot.data!.map((e) => _buildUserTile(e)).toList());
        } else {
          return const Center(child: Text("No user found"));
        }
      },
    ));
  }

  Container _findUserContainer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          cursorColor: const Color.fromARGB(255, 143, 139, 139),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: "Search",
            hintStyle: TextStyle(color: themeColor8, fontFamily: "arial greek"),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Icon(
                Icons.search,
                color: themeColor7,
              ),
            ),
          ),
          controller: _controller,
          onChanged: (value) {
            setState(() {
              wantedUserName = _controller.text;
            });
          },
        ),
      ),
    );
  }

  Widget _buildUserTile(User user) {
    return FutureBuilder(
        future: getProfilePictureURL(user.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error while loading posts!"));
          } else if (snapshot.hasData && snapshot.data != null) {
            String ppUrl = snapshot.data ??
                "https://i.pinimg.com/564x/bd/cc/de/bdccde33dea7c9e549b325635d2c432e.jpg";
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ppUrl),
              ),
              title: Text(user.userName,
                  style: TextStyle(color: lightGreyHeaderColor)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewProfileScreen(profileOwner: user)));
              },
            );
          } else {
            return Center(
                child: Text(
              "No user found",
              style: lightGreyTextStyle,
            ));
          }
        });
  }
}
