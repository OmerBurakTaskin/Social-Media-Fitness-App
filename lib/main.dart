import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/firebase_options.dart';
import 'package:gym_application/home_page.dart';
import 'package:gym_application/providers/ui_provider.dart';
import 'package:gym_application/providers/workout_assets_provider.dart';
import 'package:gym_application/screens/get_started_screens/get_started_screen.dart';
import 'package:gym_application/screens/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  await Hive.initFlutter();
  await Hive.openBox("bodyAssets");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Widget getInitialScreen() {
    final emailVerified = FirebaseAuth.instance.currentUser == null
        ? false
        : FirebaseAuth.instance.currentUser!.emailVerified;
    final gotInitialInfo = Hive.box("bodyAssets").containsKey("workoutPlan") &&
        Hive.box("bodyAssets").containsKey("bodyInfo");
    if (emailVerified == true && gotInitialInfo == false) {
      return const GetStartedScreen();
    } else if (emailVerified == true && gotInitialInfo == true) {
      return HomePage();
    }
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutAssetsProvider()),
        ChangeNotifierProvider(create: (context) => UIProvider()),
      ],
      child: MaterialApp(
        color: themeColor1,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: themeColor1),
          useMaterial3: true,
        ),
        home: getInitialScreen(),
      ),
    );
  }
}
