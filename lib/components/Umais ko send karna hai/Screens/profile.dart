import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessquest_v1/screens/editProfile.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? nick;
  String? age;
  String? gender;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserPreferences();
  }

  Future<void> fetchUserPreferences() async {
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('Fetching user preferences for ${widget.user.uid}');
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('User data found');
        Map<String, dynamic>? userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;
        print('User data: $userData');
        if (userData != null) {
          setState(() {
            age = userData['age'] ?? 'Unknown';
            gender = userData['gender'] ?? 'Unknown';
            name = userData['name'] ?? 'Unknown';
            nick = userData['nick'] ?? 'Unknown';
            isLoading = false;
          });
        }
      } else {
        print('No user data found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(
                    user: widget.user,
                    currentName: name,
                    currentNick: nick,
                    currentAge: age,
                    currentGender: gender,
                  ),
                ),
              );
              fetchUserPreferences(); // Refresh the data when returning
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  const Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                        'URL to user profile picture', // Replace this with the URL to the user's profile picture
                      ),
                      // You can also use AssetImage if the image is locally available
                      // backgroundImage: AssetImage('assets/images/profile_image.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileDetail(title: 'Name', value: name),
                  ProfileDetail(title: 'Nickname', value: nick),
                  ProfileDetail(title: 'Age', value: age),
                  ProfileDetail(title: 'Gender', value: gender),
                ],
              ),
            ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String title;
  final String? value;

  const ProfileDetail({required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? 'Unknown',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
