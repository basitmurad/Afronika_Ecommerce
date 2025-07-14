import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:flutter/material.dart';

import '../../../common/product_card.dart';
import '../../../common/wishlistCard.dart';
import '../../../utils/device/device_utility.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Text(
          'Wishlist',
          style: AappTextStyle.roboto(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18.0,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          WishlistCard(
            imagePath: GImagePath.image1,
            title: 'Wireless Headphones',
            price: '\$59.99',
            isDark: isDark, onAddToCart: () {  }, onRemoveFromWishlist: () {  },
          ),
          const SizedBox(height: 16),
          WishlistCard(
            imagePath: GImagePath.image1,
            title: 'Wireless Headphones',
            price: '\$59.99',
            isDark: isDark, onAddToCart: () {  }, onRemoveFromWishlist: () {  },
          ),

        ],
      ),
    );
  }
}
