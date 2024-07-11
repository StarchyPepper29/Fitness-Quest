import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../frontendComponents/topBar.dart'; // Correct import path for TopBar
import '../../frontendComponents/shopSection.dart'; // Correct import path for AvatarShop

class AvatarShop extends StatefulWidget {
  final User user;

  const AvatarShop({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _AvatarShopState createState() => _AvatarShopState();
}

class _AvatarShopState extends State<AvatarShop> {
  int fitniPoints = 0;
  int proteinBars = 0;
  int fitopians = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void updateFitopians(int newFitopians) {
    setState(() {
      fitopians = newFitopians;
    });
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('fitniQuest')
          .doc(widget.user.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          fitniPoints = docSnapshot['questScore'] ?? 0;
          proteinBars = docSnapshot['proteinBars'] ?? 0;
          fitopians = docSnapshot['fitopians'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 131, 96, 1),
      body: Column(
        children: [
          TopBar(
            barColor: const Color.fromARGB(255, 136, 219, 119),
            shadowColor: const Color.fromARGB(255, 90, 182, 72),
            item1Label: fitniPoints.toString(),
            item1Color: Colors.white,
            item1Icon: Icons.star_rounded,
            item2Label: proteinBars.toString(),
            item2Color: Colors.white,
            item2Icon: Icons.food_bank_rounded,
            item3Label: fitopians.toString(),
            item3Color: Colors.white,
            item3Icon: Icons.emoji_people_rounded,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  ProductBox(
                    title: 'Hair',
                    type: 'hair',
                    products: [
                      {
                        'name': 'Short Hair',
                        'price': '100',
                        'imagePath': 'avatar/hair/hair1.png',
                        'description': 'Short hair for your avatar.'
                      },
                      {
                        'name': 'Long Hair',
                        'price': '300',
                        'imagePath': 'assets/images/long_hair.png',
                        'description': 'Long hair for your avatar.'
                      },
                      {
                        'name': 'Curly Hair',
                        'price': '150',
                        'imagePath': 'assets/images/curly_hair.png',
                        'description': 'Curly hair for your avatar.'
                      },
                      {
                        'name': 'Straight Hair',
                        'price': '150',
                        'imagePath': 'assets/images/straight_hair.png',
                        'description': 'Straight hair for your avatar.'
                      },
                    ],
                    user: widget.user,
                    updateFitopians: updateFitopians,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
