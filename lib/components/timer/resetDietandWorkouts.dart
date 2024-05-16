import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './timeHandler.dart';
import '../../services/firestore.dart';

void resetStuff(User user) async {
  FirestoreService().updateCheckedWorkouts(user.uid, []);
  // _checkedExerciseNames.clear();
}
