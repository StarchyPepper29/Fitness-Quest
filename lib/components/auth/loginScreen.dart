import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20.0), // Spacer for the image
          Image.asset(
            'images/LoginDrawing.png', // Replace with your image path
            height: 80.0,
            width: 80.0,
          ),
          const SizedBox(height: 20.0), // Spacer between image and form
          Text('Login', style: TextStyle(fontSize: 24.0)),
          const SizedBox(height: 20.0), // Spacer between text and form
          LoginForm(),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8360)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onChanged: (value) {
              _email = value;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8360)),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            onChanged: (value) {
              _password = value;
            },
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Pass the BuildContext to loginFunction
                loginFunction(context, _email, _password);
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void loginFunction(BuildContext context, String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User logged in successfully!');
    // Navigate to home or another screen upon successful login
    // Navigator.of(context).pushReplacementNamed('/home');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showErrorDialog(context, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      showErrorDialog(context, 'Wrong password provided for that user.');
    } else {
      showErrorDialog(context, 'Error: ${e.message}');
    }
  } catch (e) {
    showErrorDialog(context, 'Error: $e');
  }
}
