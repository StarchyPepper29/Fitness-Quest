// primaryButtonMain.dart
import 'package:flutter/material.dart';

class PrimaryButtonMain extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const PrimaryButtonMain({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Color.fromARGB(255, 255, 131, 96),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          padding: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 20),
          shadowColor: Color.fromARGB(
              255, 255, 131, 96), // Shadow color same as foreground
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Aristotellica',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
