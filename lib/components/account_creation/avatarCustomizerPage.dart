import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../frontendComponents/goBackButton.dart';
import '../../frontendComponents/primaryButton.dart';

class AvatarCustomizerPage extends StatefulWidget {
  final User user;
  final Function moveToNextStep;

  AvatarCustomizerPage({required this.user, required this.moveToNextStep});

  @override
  _AvatarCustomizerPageState createState() => _AvatarCustomizerPageState();
}

class _AvatarCustomizerPageState extends State<AvatarCustomizerPage> {
  int _currentHairIndex = 0;
  int _currentHeadIndex = 0;
  int _currentTorsoIndex = 0;
  int _currentLegsIndex = 0;
  int _currentShoesIndex = 0;
  List<String> hairAssets = [];
  List<String> headAssets = [];
  List<String> torsoAssets = [];
  List<String> legsAssets = [];
  List<String> shoesAssets = [];
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
          .where('userId', isEqualTo: widget.user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot ownedAssetsSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? ownedAssetsData =
            ownedAssetsSnapshot.data() as Map<String, dynamic>?;

        setState(() {
          hairAssets = List<String>.from(ownedAssetsData?['hair'] ?? []);
          headAssets = List<String>.from(ownedAssetsData?['head'] ?? []);
          torsoAssets = List<String>.from(ownedAssetsData?['torso'] ?? []);
          legsAssets = List<String>.from(ownedAssetsData?['legs'] ?? []);
          shoesAssets = List<String>.from(ownedAssetsData?['shoes'] ?? []);
          _loading = false; // Set loading to false once assets are loaded
        });

        print(hairAssets);
        print(headAssets);
        print(torsoAssets);
        print(legsAssets);
        print(shoesAssets);
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
          .doc(widget.user.uid)
          .get();

      if (avatarData.exists) {
        Map<String, dynamic> data = avatarData.data() as Map<String, dynamic>;

        setState(() {
          _currentHairIndex = hairAssets.indexOf(data['hair']);
          _currentHeadIndex = headAssets.indexOf(data['head']);
          _currentTorsoIndex = torsoAssets.indexOf(data['torso']);
          _currentLegsIndex = legsAssets.indexOf(data['legs']);
          _currentShoesIndex = shoesAssets.indexOf(data['shoes']);
        });
      }
    } catch (e) {
      print("Failed to load avatar: $e");
    }
  }

  void _nextHair() {
    setState(() {
      _currentHairIndex = (_currentHairIndex + 1) % hairAssets.length;
    });
  }

  void _prevHair() {
    setState(() {
      _currentHairIndex =
          (_currentHairIndex - 1 + hairAssets.length) % hairAssets.length;
    });
  }

  void _nextHead() {
    setState(() {
      _currentHeadIndex = (_currentHeadIndex + 1) % headAssets.length;
    });
  }

  void _prevHead() {
    setState(() {
      _currentHeadIndex =
          (_currentHeadIndex - 1 + headAssets.length) % headAssets.length;
    });
  }

  void _nextTorso() {
    setState(() {
      _currentTorsoIndex = (_currentTorsoIndex + 1) % torsoAssets.length;
    });
  }

  void _prevTorso() {
    setState(() {
      _currentTorsoIndex =
          (_currentTorsoIndex - 1 + torsoAssets.length) % torsoAssets.length;
    });
  }

  void _nextLegs() {
    setState(() {
      _currentLegsIndex = (_currentLegsIndex + 1) % legsAssets.length;
    });
  }

  void _prevLegs() {
    setState(() {
      _currentLegsIndex =
          (_currentLegsIndex - 1 + legsAssets.length) % legsAssets.length;
    });
  }

  void _nextShoes() {
    setState(() {
      _currentShoesIndex = (_currentShoesIndex + 1) % shoesAssets.length;
    });
  }

  void _prevShoes() {
    setState(() {
      _currentShoesIndex =
          (_currentShoesIndex - 1 + shoesAssets.length) % shoesAssets.length;
    });
  }

  void _saveAvatar() {
    FirebaseFirestore.instance.collection('avatars').doc(widget.user.uid).set({
      'userId': widget.user.uid,
      'hair': hairAssets[_currentHairIndex],
      'head': headAssets[_currentHeadIndex],
      'torso': torsoAssets[_currentTorsoIndex],
      'legs': legsAssets[_currentLegsIndex],
      'shoes': shoesAssets[_currentShoesIndex],
    });
    widget.moveToNextStep();
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
                              shoesAssets[_currentShoesIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 133,
                          child: Container(
                            height: 120,
                            child: Image.asset(
                              legsAssets[_currentLegsIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 59,
                          child: Container(
                            height: 123,
                            child: Image.asset(
                              torsoAssets[_currentTorsoIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          child: Container(
                            height: 60,
                            child: Image.asset(
                              headAssets[_currentHeadIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 43,
                            child: Image.asset(
                              hairAssets[_currentHairIndex],
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
            fontFamily: 'Aristotelica',
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
