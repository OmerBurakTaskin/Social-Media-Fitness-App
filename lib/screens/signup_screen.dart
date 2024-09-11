import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:gym_application/custom_colors.dart";
import "package:gym_application/custom_widgets/custom_textfield.dart";
import "package:gym_application/models/user.dart" as appuser;
import "package:gym_application/screens/login_screen.dart";
import "package:gym_application/services/authentication_service.dart";
import "package:gym_application/services/user_db_service.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userDbService = UserDbService();
  final _nameTextField = CustomTextField(10, "Name", false);
  final _surNameTextField = CustomTextField(10, "Surname", false);
  final _emailTextField = CustomTextField(10, "Email", false);
  final _passwordTextField = CustomTextField(10, "Password", true);
  final _confirmPasswordTextField =
      CustomTextField(10, "Confirm Password", true);
  final _userNameTextField = CustomTextField(10, "Username", false);

  void signUp(BuildContext context, String email, String password) async {
    try {
      await AuthenticationService.signUpWithEmailPassword(email, password);
      //authentication kaydı yapıldı
      try {
        AuthenticationService.sendVerificationMail();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Verification mail is sent to your mail address.")));
        saveUserInfo(AuthenticationService.user!);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong email")));
        //print("verification mail hatası!!!!!");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This mail is already in use!")));
    }
  }

  void saveUserInfo(User user) {
    _userDbService.addUser(appuser.User(
        userId: user.uid,
        name: _nameTextField.getText(),
        surName: _surNameTextField.getText(),
        userName: _userNameTextField.getText(),
        email: _emailTextField.getText()));
  }

  @override
  void initState() {
    super.initState();
    AuthenticationService.checkEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor4,
      body: SafeArea(
        child: Center(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    SizedBox(
                      height: 170,
                      child: Center(
                        child: Text(
                          "Sign Up to Fitness App!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: themeColor3,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 5),
                          child: Column(
                            children: [
                              _nameTextField,
                              _surNameTextField,
                              _userNameTextField,
                              _emailTextField,
                              _passwordTextField,
                              _confirmPasswordTextField,
                              SizedBox(height: 20),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      fixedSize: WidgetStateProperty.all(Size(
                                          MediaQuery.of(context).size.width -
                                              50,
                                          50)),
                                      backgroundColor:
                                          WidgetStateProperty.all(themeColor1)),
                                  onPressed: () {
                                    if (_passwordTextField.getText().trim() ==
                                        _confirmPasswordTextField
                                            .getText()
                                            .trim()) {
                                      signUp(
                                          context,
                                          _emailTextField.getText().trim(),
                                          _passwordTextField.getText().trim());
                                    }
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: themeColor4, fontSize: 18),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(color: themeColor4),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
