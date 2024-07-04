import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './avatarShop.dart';
import './featuredItem.dart';
import './powerupsShop.dart';
import '../../frontendComponents/topBar.dart';
import '../../frontendComponents/goBackButton.dart'; // Import the custom GoBackButton

class Shop extends StatefulWidget {
  final User user;

  const Shop({Key? key, required this.user}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  int fitniPoints = 0;
  int proteinBars = 0;
  int fitopians = 0;

  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  Future<void> fetchShopData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('fitniQuest')
          .doc(widget.user.uid)
          .get();

      if (docSnapshot.exists) {
        int fitniScore = docSnapshot['questScore'];
        int fitniProteinBars = docSnapshot['proteinBars'];
        int fitniFitopians = docSnapshot['fitopians'];
        setState(() {
          fitniPoints = fitniScore;
          proteinBars = fitniProteinBars;
          fitopians = fitniFitopians;
        });
        print('Shop Data Fetched: $fitniPoints, $proteinBars, $fitopians');
      }
    } catch (e) {
      print('Error fetching shop data: $e');
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
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width +
                            100, // Extra width
                        height: MediaQuery.of(context).size.height /
                            3, // Height proportionate to screen
                        child: Image.asset(
                          'images/shopBanner.png', // Replace with your actual title banner asset path
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10, // Adjust according to your design
                        left: 10, // Adjust according to your design
                        child: GoBackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Decreased padding
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeaturedItem(
                              itemName: 'Featured Item Name',
                              itemDescription: 'Featured Item Description',
                              itemPrice: 100,
                              itemImage:
                                  'images/featuredBanner.png', // Replace with your actual featured item asset path
                              buyItem: () {
                                print('Featured Item Bought');
                              },
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'images/featuredBanner.png', // Replace with your actual featured item banner asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Decreased padding
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarShop(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'images/avatarBanner.png', // Replace with your actual avatar shop banner asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Decreased padding
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PowerupsShop(
                              powerupName: 'Powerup Name',
                              powerupDescription: 'Powerup Description',
                              powerupPrice: 100,
                              powerupImage:
                                  'assets/powerups/powerup.png', // Replace with your actual powerup asset path
                              buyPowerup: () {
                                print('Powerup Bought');
                              },
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'images/powerupbanner.png', // Replace with your actual powerup shop banner asset path
                        fit: BoxFit.cover,
                      ),
                    ),
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
