import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/common/bottomNavBar.dart';
import '../components/timer/timeHandler.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(user: user);
  }
}
