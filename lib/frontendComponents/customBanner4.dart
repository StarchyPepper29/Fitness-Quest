import 'package:flutter/material.dart';

class CustomBanner4 extends StatelessWidget {
  final String text;
  final Color bannerColor;
  final Color shadowColor;
  final Color textColor;
  final double bannerHeight;
  final Widget child; // New property to accept child widget

  const CustomBanner4({
    Key? key,
    required this.text,
    required this.textColor,
    required this.bannerColor,
    required this.shadowColor,
    required this.bannerHeight,
    required this.child, // Add this property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity, // Take the entire width of the screen
          height: bannerHeight, // Use the provided banner height
          decoration: BoxDecoration(
            color: bannerColor,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 1.5,
                blurRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Aristotellica',
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.0,
                  ),
                ),
                // Add spacing between text and child widget
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: child,
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
