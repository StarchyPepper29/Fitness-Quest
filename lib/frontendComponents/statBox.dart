import 'package:flutter/material.dart';

class StatBox extends StatelessWidget {
  final String title;
  final List<Map<String, String>> stats;

  const StatBox({
    Key? key,
    required this.title,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Color.fromRGBO(
              248, 153, 80, 1), // Border color: rgba(248,153,80,255)
          width: 2.0,
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with orange color
          Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 40.0,
                fontFamily:
                    'Aristotellica', // Assuming 'Aristotellica' is a custom font
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(
                    255, 131, 96, 1), // Title color: rgba(255,131,96,255)
              ),
            ),
          ),
          // Divider below the title
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
