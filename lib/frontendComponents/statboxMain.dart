import 'package:flutter/material.dart';

class StatBoxMain extends StatelessWidget {
  final String title;
  final List<Map<String, String>> stats;

  const StatBoxMain({
    Key? key,
    required this.title,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color.fromRGBO(
            255, 239, 160, 1), // Background color: rgba(255,239,160,255)
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 131, 96,
                1), // Shadow color: rgba(255,131,96,255) with opacity
            offset: Offset(0, 5), // Offset of the shadow
            blurRadius: 0.0, // Blur radius of the shadow
            spreadRadius: 0.0, // Spread radius of the shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title with orange color
          Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 45.0,
                fontFamily:
                    'Aristotellica', // Assuming 'Aristotellica' is a custom font
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(
                    255, 131, 96, 1), // Title color: rgba(255,131,96,255)
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Divider
          Container(
            height: 2.4,
            color: Color.fromRGBO(
                248, 153, 80, 1), // Divider color: rgba(248,153,80,255)
            margin: EdgeInsets.only(bottom: 8.0),
          ),
          // Stats rows
          Column(
            children: stats.map((stat) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stat['name'] ?? '',
                    style: TextStyle(
                      fontSize: 21.0,
                      fontFamily: 'Pines', // Assuming 'Pines' is a custom font
                      color: Color.fromRGBO(68, 74, 79,
                          1), // Stats font color: rgba(68,74,79,255)
                    ),
                  ),
                  Text(
                    stat['value'] ?? '',
                    style: TextStyle(
                      fontSize: 21.0,
                      fontFamily: 'Pines', // Assuming 'Pines' is a custom font
                      color: Color.fromRGBO(68, 74, 79,
                          1), // Stats font color: rgba(68,74,79,255)
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
