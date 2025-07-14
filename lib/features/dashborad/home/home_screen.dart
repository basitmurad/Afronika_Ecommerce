import 'package:afronika/common/product_card.dart';
import 'package:afronika/features/dashborad/home/drawer/custom_navigation_drawer.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utils/constant/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Material(
          color: isDark ? Colors.black : Colors.white,
          elevation: 0, // 👈 No shadow
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/nav.png', // 👈 Replace with your own asset path
                    height: 24,
                    width: 24,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: Image.asset(
                    GImagePath.search,
                    height: 22,
                    width: 22,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.searchScreen);
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    GImagePath.heart,
                    height: 22,
                    width: 22,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.wishlistScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: CustomNavigationDrawer(isDark: isDark),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel Section
                    _buildImageCarousel(isDark),
                    const SizedBox(height: 24),

                    // New Arrivals Section
                    _buildSectionHeader('New Arrivals', isDark),
                    const SizedBox(height: 16),
                    _buildProductSection(isDark),
                    const SizedBox(height: 24),

                    // Recommended Section
                    _buildSectionHeader('Recommended for you', isDark),
                    const SizedBox(height: 16),
                    _buildProductSection(isDark),
                    const SizedBox(height: 24),

                    // Top Selling Section
                    _buildSectionHeader('Top selling', isDark),
                    const SizedBox(height: 16),
                    _buildProductSection(isDark),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageCarousel(bool isDark) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: imageUrls.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: isDark ? Colors.white : Colors.red,
                  dotColor: isDark ? Colors.white.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: AappTextStyle.roboto(
          color: isDark ? AColors.primary : Colors.black,
          fontSize: 18.0,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductSection(bool isDark) {
    final List<Map<String, String>> products = [
      {
        'image': GImagePath.image2,
        'title': 'Casual Dress',
        'price': '394',
      },
      {
        'image': GImagePath.image2,
        'title': 'T-Shirt',
        'price': '210',
      },
      {
        'image': GImagePath.image1,
        'title': 'Summer Dress',
        'price': '299',
      },
      {
        'image': GImagePath.image2,
        'title': 'Polo Shirt',
        'price': '189',
      },
    ];

    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: ProductCard(
              imagePath: product['image']!,
              title: product['title']!,
              price: product['price']!,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}