import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarView extends StatefulWidget {
  @override
  _AvatarViewState createState() => _AvatarViewState();
}

class _AvatarViewState extends State<AvatarView> {
  String _hairAsset = '';
  String _headAsset = '';
  String _torsoAsset = '';
  String _legsAsset = '';
  String _shoesAsset = '';

  @override
  void initState() {
    super.initState();
    _loadAvatarAssets();
  }

  Future<void> _loadAvatarAssets() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot avatarData = await FirebaseFirestore.instance
            .collection('avatars')
            .doc(user.uid)
            .get();

        if (avatarData.exists) {
          Map<String, dynamic> data = avatarData.data() as Map<String, dynamic>;

          setState(() {
            _hairAsset = data['hair'] ?? '';
            _headAsset = data['head'] ?? '';
            _torsoAsset = data['torso'] ?? '';
            _legsAsset = data['legs'] ?? '';
            _shoesAsset = data['shoes'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Failed to load avatar assets: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _hairAsset.isNotEmpty &&
            _headAsset.isNotEmpty &&
            _torsoAsset.isNotEmpty &&
            _legsAsset.isNotEmpty &&
            _shoesAsset.isNotEmpty
        ? Center(
            child: Container(
              width: 300, // Adjust width as per your design
              height: 300, // Adjust height as per your design
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 248 * 0.7, // Reduced size by 30%
                    child: Container(
                      height: 36 * 0.7, // Reduced size by 30%
                      child: Image.asset(
                        _shoesAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 133 * 0.7, // Reduced size by 30%
                    child: Container(
                      height: 120 * 0.7, // Reduced size by 30%
                      child: Image.asset(
                        _legsAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 59 * 0.7, // Reduced size by 30%
                    child: Container(
                      height: 123 * 0.7, // Reduced size by 30%
                      child: Image.asset(
                        _torsoAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2 * 0.7, // Reduced size by 30%
                    child: Container(
                      height: 60 * 0.7, // Reduced size by 30%
                      child: Image.asset(
                        _headAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 43 * 0.7, // Reduced size by 30%
                      child: Image.asset(
                        _hairAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child:
                CircularProgressIndicator(), // Show loading indicator if assets are not loaded
          );
  }
}
