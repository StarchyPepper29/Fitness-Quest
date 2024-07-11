import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvatarService {
  Future<void> beginningOfTime() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser == null) {
      print("User not logged in.");
      return;
    }

    // Define the avatar attributes
    Map<String, String> avatarData = {
      'hair': 'avatar/hair/hair2.png',
      'head': 'avatar/heads/head2.png',
      'legs': 'avatar/legs/legs1.png',
      'shoes': 'avatar/shoes/shoe2.png',
      'torso': 'avatar/torso/torso1.png',
      'userId': currentUser.uid,
    };

    // Add the document to the avatars collection
    try {
      await FirebaseFirestore.instance.collection('avatars').add(avatarData);
      print("Avatar document added successfully.");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  Future<void> initializeFitniQuest() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser == null) {
      print("User not logged in.");
      return;
    }

    // Define the fitniQuest attributes
    Map<String, dynamic> fitniQuestData = {
      'fitopians': 500,
      'proteinBars': 20,
      'questScore': 0,
      'rank': 'The New Guy',
      'level': 1,
      'caloriesBurned': 0,
      'daysTracked': 0,
      'streak': 1,
      'workoutsCompleted': 0,
      'userId': currentUser.uid,
    };

    // Add the document to the fitniQuest collection
    try {
      await FirebaseFirestore.instance
          .collection('fitniQuest')
          .add(fitniQuestData);
      print("fitniQuest document added successfully.");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  Future<void> initializeOwnedAssets() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser == null) {
      print("User not logged in.");
      return;
    }

    // Define the ownedAssets attributes
    Map<String, dynamic> ownedAssetsData = {
      'hair': ['avatar/hair/hair1.png', 'avatar/hair/hair2.png'],
      'head': ['avatar/heads/head1.png', 'avatar/heads/head2.png'],
      'legs': ['avatar/legs/legs1.png', 'avatar/legs/legs2.png'],
      'shoes': ['avatar/shoes/shoe1.png', 'avatar/shoes/shoe2.png'],
      'torso': ['avatar/torso/torso1.png', 'avatar/torso/torso2.png'],
      'multipliers': [],
      'userId': currentUser.uid,
    };

    // Add the document to the ownedAssets collection
    try {
      await FirebaseFirestore.instance
          .collection('ownedAssets')
          .add(ownedAssetsData);
      print("ownedAssets document added successfully.");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  Future<void> initializeStoryCollection() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser == null) {
      print("User not logged in.");
      return;
    }

    // Define the storyCollection attributes
    Map<String, dynamic> storyCollectionData = {
      'bossesDefeated': 0,
      'claimedDays': [],
    };

    // Set the document in the storyCollection collection
    try {
      await FirebaseFirestore.instance
          .collection('storyCollection')
          .doc(currentUser.uid)
          .set(storyCollectionData);
      print("storyCollection document set successfully.");
    } catch (e) {
      print("Error setting document: $e");
    }
  }

  Future<void> initializeAll() async {
    await beginningOfTime();
    await initializeFitniQuest();
    await initializeOwnedAssets();
    await initializeStoryCollection();
    print("All initialization functions completed.");
  }
}
