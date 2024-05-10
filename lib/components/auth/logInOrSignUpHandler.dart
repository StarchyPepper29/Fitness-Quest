import 'package:flutter/material.dart';
import './loginScreen.dart';
import './signupScreen.dart';

class LoginOrSignUp extends StatefulWidget {
  @override
  _LoginOrSignUpState createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool isLogin = true;
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLogin = true;
                  isSignUp = false;
                });
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLogin = false;
                  isSignUp = true;
                });
              },
              child: Text('Sign Up'),
            ),
            if (isLogin) loginScreen(),
            if (isSignUp) SignUpScreen(),
          ],
        ),
      ),
    );
  }
}
