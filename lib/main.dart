import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/firebase_options.dart';
import 'package:gym_application/screens/all_chats_screen.dart';
import 'package:gym_application/screens/start_chat_screen.dart';
import 'package:gym_application/screens/find_user_screen.dart';
import 'package:gym_application/screens/home_screen.dart';
import 'package:gym_application/screens/login_screen.dart';
import 'package:gym_application/screens/profile_screen.dart';
import 'package:gym_application/services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthenticationService.emailVerified ? MyHomePage() : LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List screens = [
    const HomeScreen(),
    AllChatsScreen(),
    const FindUserScreen(),
    ProfileScreen.host()
  ];
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBackGroundColor,
        appBar: AppBar(
          backgroundColor: darkBackGroundColor,
          title: const Text(
            "Gym Application",
            style: TextStyle(color: Colors.white),
          ),
          actions: [_index == 1 ? startChatButton() : const SizedBox()],
        ),
        body: Center(
          child: screens[_index],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color.fromARGB(255, 70, 67, 67))),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: GNav(
                onTabChange: _onTabChange,
                color: Colors.white,
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
      ),
    );
  }

  void _onTabChange(int index) {
    setState(() {
      _index = index;
    });
  }

  Widget startChatButton() {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartChatScreen(),
              ));
        },
        child: const Hero(tag: "tag-1", child: Icon(Icons.add_box_outlined)));
  }
}
