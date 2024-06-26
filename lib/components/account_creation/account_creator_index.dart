import 'package:flutter/material.dart';
import '../../services/firestore.dart';
// Import the userExists function
import 'package:firebase_auth/firebase_auth.dart';
import '../timer/timeHandler.dart';

class CreatorIndex extends StatefulWidget {
  final User user; // Add user parameter to the constructor

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
  bool needsDumbell = false; // Added attribute
  String difficulty = 'Beginner'; // Added attribute
  int currentStep = 0;

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
                moveToNextStep: moveToNextStep,
              )
            : currentStep == 1
                ? Step2(
                    weightController: weightController,
                    heightController: heightController,
                    moveToNextStep: moveToNextStep,
                  )
                : currentStep == 2
                    ? Step3(
                        activityLevel: activityLevel,
                        needsDumbell: needsDumbell,
                        difficulty: difficulty,
                        setActivityLevel: setActivityLevel,
                        setNeedsDumbell: setNeedsDumbell,
                        setDifficulty: setDifficulty,
                        moveToNextStep: moveToNextStep,
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
                        resetForm: resetForm,
                        firestoreService: firestoreService,
                      ),
      ),
    );
  }

  void moveToNextStep() {
    setState(() {
      currentStep += 1;
    });
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
      currentStep = 0;
    });
    // TimeHandler(user).start();
    Navigator.pushNamed(context, '/');
  }

  void setActivityLevel(String? value) {
    setState(() {
      activityLevel =
          value ?? 'Moderately Active'; // Set to default if value is null
    });
  }

  void setNeedsDumbell(bool value) {
    setState(() {
      needsDumbell = value;
    });
  }

  void setDifficulty(String? value) {
    setState(() {
      difficulty = value ?? 'Beginner'; // Set to default if value is null
    });
  }
}

class Step1 extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController nickController;
  final TextEditingController ageController;
  final Function moveToNextStep;

  const Step1({
    super.key,
    required this.nameController,
    required this.nickController,
    required this.ageController,
    required this.moveToNextStep,
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

  const Step2({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.moveToNextStep,
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
  final Function(String?) setActivityLevel;
  final Function(bool) setNeedsDumbell;
  final Function(String?) setDifficulty;
  final Function moveToNextStep;

  const Step3({
    super.key,
    required this.activityLevel,
    required this.needsDumbell,
    required this.difficulty,
    required this.setActivityLevel,
    required this.setNeedsDumbell,
    required this.setDifficulty,
    required this.moveToNextStep,
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
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
              )
                  .then((_) {
                // User added successfully, you can perform any additional actions here
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
