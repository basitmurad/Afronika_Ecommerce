import 'package:afronika/common/GButton.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../../../common/product_detail_card.dart';

class AnkaraCategoryScreen extends StatefulWidget {
  const AnkaraCategoryScreen({super.key});

  @override
  State<AnkaraCategoryScreen> createState() => _AnkaraCategoryScreenState();
}

class _AnkaraCategoryScreenState extends State<AnkaraCategoryScreen> {
  // Product data
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Polyester Duchess Satin...',
      'price': 132.00,
      'originalPrice': 156.00,
      'discount': 15,
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'colors': [Colors.red, Colors.blue, Colors.green, Colors.yellow],
      'selectedColor': Colors.red,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 2,
      'name': 'Hollandais, High Quality S...',
      'price': 142.00,
      'originalPrice': 166.00,
      'discount': 15,
      'image': 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'colors': [Colors.teal, Colors.green, Colors.orange],
      'selectedColor': Colors.teal,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 3,
      'name': 'Hollandais, High Quality S...',
      'price': 142.00,
      'originalPrice': 166.00,
      'discount': 15,
      'image': 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'colors': [Colors.teal, Colors.green, Colors.orange],
      'selectedColor': Colors.teal,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 4,
      'name': 'Hollandais, High Quality S...',
      'price': 142.00,
      'originalPrice': 166.00,
      'discount': 15,
      'image': 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'colors': [Colors.teal, Colors.green, Colors.orange],
      'selectedColor': Colors.teal,
      'isFavorite': false,
      'quantity': 1,
    },

  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ankara',
          style: AappTextStyle.roboto(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            weight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search items',
                        hintStyle: AappTextStyle.roboto(
                          color: Colors.grey,
                          fontSize: 14,
                          weight: FontWeight.w400,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: AappTextStyle.roboto(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Filters:',
                        style: AappTextStyle.roboto(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 14,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.tune,
                        color: isDark ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Products Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16, // Space between columns
                  mainAxisSpacing: 16, // Space between rows
                  childAspectRatio: 0.65, // Adjust this to control card height
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductDetailCard(
                    imageUrl: product['image'],
                    title: product['name'],
                    currentPrice: product['price'],
                    originalPrice: product['originalPrice'],
                    isDark: isDark,
                    isWishlisted: product['isFavorite'],
                    onWishlistPressed: () {
                      setState(() {
                        products[index]['isFavorite'] = !products[index]['isFavorite'];
                      });
                    },
                    onAddToCart: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product['name']} added to cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}