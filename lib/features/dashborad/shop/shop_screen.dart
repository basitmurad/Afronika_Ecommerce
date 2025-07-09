import 'package:afronika/features/dashborad/shop/AnkaraCategoryScreen.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final PageController _pageController = PageController();

  // Banner images for the carousel
  final List<Map<String, String>> banners = [
    {
      'image': 'assets/images/summer_banner.jpg',
      'title': 'Summer Collection',
    },
    {
      'image': 'assets/images/winter_banner.jpg',
      'title': 'Winter Collection',
    },
    {
      'image': 'assets/images/spring_banner.jpg',
      'title': 'Spring Collection',
    },
  ];

  // Categories data
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Ankara',
      'items': '10 items',
      'image': 'assets/images/ankara_category.jpg',
      'colors': [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple],
    },
    {
      'name': 'Apple',
      'items': '04 items',
      'image': 'assets/images/apple_category.jpg',
      'isApple': true,
    },
    {
      'name': 'Samsung',
      'items': '10 items',
      'image': 'assets/images/samsung_category.jpg',
      'color': Color(0xFF1B5E20),
    },
    {
      'name': 'Tablets',
      'items': '10 items',
      'image': 'assets/images/tablets_category.jpg',
      'colors': [Colors.yellow, Colors.green, Colors.blue],
    },
    {
      'name': 'Laptop',
      'items': '10 items',
      'image': 'assets/images/laptop_category.jpg',
      'isLaptop': true,
    },
    {
      'name': 'Infinix',
      'items': '10 items',
      'image': 'assets/images/infinix_category.jpg',
      'isPhone': true,
    },
    {
      'name': 'Sony Headphone',
      'items': '10 items',
      'image': 'assets/images/sony_headphone.jpg',
      'isHeadphone': true,
    },
    {
      'name': 'Tecno',
      'items': '10 items',
      'image': 'assets/images/tecno_category.jpg',
      'color': Color(0xFF00BCD4),
    },
    {
      'name': 'Xiaomi',
      'items': '10 items',
      'image': 'assets/images/xiaomi_category.jpg',
      'color': Color(0xFF1976D2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Banner Carousel
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.teal.shade300,
                            Colors.teal.shade600,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background Image (placeholder)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.teal.shade300.withOpacity(0.8),
                                    Colors.teal.shade600.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: Image.asset(
                                banner['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.teal.shade300,
                                          Colors.teal.shade600,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Title Overlay
                          Positioned(
                            bottom: 30,
                            left: 24,
                            right: 24,
                            child: Text(
                              banner['title']!,
                              style: AappTextStyle.roboto(
                                color: Colors.white,
                                fontSize: 24,
                                weight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Page Indicator
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: banners.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.teal,
                    dotColor: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Categories Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(category, isDark);
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, bool isDark) {
    return GestureDetector(
      onTap: () {
        // Navigate to category products
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AnkaraCategoryScreen(),
          ),
        );

        print('Tapped on ${category['name']}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
          children: [
            // Image Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: _getCategoryBackgroundColor(category),
                ),
                child: Stack(
                  children: [
                    // Category specific content
                    _buildCategoryContent(category),
                    // Image overlay (if needed)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        category['image'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: _getCategoryBackgroundColor(category),
                            child: _buildCategoryContent(category),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Category Info
            Container(
              height: 60,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category['name'],
                          style: AappTextStyle.roboto(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                            weight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category['items'],
                          style: AappTextStyle.roboto(
                            color: Colors.grey,
                            fontSize: 11,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContent(Map<String, dynamic> category) {
    // Ankara - Rainbow stripes
    if (category['colors'] != null && category['name'] == 'Ankara') {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: category['colors'],
          ),
        ),
      );
    }

    // Apple - Phone mockups
    if (category['isApple'] == true) {
      return Container(
        color: Colors.pink.shade100,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 35,
              child: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.pink.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Samsung - Phone mockup
    if (category['name'] == 'Samsung') {
      return Container(
        color: category['color'],
        child: Center(
          child: Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    // Tablets - Stacked tablets
    if (category['name'] == 'Tablets') {
      return Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 30,
              child: Container(
                width: 60,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 35,
              child: Container(
                width: 60,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 40,
              child: Container(
                width: 60,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Laptop - Laptop mockup
    if (category['isLaptop'] == true) {
      return Container(
        color: Colors.grey.shade300,
        child: Center(
          child: Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    }

    // Infinix - Phone mockup
    if (category['isPhone'] == true) {
      return Container(
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 35,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 35,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      );
    }

    // Sony Headphone - Headphone mockup
    if (category['isHeadphone'] == true) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      );
    }

    // Default solid color
    return Container(
      color: category['color'] ?? Colors.grey.shade300,
    );
  }

  Color _getCategoryBackgroundColor(Map<String, dynamic> category) {
    if (category['color'] != null) return category['color'];
    if (category['colors'] != null) return category['colors'][0];
    if (category['isApple'] == true) return Colors.pink.shade100;
    if (category['isLaptop'] == true) return Colors.grey.shade300;
    if (category['isPhone'] == true) return Colors.grey.shade200;
    if (category['isHeadphone'] == true) return Colors.black;
    return Colors.grey.shade300;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}