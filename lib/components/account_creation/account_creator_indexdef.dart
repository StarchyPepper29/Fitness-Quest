import 'package:flutter/material.dart';
import '../../frontendComponents/goBackButton.dart';
import '../../services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dietlogger/caloricCalc.dart';
import '../../screens/home.dart';

import 'package:flutter_switch/flutter_switch.dart';

class CreatorIndex extends StatefulWidget {
  final User user;

  CreatorIndex({super.key, required this.user});
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  _CreatorIndexState createState() => _CreatorIndexState();
}

class _CreatorIndexState extends State<CreatorIndex> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String activityLevel = 'Moderate';
  bool needsDumbell = false;
  String difficulty = 'Beginner';
  String gender = 'Male';
  String goal = 'Maintain weight';
  int currentStep = 0;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 35.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/fitniregister.png',
                        height: 160.0,
                        width: 160.0,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: currentStep == 0
                    ? Step1(
                        nameController: nameController,
                        nickController: nickController,
                        ageController: ageController,
                        gender: gender,
                        setGender: setGender,
                        moveToNextStep: moveToNextStep,
                        errorMessage: errorMessage,
                      )
                    : currentStep == 1
                        ? Step2(
                            weightController: weightController,
                            heightController: heightController,
                            moveToNextStep: moveToNextStep,
                            moveToPreviousStep: moveToPreviousStep,
                            errorMessage: errorMessage,
                          )
                        : currentStep == 2
                            ? Step3(
                                activityLevel: activityLevel,
                                needsDumbell: needsDumbell,
                                difficulty: difficulty,
                                goal: goal,
                                setActivityLevel: setActivityLevel,
                                setNeedsDumbell: setNeedsDumbell,
                                setDifficulty: setDifficulty,
                                setGoal: setGoal,
                                moveToNextStep: moveToNextStep,
                                moveToPreviousStep: moveToPreviousStep,
                                errorMessage: errorMessage,
                              )
                            : Step4(
                                userId: widget.userId,
                                name: nameController.text,
                                nick: nickController.text,
                                age: ageController.text,
                                weight: weightController.text,
                                height: heightController.text,
                                activityLevel: activityLevel,
                                needsDumbell: needsDumbell,
                                difficulty: difficulty,
                                gender: gender,
                                goal: goal,
                                moveToPreviousStep: moveToPreviousStep,
                                resetForm: resetForm,
                                firestoreService: firestoreService,
                              ),
              ),
            ],
          ),
          if (currentStep > 0)
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoBackButton(
                  onPressed: () {
                    moveToPreviousStep();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void moveToNextStep() {
    setState(() {
      errorMessage = '';
    });

    if (currentStep == 0 && !validateStep1()) {
      setState(() {
        errorMessage = 'Please fill out all fields correctly';
      });
      return;
    } else if (currentStep == 1 && !validateStep2()) {
      setState(() {
        errorMessage = 'Please fill out all fields correctly';
      });
      return;
    } else if (currentStep == 2 && !validateStep3()) {
      setState(() {
        errorMessage = 'Please fill out all fields';
      });
      return;
    }

    setState(() {
      currentStep += 1;
    });
  }

  void moveToPreviousStep() {
    setState(() {
      errorMessage = '';
    });

    if (currentStep > 0) {
      setState(() {
        currentStep -= 1;
      });
    }
  }

  bool validateStep1() {
    return nameController.text.isNotEmpty &&
        nickController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        gender.isNotEmpty &&
        int.tryParse(ageController.text) != null;
  }

  bool validateStep2() {
    return weightController.text.isNotEmpty &&
        int.tryParse(weightController.text) != null &&
        heightController.text.isNotEmpty &&
        int.tryParse(heightController.text) != null;
  }

  bool validateStep3() {
    return activityLevel.isNotEmpty && difficulty.isNotEmpty && goal.isNotEmpty;
  }

  void resetForm(BuildContext context) async {
    setState(() {
      nameController.clear();
      nickController.clear();
      ageController.clear();
      weightController.clear();
      heightController.clear();
      activityLevel = 'Moderate';
      needsDumbell = false;
      difficulty = 'Beginner';
      gender = 'Male';
      goal = 'Maintain weight';
      currentStep = 0;
      errorMessage = '';
    });
    // Navigator.of(context).pop();
  }

  void setActivityLevel(String? value) {
    setState(() {
      activityLevel = value ?? 'Moderately Active';
    });
  }

  void setNeedsDumbell(bool value) {
    setState(() {
      needsDumbell = value;
    });
  }

  void setDifficulty(String? value) {
    setState(() {
      difficulty = value ?? 'Beginner';
    });
  }

  void setGender(String? value) {
    setState(() {
      gender = value ?? 'Male';
    });
  }

  void setGoal(String? value) {
    setState(() {
      goal = value ?? 'Maintain weight';
    });
  }
}

class Step1 extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController nickController;
  final TextEditingController ageController;
  final String gender;
  final Function(String?) setGender;
  final Function moveToNextStep;

  final String errorMessage;

  const Step1({
    super.key,
    required this.nameController,
    required this.nickController,
    required this.ageController,
    required this.gender,
    required this.setGender,
    required this.moveToNextStep,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            style: const TextStyle(
              color: Color.fromARGB(255, 103, 103, 103),
              fontFamily: 'Pines',
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Nick',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          TextField(
            controller: nickController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            style: const TextStyle(
              color: Color.fromARGB(255, 103, 103, 103),
              fontFamily: 'Pines',
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Age',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Color.fromARGB(255, 103, 103, 103),
              fontFamily: 'Pines',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          DropdownButtonFormField<String>(
            value: gender,
            onChanged: setGender,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            items: <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Pines',
                    color: Color.fromARGB(255, 103, 103, 103),
                  ),
                ),
              );
            }).toList(),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.red,
                  fontFamily: 'Aristotellica',
                ),
              ),
            ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 201, 87, 54),
                    spreadRadius: 1.5, // Spread radius
                    blurRadius: 0, // Blur radius
                    offset: Offset(0, 3), // Offset in the x and y direction
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => moveToNextStep(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 131, 96),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Aristotellica',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Step2 extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController heightController;
  final Function moveToNextStep;
  final Function moveToPreviousStep;
  final String errorMessage;

  const Step2({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.moveToNextStep,
    required this.moveToPreviousStep,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weight kg',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          TextField(
            controller: weightController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Color.fromARGB(255, 103, 103, 103),
              fontFamily: 'Pines',
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Height cm',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          TextField(
            controller: heightController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Color.fromARGB(255, 103, 103, 103),
              fontFamily: 'Pines',
            ),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.red,
                  fontFamily: 'Aristotellica',
                ),
              ),
            ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 201, 87, 54),
                    spreadRadius: 1.5, // Spread radius
                    blurRadius: 0, // Blur radius
                    offset: Offset(0, 3), // Offset in the x and y direction
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => moveToNextStep(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 131, 96),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Aristotellica',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Step3 extends StatelessWidget {
  final String activityLevel;
  final bool needsDumbell;
  final String difficulty;
  final String goal;
  final Function(String?) setActivityLevel;
  final Function(bool) setNeedsDumbell;
  final Function(String?) setDifficulty;
  final Function(String?) setGoal;
  final Function moveToNextStep;
  final Function moveToPreviousStep;
  final String errorMessage;

  const Step3({
    super.key,
    required this.activityLevel,
    required this.needsDumbell,
    required this.difficulty,
    required this.goal,
    required this.setActivityLevel,
    required this.setNeedsDumbell,
    required this.setDifficulty,
    required this.setGoal,
    required this.moveToNextStep,
    required this.moveToPreviousStep,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Level',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          DropdownButtonFormField<String>(
            value: activityLevel,
            onChanged: setActivityLevel,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            items: <String>['Sedentary', 'Moderate', 'Active', 'Very Active']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Pines',
                    color: Color.fromARGB(255, 103, 103, 103),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          const Text(
            'Difficulty',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          DropdownButtonFormField<String>(
            value: difficulty,
            onChanged: setDifficulty,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            items: <String>['Beginner', 'Intermediate', 'Advanced']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Pines',
                    color: Color.fromARGB(255, 103, 103, 103),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          const Text(
            'Goal',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(255, 131, 96, 1.0),
              fontFamily: 'Aristotellica',
            ),
          ),
          DropdownButtonFormField<String>(
            value: goal,
            onChanged: setGoal,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
              ),
            ),
            items: <String>['Lose weight', 'Gain weight', 'Maintain weight']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Pines',
                    color: Color.fromARGB(255, 103, 103, 103),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Dumbbell',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(255, 131, 96, 1.0),
                  fontFamily: 'Aristotellica',
                ),
              ),
              const SizedBox(width: 10),
              FlutterSwitch(
                value: needsDumbell,
                onToggle: setNeedsDumbell,
                activeColor: const Color.fromRGBO(255, 230, 224, 1),
                inactiveColor: Colors.white,
                activeToggleColor: const Color.fromRGBO(255, 131, 96, 1.0),
                inactiveToggleColor: const Color.fromRGBO(255, 131, 96, 1.0),
                activeSwitchBorder: Border.all(
                  color: const Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
                inactiveSwitchBorder: Border.all(
                  color: const Color.fromRGBO(255, 131, 96, 1.0),
                  width: 2.0,
                ),
                width: 55.0,
                height: 33.0,
                toggleSize: 20.0,
              ),
            ],
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.red,
                  fontFamily: 'Aristotellica',
                ),
              ),
            ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 201, 87, 54),
                    spreadRadius: 1.5, // Spread radius
                    blurRadius: 0, // Blur radius
                    offset: Offset(0, 3), // Offset in the x and y direction
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => moveToNextStep(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 131, 96),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Aristotellica',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Step4 extends StatelessWidget {
  final String userId;
  final String name;
  final String nick;
  final String age;
  final String weight;
  final String height;
  final String activityLevel;
  final bool needsDumbell;
  final String difficulty;
  final String gender;
  final String goal;
  final Function moveToPreviousStep;
  final Function resetForm;
  final FirestoreService firestoreService;

  const Step4({
    super.key,
    required this.userId,
    required this.name,
    required this.nick,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.needsDumbell,
    required this.difficulty,
    required this.gender,
    required this.goal,
    required this.moveToPreviousStep,
    required this.resetForm,
    required this.firestoreService,
  });

  Future<bool> publishUserData(BuildContext context) async {
    try {
      // Calculate caloric needs
      double caloricNeed = calculateCaloricIntake(
        gender: gender,
        age: int.parse(age),
        weight: double.parse(weight),
        height: double.parse(height),
        activityLevel: activityLevel,
        goal: goal,
      );

      // Add user to Firestore
      await firestoreService.addUser(
        userId,
        name,
        nick,
        age,
        weight,
        height,
        activityLevel,
        needsDumbell,
        difficulty,
        gender,
        goal,
        caloricNeed, // Add caloricNeed to the addUser function call
      );

      resetForm(context);
      return true;
    } catch (error) {
      // Handle error
      print('Failed to add user: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Name: $name',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Nick: $nick',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Age: $age',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Gender: $gender',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Weight: $weight',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Height: $height',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Activity Level: $activityLevel',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Needs Dumbell: $needsDumbell',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Difficulty: $difficulty',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          Text(
            'Goal: $goal',
            style: const TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontFamily: 'Pines',
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 201, 87, 54),
                    spreadRadius: 1.5, // Spread radius
                    blurRadius: 0, // Blur radius
                    offset: Offset(0, 3), // Offset in the x and y direction
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return FutureBuilder<bool>(
                        future: publishUserData(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.data == true) {
                              return HomePage(
                                  user: FirebaseAuth.instance
                                      .currentUser!); // Navigate to HomePage if user document exists
                            } else {
                              return AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Failed to publish user data.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 131, 96),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Publish',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Aristotellica',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
