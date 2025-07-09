import 'package:afronika/common/GButton.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

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
      'image': 'assets/images/ankara1.jpg',
      'colors': [Colors.red, Colors.blue, Colors.green, Colors.yellow],
      'selectedColor': Colors.red,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 2,
      'name': 'Hollandais, High Quality S...',
      'price': 132.00,
      'originalPrice': 156.00,
      'discount': 15,
      'image': 'assets/images/ankara2.jpg',
      'colors': [Colors.teal, Colors.green, Colors.orange],
      'selectedColor': Colors.teal,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 3,
      'name': 'Binta, Bintarealwax Ankara...',
      'price': 132.00,
      'originalPrice': 156.00,
      'discount': 15,
      'image': 'assets/images/ankara3.jpg',
      'colors': [Colors.teal, Colors.brown, Colors.orange],
      'selectedColor': Colors.teal,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 4,
      'name': 'Polyester Plain Fabric',
      'price': 132.00,
      'originalPrice': 156.00,
      'image': 'assets/images/ankara4.jpg',
      'colors': [Colors.orange, Colors.black],
      'selectedColor': Colors.orange,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 5,
      'name': 'Kampala Fabric Materials',
      'price': 132.00,
      'originalPrice': 156.00,
      'image': 'assets/images/ankara5.jpg',
      'colors': [Colors.teal, Colors.blue, Colors.brown],
      'selectedColor': Colors.teal,
      'isFavorite': false,
      'quantity': 1,
    },
    {
      'id': 6,
      'name': 'Polyester Plain Fabric',
      'price': 132.00,
      'originalPrice': 156.00,
      'image': 'assets/images/ankara6.jpg',
      'colors': [Colors.grey],
      'selectedColor': Colors.grey,
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
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
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
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
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
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product, isDark, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isDark, int index) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: isDark ? Colors.grey[700] : Colors.grey[100],
              ),
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      product['image'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: _getProductBackgroundColor(index),
                          child: _getProductPattern(index),
                        );
                      },
                    ),
                  ),

                  // Discount Badge
                  if (product['discount'] != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${product['discount']}%',
                          style: AappTextStyle.roboto(
                            color: Colors.white,
                            fontSize: 10,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          products[index]['isFavorite'] = !products[index]['isFavorite'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                          color: product['isFavorite'] ? Colors.red : Colors.grey[600],
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Details
          Container(
            height: 140,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product['name'],
                  style: AappTextStyle.roboto(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 11,
                    weight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Price
                Row(
                  children: [
                    Text(
                      '\${product[''].toStringAsFixed(2)}',
                      style: AappTextStyle.roboto(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 13,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (product['originalPrice'] != null)
                      Text(
                        '\${product[''].toStringAsFixed(2)}',
                        style: AappTextStyle.roboto(
                          color: Colors.grey,
                          fontSize: 11,
                          weight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                // Color Options
                if (product['colors'] != null && product['colors'].isNotEmpty)
                  Row(
                    children: [
                      ...product['colors'].take(3).map<Widget>((color) {
                        return Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: product['selectedColor'] == color
                                  ? Colors.black
                                  : Colors.grey[300]!,
                              width: product['selectedColor'] == color ? 2 : 1,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),

                const Spacer(),

                // Quantity and Add to Cart
                Row(
                  children: [
                    // Quantity Selector
                    Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Qty: ${product['quantity']}',
                            style: AappTextStyle.roboto(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 10,
                              weight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Add to Cart Button
                    Expanded(
                      child: Container(
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add to cart logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product['name']} added to cart'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'Add cart',
                            style: AappTextStyle.roboto(
                              color: Colors.white,
                              fontSize: 10,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getProductBackgroundColor(int index) {
    final List<Color> backgrounds = [
      Colors.blue[200]!,
      Colors.green[200]!,
      Colors.orange[200]!,
      Colors.orange[100]!,
      Colors.blue[300]!,
      Colors.purple[200]!,
    ];
    return backgrounds[index % backgrounds.length];
  }

  Widget _getProductPattern(int index) {
    switch (index) {
      case 0:
      // Rainbow stripes pattern
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
              ],
            ),
          ),
        );
      case 1:
      // Green paisley pattern
        return Container(
          color: Colors.green[700],
          child: const Center(
            child: Icon(
              Icons.eco,
              color: Colors.yellow,
              size: 40,
            ),
          ),
        );
      case 2:
      // Orange pattern
        return Container(
          color: Colors.orange[800],
          child: const Center(
            child: Icon(
              Icons.star,
              color: Colors.yellow,
              size: 40,
            ),
          ),
        );
      case 3:
      // Orange geometric pattern
        return Container(
          color: Colors.orange[600],
          child: const Center(
            child: Icon(
              Icons.circle,
              color: Colors.black,
              size: 30,
            ),
          ),
        );
      case 4:
      // Rainbow fabric pattern
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal,
                Colors.blue,
                Colors.purple,
                Colors.red,
                Colors.orange,
              ],
            ),
          ),
        );
      default:
      // Blue geometric pattern
        return Container(
          color: Colors.blue[800],
          child: const Center(
            child: Icon(
              Icons.diamond,
              color: Colors.white,
              size: 30,
            ),
          ),
        );
    }
  }
}