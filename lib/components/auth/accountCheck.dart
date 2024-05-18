import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/account_creation/account_creator_index.dart';
import '../../screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeOrAccount extends StatelessWidget {
  final User user;

  const HomeOrAccount({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: userExists(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return HomePage(user: user); // Use HomePage widget
          } else {
            return CreatorIndex(user: user);
          }
        }
      },
    );
  }
}

Future<bool> userExists(String userId) async {
  try {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print('Checking user document for $userId');
    // Reference to the user document using the user's UID
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      print('User document $userId found');
    } else {
      print('User document $userId not found');
    }
    return querySnapshot.docs.isNotEmpty;
  } catch (error) {
    // Error occurred while fetching the document
    print('Error checking user document: $error');
    return false;
  }
}
