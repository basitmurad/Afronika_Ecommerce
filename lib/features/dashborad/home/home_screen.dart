import 'package:afronika/common/product_card.dart';
import 'package:afronika/features/dashborad/home/drawer/custom_navigation_drawer.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: CustomNavigationDrawer(isDark: isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          child: Image.network(
                            imageUrls[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 130,
                        right: 110,
                        bottom: 10,
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: imageUrls.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: isDark ? Colors.white : Colors.red,
                            dotHeight: 8,
                            dotWidth: 8,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.topLeft,
              child: Text(
                'New Arrivals',
                style: AappTextStyle.roboto(
                  color: isDark ? AColors.primary : Colors.black,
                  fontSize: 16.0,
                  weight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16 ,vertical: 14),
              child: Row(
                children: [
                  ProductCard(
                    imagePath: GImagePath.image1,
                    title: 'Casual Dress',
                    price: '394',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 20),
                  ProductCard(
                    imagePath: GImagePath.image2,
                    title: 'T-Shirt',
                    price: '210',
                    isDark: isDark,
                  ),
                  // Add more ProductItem widgets as needed
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.topLeft,
              child: Text(
                'Recommended for you',
                style: AappTextStyle.roboto(
                  color: isDark ? AColors.primary : Colors.black,
                  fontSize: 16.0,
                  weight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16 ,vertical: 14),
              child: Row(
                children: [
                  ProductCard(
                    imagePath: GImagePath.image1,
                    title: 'Casual Dress',
                    price: '394',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 20),
                  ProductCard(
                    imagePath: GImagePath.image2,
                    title: 'T-Shirt',
                    price: '210',
                    isDark: isDark,
                  ),
                  // Add more ProductItem widgets as needed
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.topLeft,
              child: Text(
                'Top selling',
                style: AappTextStyle.roboto(
                  color: isDark ? AColors.primary : Colors.black,
                  fontSize: 16.0,
                  weight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16 ,vertical: 14),
              child: Row(
                children: [
                  ProductCard(
                    imagePath: GImagePath.image1,
                    title: 'Casual Dress',
                    price: '394',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 20),
                  ProductCard(
                    imagePath: GImagePath.image2,
                    title: 'T-Shirt',
                    price: '210',
                    isDark: isDark,
                  ),
                  // Add more ProductItem widgets as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
