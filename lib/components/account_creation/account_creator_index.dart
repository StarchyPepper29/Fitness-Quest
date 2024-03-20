import 'package:flutter/material.dart';
import '../../services/firestore.dart';

class CreatorIndex extends StatefulWidget {
  const CreatorIndex({Key? key}) : super(key: key);

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
                        setActivityLevel: setActivityLevel,
                        moveToNextStep: moveToNextStep,
                      )
                    : Step4(
                        name: nameController.text,
                        nick: nickController.text,
                        age: ageController.text,
                        weight: weightController.text,
                        height: heightController.text,
                        activityLevel: activityLevel,
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

  void resetForm() {
    setState(() {
      nameController.clear();
      nickController.clear();
      ageController.clear();
      weightController.clear();
      heightController.clear();
      activityLevel = 'Moderate';
      currentStep = 0;
    });
  }

  void setActivityLevel(String? value) {
    setState(() {
      activityLevel =
          value ?? 'Moderately Active'; // Set to default if value is null
    });
  }
}

class Step1 extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController nickController;
  final TextEditingController ageController;
  final Function moveToNextStep;

  const Step1({
    Key? key,
    required this.nameController,
    required this.nickController,
    required this.ageController,
    required this.moveToNextStep,
  }) : super(key: key);

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
    Key? key,
    required this.weightController,
    required this.heightController,
    required this.moveToNextStep,
  }) : super(key: key);

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
  final Function(String?) setActivityLevel;
  final Function moveToNextStep;

  const Step3({
    Key? key,
    required this.activityLevel,
    required this.setActivityLevel,
    required this.moveToNextStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: activityLevel,
            onChanged: (value) => setActivityLevel(value),
            items: <String>['Sedentary', 'Moderate', 'Active', 'Very Active']
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
  final String name;
  final String nick;
  final String age;
  final String weight;
  final String height;
  final String activityLevel;
  final Function resetForm;
  final FirestoreService firestoreService;

  const Step4({
    Key? key,
    required this.name,
    required this.nick,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.resetForm,
    required this.firestoreService,
  }) : super(key: key);

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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              firestoreService
                  .addUser(name, nick, age, weight, height, activityLevel)
                  .then((_) {
                // User added successfully, you can perform any additional actions here
                resetForm();
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
