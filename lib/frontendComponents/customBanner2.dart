import 'package:flutter/material.dart';
import './goBackButton.dart';

class CustomBanner2 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Color bannerColor;
  final Color shadowColor;
  final Color textColor;

  const CustomBanner2({
    Key? key,
    required this.text,
    required this.imageUrl,
    required this.textColor,
    required this.bannerColor,
    required this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Take the entire width of the screen
      height: 150.0, // Hardcoded height for the banner
      decoration: BoxDecoration(
        color: bannerColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1.5,
            blurRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: GoBackButton(
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     ),
          //   ),
          // ),
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
                        fontSize: 40.0,
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
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                    left: 8.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.contain,
                      height: 100.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
