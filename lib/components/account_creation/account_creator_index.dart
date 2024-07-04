import 'package:flutter/material.dart';
import '../../services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../dietlogger/caloricCalc.dart';

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Step Form'),
        ),
        body: currentStep == 0
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
                        resetForm: resetForm,
                        firestoreService: firestoreService,
                      ),
      ),
    );
  }

  void moveToNextStep() {
    setState(() {
      errorMessage = '';
    });

    if (currentStep == 0 && !validateStep1()) {
      setState(() {
        errorMessage = 'Please fill out all fields in Step 1';
      });
      return;
    } else if (currentStep == 1 && !validateStep2()) {
      setState(() {
        errorMessage = 'Please fill out all fields in Step 2';
      });
      return;
    } else if (currentStep == 2 && !validateStep3()) {
      setState(() {
        errorMessage = 'Please fill out all fields in Step 3';
      });
      return;
    }

    setState(() {
      currentStep += 1;
    });
  }

  bool validateStep1() {
    return nameController.text.isNotEmpty &&
        nickController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        gender.isNotEmpty;
  }

  bool validateStep2() {
    return weightController.text.isNotEmpty && heightController.text.isNotEmpty;
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Enter Name'),
          ),
          TextField(
            controller: nickController,
            decoration: const InputDecoration(labelText: 'Enter Nick'),
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(labelText: 'Enter Age'),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<String>(
            value: gender,
            onChanged: setGender,
            decoration: const InputDecoration(
              labelText: 'Select Gender',
              border: OutlineInputBorder(),
            ),
            items: <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => moveToNextStep(),
            child: const Text('Next'),
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
  final String errorMessage;

  const Step2({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.moveToNextStep,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: weightController,
            decoration: const InputDecoration(labelText: 'Enter Weight'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: heightController,
            decoration: const InputDecoration(labelText: 'Enter Height'),
            keyboardType: TextInputType.number,
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => moveToNextStep(),
            child: const Text('Next'),
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
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField<String>(
            value: activityLevel,
            onChanged: setActivityLevel,
            decoration: const InputDecoration(
              labelText: 'Select Activity Level',
              border: OutlineInputBorder(),
            ),
            items: <String>['Sedentary', 'Moderate', 'Active', 'Very Active']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Needs Dumbell: '),
              Switch(
                value: needsDumbell,
                onChanged: setNeedsDumbell,
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: difficulty,
            onChanged: setDifficulty,
            decoration: const InputDecoration(
              labelText: 'Select Difficulty',
              border: OutlineInputBorder(),
            ),
            items: <String>['Beginner', 'Intermediate', 'Advanced']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: goal,
            onChanged: setGoal,
            decoration: const InputDecoration(
              labelText: 'Select Goal',
              border: OutlineInputBorder(),
            ),
            items: <String>['Lose weight', 'Gain weight', 'Maintain weight']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => moveToNextStep(),
            child: const Text('Next'),
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
    required this.resetForm,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Name: $name'),
          Text('Nick: $nick'),
          Text('Age: $age'),
          Text('Weight: $weight'),
          Text('Height: $height'),
          Text('Activity Level: $activityLevel'),
          Text('Needs Dumbell: $needsDumbell'),
          Text('Difficulty: $difficulty'),
          Text('Gender: $gender'),
          Text('Goal: $goal'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
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
              firestoreService
                  .addUser(
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
              )
                  .then((_) {
                resetForm(context);
              }).catchError((error) {
                // Handle error
                print('Failed to add user: $error');
              });
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }
}
