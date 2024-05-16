import 'package:flutter/material.dart';
import './loginScreen.dart';
import './signupScreen.dart';

class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({super.key});

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
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLogin = false;
                  isSignUp = true;
                });
              },
              child: const Text('Sign Up'),
            ),
            if (isLogin) const loginScreen(),
            if (isSignUp) const SignUpScreen(),
          ],
        ),
      ),
    );
  }
}
