//
// Calories Banner (Calories Left)

import 'package:flutter/material.dart';

class CustomBanner3 extends StatelessWidget {
  final String text1;
  final String text2;
  final Color bannerColor;
  final Color shadowColor;

  const CustomBanner3({
    Key? key,
    required this.text1,
    required this.text2,
    required this.bannerColor,
    required this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 100.0, // Hardcoded height for the banner
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1.5,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  28.0, 10.0, 0.0, 6.0), // Added more padding to the left
              child: Center(
                // Center the text vertically
                child: Text(
                  text1,
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontFamily: 'Aristotellica',
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 131, 96),
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0.0, 8.0, 32.0, 8.0), // Added more padding to the right
              child: Center(
                // Center the text vertically
                child: Stack(
                  children: [
                    // Stroke text
                    Text(
                      text2,
                      style: TextStyle(
                        fontSize: 35.0,
                        fontFamily: 'Pines',
                        fontWeight: FontWeight.w600,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = Color.fromARGB(255, 85, 85, 85),
                        height: 1.0,
                      ),
                    ),
                    // Main text
                    Text(
                      text2,
                      style: const TextStyle(
                        fontSize: 35.0,
                        fontFamily: 'Pines',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
