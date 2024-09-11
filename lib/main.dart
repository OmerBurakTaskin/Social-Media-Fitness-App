import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_application/HomePage.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/firebase_options.dart';
import 'package:gym_application/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _emailVerified = FirebaseAuth.instance.currentUser == null
      ? false
      : FirebaseAuth.instance.currentUser!.emailVerified;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: themeColor1,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor1),
        useMaterial3: true,
      ),
      home: _emailVerified ? HomePage() : LoginScreen(),
    );
  }
}
