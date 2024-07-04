import 'package:flutter/material.dart';

class FeaturedItem extends StatelessWidget {
  final String itemName;
  final String itemDescription;
  final int itemPrice;
  final String itemImage;
  final Function() buyItem;

  const FeaturedItem({
    Key? key,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemImage,
    required this.buyItem,
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
            itemImage,
            height: 100,
          ),
          const SizedBox(height: 10),
          Text(
            itemName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            itemDescription,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Price: $itemPrice',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: buyItem,
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }
}