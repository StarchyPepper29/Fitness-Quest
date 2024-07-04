import 'package:flutter/material.dart';

class featuredBanner extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Color bannerColor;
  final Color shadowColor;

  const featuredBanner({
    Key? key,
    required this.text,
    required this.imageUrl,
    required this.bannerColor,
    required this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 150.0, // Hardcoded height for the banner
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1.5,
            blurRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  32.0, 8.0, 0.0, 8.0), // Added more padding to the left
              child: Center(
                // Center the text vertically
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Aristotellica',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.asset(
              imageUrl,
              height: 140.0, // Match the height of the banner
            ),
          ),
        ],
      ),
    );
  }
}
