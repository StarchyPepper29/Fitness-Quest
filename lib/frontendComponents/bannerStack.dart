import 'package:flutter/material.dart';
import './shopBanner.dart';

class shopBanner extends StatefulWidget {
  const shopBanner({super.key});

  @override
  State<shopBanner> createState() => _shopBannerState();
}

class _shopBannerState extends State<shopBanner> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBanner2(
          text: 'Shop',
          imageUrl: 'assets/images/shopBanner.png',
          textColor: const Color.fromARGB(255, 255, 255, 255),
          bannerColor: const Color.fromARGB(255, 136, 219, 119),
          strokeColor: const Color.fromARGB(255, 90, 182, 72),
        ),
        Positioned(child: Image.asset('images/ShopKeeper.png'), top: 10),
      ],
    );
  }
}
