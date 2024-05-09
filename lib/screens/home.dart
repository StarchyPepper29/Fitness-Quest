import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage() : super(key: const ObjectKey('HomePage'));

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the BottomStackNavigator widget
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
