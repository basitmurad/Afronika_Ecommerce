import 'package:afronika/utils/constant/colors.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'features/dashborad/cart/cart_screen.dart';
import 'features/dashborad/home/home_screen.dart';
import 'features/dashborad/profile/profile_screen.dart';
import 'features/dashborad/shop/shop_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final bool isDark = ADeviceUtils.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 60,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          backgroundColor: isDark ? AColors.darkBackground : Colors.white,
          onDestinationSelected: (index) {
            // Check index bounds before assigning
            if (index >= 0 && index < controller.screens.length) {
              controller.selectedIndex.value = index;
            }
          },
          destinations: [
            // Home tab
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                size: 20,
                color: isDark ? AColors.lightGray100 : AColors.darkGray800,
              ),
              selectedIcon: Icon(
                Icons.home,
                size: 20,
                color: isDark ? Colors.white60 : AColors.primary,
              ),
              label: 'Home',
            ),
            // Shop tab
            NavigationDestination(
              icon: Icon(
                Icons.store_outlined,
                size: 20,
                color: isDark ? AColors.lightGray100 : AColors.darkGray800,
              ),
              selectedIcon: Icon(
                Icons.store,
                size: 20,
                color: isDark ? Colors.white60 : AColors.primary,
              ),
              label: 'Shop',
            ),
            // Cart tab
            NavigationDestination(
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 20,
                color: isDark ? AColors.lightGray100 : AColors.darkGray800,
              ),
              selectedIcon: Icon(
                Icons.shopping_cart,
                size: 20,
                color: isDark ? Colors.white60 : AColors.primary,
              ),
              label: 'Cart',
            ),
            // Profile tab
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                size: 20,
                color: isDark ? AColors.lightGray100 : AColors.darkGray800,
              ),
              selectedIcon: Icon(
                Icons.person,
                size: 20,
                color: isDark ? Colors.white60 : AColors.primary,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    const HomeScreen(),
    ShopScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
}