import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final Color barColor;
  final Color shadowColor;
  final String item1Label;
  final Color item1Color;
  final IconData item1Icon;
  final String item2Label;
  final Color item2Color;
  final IconData item2Icon;
  final String item3Label;
  final Color item3Color;
  final IconData item3Icon;

  const TopBar({
    Key? key,
    required this.barColor,
    required this.shadowColor,
    required this.item1Label,
    required this.item1Color,
    required this.item1Icon,
    required this.item2Label,
    required this.item2Color,
    required this.item2Icon,
    required this.item3Label,
    required this.item3Color,
    required this.item3Icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: barColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2.0,
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Icon(item1Icon, color: item1Color),
                const SizedBox(width: 5),
                Text(
                  item1Label,
                  style: TextStyle(
                    color: item1Color,
                    fontSize: 16,
                    fontFamily: 'Pines',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        item2Label,
                        style: TextStyle(
                          color: item2Color,
                          fontSize: 16,
                          fontFamily: 'Pines',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(item2Icon, color: item2Color),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        item3Label,
                        style: TextStyle(
                          color: item3Color,
                          fontSize: 16,
                          fontFamily: 'Pines',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(item3Icon, color: item3Color),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
