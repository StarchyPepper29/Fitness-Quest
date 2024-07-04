import 'package:flutter/material.dart';

class CustomBanner2 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Color bannerColor;
  final Color strokeColor; // New property for stroke color
  final Color textColor;

  const CustomBanner2({
    Key? key,
    required this.text,
    required this.imageUrl,
    required this.textColor,
    required this.bannerColor,
    required this.strokeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Take the entire width of the screen
      height: 150.0, // Hardcoded height for the banner
      decoration: BoxDecoration(
        color: bannerColor,
        border: Border(
          top: BorderSide(color: strokeColor, width: 2.0), // Top stroke
          bottom: BorderSide(color: strokeColor, width: 2.0), // Bottom stroke
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 8.0, 0.0, 8.0),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 50.0,
                        fontFamily: 'Aristotellica',
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Image.asset(
                  imageUrl,
                  height: 800.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
