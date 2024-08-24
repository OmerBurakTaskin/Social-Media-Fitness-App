import "package:flutter/material.dart";
import "package:gym_application/main.dart";
import "package:gym_application/services/authentication_service.dart";
import "package:gym_application/custom_widgets/custom_textfield.dart";
import "package:gym_application/screens/signup_screen.dart";

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
      if (AuthenticationService.emailVerified) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
      appBar: AppBar(title: Text("Gym Application")),
      body: Center(
        child: Column(
          children: [
            mailInput,
            passwordInput,
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (passwordInput.getText().isNotEmpty &&
                      mailInput.getText().isNotEmpty) {
                    try {
                      signIn(context, mailInput.getText().trim(),
                          passwordInput.getText().trim());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Too many verification mail sent. Try again later")));
                    }
                  }
                },
                child: Text("LOGIN")),
            Row(
              children: [
                TextButton(
                    onPressed: null, child: Text("Forgot Your Password?")),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen())),
                    child: Text("Sign Up")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
