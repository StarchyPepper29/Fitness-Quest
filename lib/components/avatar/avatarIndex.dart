import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../frontendComponents/goBackButton.dart';
import '../../frontendComponents/primaryButton.dart';

class AvatarCustomizerPage extends StatefulWidget {
  @override
  _AvatarCustomizerPageState createState() => _AvatarCustomizerPageState();
}

class _AvatarCustomizerPageState extends State<AvatarCustomizerPage> {
  int _currentHairIndex = 0;
  int _currentHeadIndex = 0;
  int _currentTorsoIndex = 0;
  int _currentLegsIndex = 0;
  int _currentShoesIndex = 0;
  User user = FirebaseAuth.instance.currentUser!;
  List<String> hairassets = [];
  List<String> headassets = [];
  List<String> torsoassets = [];
  List<String> legsassets = [];
  List<String> shoesassets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOwnedAssets();
    _loadAvatar();
  }

  Future<void> _loadOwnedAssets() async {
    print("Loading owned assets");
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ownedAssets')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot ownedAssetsSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? ownedAssetsData =
            ownedAssetsSnapshot.data() as Map<String, dynamic>?;

        setState(() {
          hairassets = List<String>.from(ownedAssetsData?['hair'] ?? []);
          headassets = List<String>.from(ownedAssetsData?['head'] ?? []);
          torsoassets = List<String>.from(ownedAssetsData?['torso'] ?? []);
          legsassets = List<String>.from(ownedAssetsData?['legs'] ?? []);
          shoesassets = List<String>.from(ownedAssetsData?['shoes'] ?? []);
          _loading = false; // Set loading to false once assets are loaded
        });

        print(hairassets);
        print(headassets);
        print(torsoassets);
        print(legsassets);
        print(shoesassets);
      } else {
        print("No owned assets found");
        setState(() {
          _loading = false; // Set loading to false if no assets are found
        });
      }
    } catch (e) {
      print("Failed to load owned assets: $e");
      setState(() {
        _loading = false; // Set loading to false if an error occurs
      });
    }
  }

  Future<void> _loadAvatar() async {
    try {
      DocumentSnapshot avatarData = await FirebaseFirestore.instance
          .collection('avatars')
          .doc(user.uid)
          .get();

      if (avatarData.exists) {
        Map<String, dynamic> data = avatarData.data() as Map<String, dynamic>;

        setState(() {
          _currentHairIndex = hairassets.indexOf(data['hair']);
          _currentHeadIndex = headassets.indexOf(data['head']);
          _currentTorsoIndex = torsoassets.indexOf(data['torso']);
          _currentLegsIndex = legsassets.indexOf(data['legs']);
          _currentShoesIndex = shoesassets.indexOf(data['shoes']);
        });
      }
    } catch (e) {
      print("Failed to load avatar: $e");
    }
  }

  void _nextHair() {
    setState(() {
      _currentHairIndex = (_currentHairIndex + 1) % hairassets.length;
    });
  }

  void _prevHair() {
    setState(() {
      _currentHairIndex =
          (_currentHairIndex - 1 + hairassets.length) % hairassets.length;
    });
  }

  void _nextHead() {
    setState(() {
      _currentHeadIndex = (_currentHeadIndex + 1) % headassets.length;
    });
  }

  void _prevHead() {
    setState(() {
      _currentHeadIndex =
          (_currentHeadIndex - 1 + headassets.length) % headassets.length;
    });
  }

  void _nextTorso() {
    setState(() {
      _currentTorsoIndex = (_currentTorsoIndex + 1) % torsoassets.length;
    });
  }

  void _prevTorso() {
    setState(() {
      _currentTorsoIndex =
          (_currentTorsoIndex - 1 + torsoassets.length) % torsoassets.length;
    });
  }

  void _nextLegs() {
    setState(() {
      _currentLegsIndex = (_currentLegsIndex + 1) % legsassets.length;
    });
  }

  void _prevLegs() {
    setState(() {
      _currentLegsIndex =
          (_currentLegsIndex - 1 + legsassets.length) % legsassets.length;
    });
  }

  void _nextShoes() {
    setState(() {
      _currentShoesIndex = (_currentShoesIndex + 1) % shoesassets.length;
    });
  }

  void _prevShoes() {
    setState(() {
      _currentShoesIndex =
          (_currentShoesIndex - 1 + shoesassets.length) % shoesassets.length;
    });
  }

  void _saveAvatar() {
    FirebaseFirestore.instance.collection('avatars').doc(user.uid).set({
      'userId': user.uid,
      'hair': hairassets[_currentHairIndex],
      'head': headassets[_currentHeadIndex],
      'torso': torsoassets[_currentTorsoIndex],
      'legs': legsassets[_currentLegsIndex],
      'shoes': shoesassets[_currentShoesIndex],
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : Column(
              children: [
                SizedBox(height: 20.0),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          left: 1.0,
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: GoBackButton(
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 248,
                          child: Container(
                            height: 36,
                            child: Image.asset(
                              shoesassets[_currentShoesIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 133,
                          child: Container(
                            height: 120,
                            child: Image.asset(
                              legsassets[_currentLegsIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 59,
                          child: Container(
                            height: 123,
                            child: Image.asset(
                              torsoassets[_currentTorsoIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          child: Container(
                            height: 60,
                            child: Image.asset(
                              headassets[_currentHeadIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 43,
                            child: Image.asset(
                              hairassets[_currentHairIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 131, 96, 1),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 201, 87, 54),
                        spreadRadius: 2,
                        blurRadius: 0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildItemRow('Hair', _prevHair, _nextHair),
                      _buildItemRow('Head', _prevHead, _nextHead),
                      _buildItemRow('Torso', _prevTorso, _nextTorso),
                      _buildItemRow('Legs', _prevLegs, _nextLegs),
                      _buildItemRow('Shoes', _prevShoes, _nextShoes),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 201, 87, 54),
                        spreadRadius: 1.5,
                        blurRadius: 0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    onPressed: _saveAvatar,
                    label: 'Save Avatar',
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
    );
  }

  Widget _buildItemRow(String label, VoidCallback onPrev, VoidCallback onNext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildArrowButton(Icons.arrow_back, onPrev),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: 'Aristotellica',
            fontWeight: FontWeight.w600,
          ),
        ),
        _buildArrowButton(Icons.arrow_forward, onNext),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
