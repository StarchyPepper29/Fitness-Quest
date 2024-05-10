import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './components/auth/logInOrSignUpHandler.dart';
import './screens/home.dart'; // Import HomePage

class InitRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrap your InitRoute with MaterialApp
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            final User? user = snapshot.data;
            if (user == null) {
              return LoginOrSignUp(); // Use loginScreen widget
            } else {
              // User is authenticated
              return HomePage(user: user); // Use HomePage widget
            }
          }
        },
      ),
    );
  }
}
