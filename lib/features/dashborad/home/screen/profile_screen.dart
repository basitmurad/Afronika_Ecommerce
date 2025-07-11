import 'package:flutter/material.dart';

import '../widgets/bottomnav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile "),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3,),
    );
  }
}
