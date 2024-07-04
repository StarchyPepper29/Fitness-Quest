import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessquest_v1/services/firestore.dart';
import '../../frontendComponents/primaryButtonMain.dart';
import '../../frontendComponents/customBanner2.dart';
import '../../frontendComponents/goBackButton.dart';

class EditGoals extends StatefulWidget {
  final User user;
  final String? currentActivity;
  final String? currentDifficulty;
  final String? currentGoal;
  final String? currentHeight;
  final String? currentWeight;
  final bool? currentNeedsDumbell;

  const EditGoals({
    Key? key,
    required this.user,
    this.currentActivity,
    this.currentDifficulty,
    this.currentGoal,
    this.currentHeight,
    this.currentWeight,
    this.currentNeedsDumbell,
  }) : super(key: key);

  @override
  _EditGoalsState createState() => _EditGoalsState();
}

class _EditGoalsState extends State<EditGoals> {
  final _formKey = GlobalKey<FormState>();
  late String? activityLevel;
  late String? difficulty;
  late String? goal;
  late String? height;
  late String? weight;
  late String? needsDumbell;

  @override
  void initState() {
    super.initState();
    activityLevel = widget.currentActivity ?? 'Sedentary';
    difficulty = widget.currentDifficulty ?? 'Beginner';
    goal = widget.currentGoal ?? 'Lose weight';
    height = widget.currentHeight ?? '';
    weight = widget.currentWeight ?? '';
    needsDumbell = widget.currentNeedsDumbell != null
        ? (widget.currentNeedsDumbell! ? 'Yes' : 'No')
        : 'No';
  }

  Future<void> updateUserGoals() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        FirestoreService firestoreService = FirestoreService();
        await firestoreService.updateUser(
          widget.user.uid,
          activityLevel: activityLevel,
          difficulty: difficulty,
          goal: goal,
          height: height,
          weight: weight,
          needsDumbell: needsDumbell == 'Yes',
        );
        Navigator.pop(context);
      } catch (error) {
        print('Error updating user Goals: $error');
      }
    }
  }

  Widget buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Aristotellica',
            fontSize: 22.0,
            color: Color.fromARGB(255, 255, 131, 96),
          ),
        ),
        SizedBox(height: 4.0),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(255, 131, 96, 1.0),
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(255, 131, 96, 1.0),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(255, 131, 96, 1.0),
                width: 2.0,
              ),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontFamily: 'Pines'),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required String initialValue,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Aristotellica',
            fontSize: 22.0,
            color: Color.fromARGB(255, 255, 131, 96),
          ),
        ),
        SizedBox(height: 4.0),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(255, 131, 96, 1.0),
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(255, 131, 96, 1.0),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(255, 131, 96, 1.0),
                width: 2.0,
              ),
            ),
          ),
          style: TextStyle(fontFamily: 'Pines'),
          onSaved: onSaved,
          validator: validator,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 36.0),
                CustomBanner2(
                  text: 'Edit Goals',
                  imageUrl: 'images/LoginDrawing.png',
                  textColor: Color.fromARGB(255, 255, 131, 96),
                  bannerColor: Color.fromARGB(255, 255, 239, 160),
                  shadowColor: Color.fromARGB(255, 255, 131, 96),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10.0),
                        buildDropdownField(
                          label: 'Activity Level',
                          value: activityLevel!,
                          items: [
                            'Sedentary',
                            'Moderate',
                            'Active',
                            'Very Active'
                          ],
                          onChanged: (value) {
                            setState(() {
                              activityLevel = value;
                            });
                          },
                          onSaved: (value) => activityLevel = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select an Activity Level'
                              : null,
                        ),
                        buildDropdownField(
                          label: 'Difficulty',
                          value: difficulty!,
                          items: ['Beginner', 'Intermediate', 'Advanced'],
                          onChanged: (value) {
                            setState(() {
                              difficulty = value;
                            });
                          },
                          onSaved: (value) => difficulty = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select a Difficulty'
                              : null,
                        ),
                        buildDropdownField(
                          label: 'Goal',
                          value: goal!,
                          items: [
                            'Lose weight',
                            'Gain weight',
                            'Maintain weight'
                          ],
                          onChanged: (value) {
                            setState(() {
                              goal = value;
                            });
                          },
                          onSaved: (value) => goal = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select a Goal'
                              : null,
                        ),
                        buildTextField(
                          label: 'Height',
                          initialValue: height!,
                          onSaved: (value) => height = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a Height' : null,
                        ),
                        buildTextField(
                          label: 'Weight',
                          initialValue: weight!,
                          onSaved: (value) => weight = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a Weight' : null,
                        ),
                        buildDropdownField(
                          label: 'Needs Dumbell',
                          value: needsDumbell!,
                          items: ['Yes', 'No'],
                          onChanged: (value) {
                            setState(() {
                              needsDumbell = value;
                            });
                          },
                          onSaved: (value) => needsDumbell = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select if you need dumbbell'
                              : null,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: PrimaryButtonMain(
                    label: 'Done',
                    onPressed: updateUserGoals,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoBackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
