import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './components/auth/logInOrSignUpHandler.dart';
// Import HomePage
import './components/auth/accountCheck.dart';

class InitRoute extends StatelessWidget {
  const InitRoute({Key? key}) : super(key: key);

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
              return const LoginOrSignUp(); // Use loginScreen widget
            } else {
              return FutureBuilder<bool?>(
                future: checkUserExists(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return HomeOrAccount(user: user);
                  }
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<bool?> checkUserExists(String userId) async {
    try {
      final bool exists = await userExists(userId);
      return exists;
    } catch (error) {
      // Handle error
      print('Error checking user existence: $error');
      return false;
    }
  }
}
