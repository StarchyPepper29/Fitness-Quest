import 'package:fitnessquest_v1/components/timer/timeHandler.dart';
import 'package:fitnessquest_v1/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './initRouteHandler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './frontendComponents/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  User? user = FirebaseAuth.instance.currentUser;

  // Ensuring the user is correctly initialized and TimeHandler is started
  if (user != null) {
    // final timeHandler = TimeHandler(user);
    // timeHandler.start();
  } else {
    debugPrint('No user is currently signed in.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/init': (context) => InitRoute(),
      },
      initialRoute: '/',
    );
  }
}
