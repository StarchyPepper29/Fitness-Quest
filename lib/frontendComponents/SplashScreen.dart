import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
          seconds: 3), // Increased to 2 seconds for slower animation
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Navigate to '/init' screen after animation completes
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('/init');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 236, 97, 97), // Set the background color of the scaffold
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Text(
            'Fitness\nQuest',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 47.0,
                fontFamily: 'Aristotellica',
                fontWeight: FontWeight.w700,
                color: Colors.white, // Text color
                height: 0.9),
          ),
        ),
      ),
    );
  }
}
