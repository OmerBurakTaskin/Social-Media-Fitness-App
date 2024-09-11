import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/hero_dialog_route.dart';
import 'package:gym_application/screens/all_chats_screen.dart';
import 'package:gym_application/screens/find_user_screen.dart';
import 'package:gym_application/screens/home_screen.dart';
import 'package:gym_application/screens/host_profile_screen.dart';
import 'package:gym_application/screens/start_chat_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List screens = [
    const HomeScreen(),
    AllChatsScreen(),
    const FindUserScreen(),
    HostProfileScreen()
  ];
  List<String> titles = ["Home", "Chats", "Find User", "Profile"];
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor2,
      appBar: AppBar(
        backgroundColor: themeColor2,
        title: Text(
          titles[_index],
          style: TextStyle(color: Colors.white),
        ),
        actions: [_index == 1 ? startChatButton() : const SizedBox()],
      ),
      body: SafeArea(
        child: Center(
          child: screens[_index],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: themeColor2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: GNav(
              onTabChange: _onTabChange,
              color: themeColor4,
              activeColor: Colors.white,
              padding: const EdgeInsets.all(16),
              tabBackgroundColor: const Color.fromARGB(66, 96, 93, 93),
              gap: 10,
              tabBorderRadius: 60,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.send_rounded,
                  text: "Send",
                ),
                GButton(
                  icon: Icons.search_outlined,
                  text: "Search",
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ]),
        ),
      ),
    );
  }

  void _onTabChange(int index) {
    setState(() {
      _index = index;
    });
  }

  Widget startChatButton() {
    return Hero(
        tag: "tag-1",
        child: IconButton(
            icon: Icon(Icons.add, color: Color.fromARGB(255, 21, 64, 100)),
            onPressed: () {
              Navigator.push(context,
                  HeroDialogRoute(builder: (context) => StartChatScreen()));
            }));
  }
}
