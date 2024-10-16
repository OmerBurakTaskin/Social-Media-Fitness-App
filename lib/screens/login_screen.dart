import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:gym_application/home_page.dart";
import "package:gym_application/custom_colors.dart";
import "package:gym_application/screens/get_started_screens/get_started_screen.dart";
import "package:gym_application/services/authentication_service.dart";
import "package:gym_application/custom_widgets/custom_textfield.dart";
import "package:gym_application/screens/signup_screen.dart";
import "package:hive/hive.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var mailInput = CustomTextField(20, "Email", false);
  var passwordInput = CustomTextField(20, "Password", true);

  void signIn(BuildContext context, String email, String password) async {
    try {
      var userCredentials =
          await AuthenticationService.signinWithEmailPassword(email, password);
      if (AuthenticationService.emailVerified && Hive.isBoxOpen("bodyAssets")) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else if (AuthenticationService.emailVerified = true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GetStartedScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
          children: [
            Text("Email is not verified!"),
            TextButton(
                onPressed: AuthenticationService.sendVerificationMail,
                child: Text("Send verification mail"))
          ],
        )));
        await AuthenticationService.checkEmailVerification();
      }
      print(userCredentials);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email or password is wrong!")));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor4,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    child: Center(
                      child: Text("Welcome to Fittness App !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: themeColor2,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      color: themeColor3,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: FaIcon(FontAwesomeIcons.dumbbell,
                              size: 100, color: themeColor1),
                        ),
                        mailInput,
                        passwordInput,
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                fixedSize: WidgetStateProperty.all(Size(
                                    MediaQuery.of(context).size.width - 50,
                                    50)),
                                backgroundColor:
                                    WidgetStateProperty.all(themeColor1)),
                            onPressed: () async {
                              if (passwordInput.getText().isNotEmpty &&
                                  mailInput.getText().isNotEmpty) {
                                try {
                                  signIn(context, mailInput.getText().trim(),
                                      passwordInput.getText().trim());
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Too many verification mail sent. Try again later")));
                                }
                              }
                            },
                            child: Text(
                              "LOGIN",
                              style: TextStyle(color: themeColor4),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*TextButton(
                            onPressed: null,
                            child: Text("Forgot Your Password?")),*/
                            Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen())),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(color: themeColor4),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
