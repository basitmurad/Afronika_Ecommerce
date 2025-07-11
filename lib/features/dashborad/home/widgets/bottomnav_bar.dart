import 'package:flutter/material.dart';

import '../../cart/cart_screen.dart';

import '../screen/home_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/shop_screen.dart';


class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;

  final List<String> _titles = ['Home', 'Shop', 'Cart', 'Profile'];
  final List<IconData> _icons = [Icons.home, Icons.store, Icons.card_travel, Icons.person];
  final List<Widget> _screens = [
    HomeScreen(),
    ShopScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Agar same tab pe click kiya to kuch na kare

    setState(() {
      _selectedIndex = index;
    });

    // Navigate to selected screen, replace current to avoid stacking
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _screens[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_titles.length, (index) {
          final isSelected = index == _selectedIndex;
          final color = isSelected ? Colors.blue : Colors.black;

          return GestureDetector(
            onTap: () => _onItemTapped(index),
            behavior: HitTestBehavior.translucent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_icons[index], color: color),
                const SizedBox(height: 4),
                Text(
                  _titles[index],
                  style: TextStyle(color: color),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
