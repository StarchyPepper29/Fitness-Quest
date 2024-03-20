import 'package:fitnessquest_v1/firebase_options.dart';
import 'package:flutter/material.dart';
import 'components/account_creation/account_creator_index.dart'; // Import the hello_world.dart file
import 'package:firebase_core/firebase_core.dart';
import 'screens/goals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const GoalsIndex(), // Use the HelloWorldScreen widget as the home
    );
  }
}
