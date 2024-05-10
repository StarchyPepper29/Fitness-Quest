import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/dietlogger/dietlogwidget.dart';
import '../components/common/bottomNavBar.dart';
import '../components/dietlogger/foodLog.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      // bottomNavigationBar: BottomNavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.displayName}!', // Display user's display name
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to LogDiet screen
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Diet()));
              },
              child: Text('Log Diet'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                await FirebaseAuth.instance.signOut();
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
