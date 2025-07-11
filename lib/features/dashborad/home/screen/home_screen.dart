import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/bottomnav_bar.dart';
import '../widgets/horizonalproducts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Your existing product lists remain the same
    List<Map<String, dynamic>> newArrivals = [
      {'image': 'assets/images/two.png', 'name': 'Summer Dress', 'price': 99.99},
      {'image': 'assets/images/four.png', 'name': 'Casual Blazer', 'price': 89.99},
      {'image': 'assets/images/three.png', 'name': 'Denim', 'price': 89.99},
    ];

    List<Map<String, dynamic>> recommended = [
      {'image': 'assets/images/four.png', 'name': 'Denim', 'price': 89.99},
      {'image': 'assets/images/five.png', 'name': 'one 16 plus', 'price': 89.99},
      {'image': 'assets/images/six.png', 'name': 'Samsung Galaxy', 'price': 89.99},
    ];

    List<Map<String, dynamic>> topSelling = [
      {'image': 'assets/images/five.png', 'name': 'one 16 plus', 'price': 89.99},
      {'image': 'assets/images/seven.png', 'name': 'Ear plugs CC3', 'price': 89.99},
      {'image': 'assets/images/eight.png', 'name': 'Headphones B2C', 'price': 89.99},
    ];

    // Add this list for your slider images
    List<String> sliderImages = [
      'assets/images/two.png', // Your current image
      'assets/images/three.png', // Add 2 more images
      'assets/images/one.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  Icon(Icons.menu, size: 30),
        actions:  [
          Icon(Icons.search, size: 34),
          SizedBox(width: 5),
          Icon(CupertinoIcons.heart, size: 30),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Replace the Image.asset with this CarouselSlider
            CarouselSlider(
              options: CarouselOptions(
                height: 220,
                aspectRatio: 16/9,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
              ),
              items: sliderImages.map((imagePath) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
            ),

            // Rest of your existing content remains unchanged
            const SizedBox(height: 25),
            HorizontalProductList2(
              title: "New Arrivals",
              products: newArrivals,
            ),
            const SizedBox(height: 5),
            HorizontalProductList2(
              title: "Recommended for you",
              products: recommended,
            ),
            const SizedBox(height: 5),
            HorizontalProductList2(
              title: "Top Selling",
              products: topSelling,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
        bottomNavigationBar: CustomBottomNavBar (currentIndex: 0,),
    );
  }
}       