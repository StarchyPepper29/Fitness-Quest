import 'package:flutter/material.dart';

class PowerupsShop extends StatelessWidget {
  final String powerupName;
  final String powerupDescription;
  final int powerupPrice;
  final String powerupImage;
  final Function() buyPowerup;

  const PowerupsShop({
    Key? key,
    required this.powerupName,
    required this.powerupDescription,
    required this.powerupPrice,
    required this.powerupImage,
    required this.buyPowerup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            powerupImage,
            height: 100,
          ),
          const SizedBox(height: 10),
          Text(
            powerupName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            powerupDescription,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Price: $powerupPrice',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: buyPowerup,
            child: const Text('Buy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 136, 219, 119),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
