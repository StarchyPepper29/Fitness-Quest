import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoBackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pop(context);
        if (onPressed != null) onPressed();
      },
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border:
              Border.all(color: Color.fromARGB(255, 255, 131, 96), width: 2.0),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 131, 96),
          ),
        ),
      ),
    );
  }
}
