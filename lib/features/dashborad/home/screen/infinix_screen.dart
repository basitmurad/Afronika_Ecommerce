import 'package:flutter/material.dart';

import '../widgets/bottomnav_bar.dart';
import '../widgets/search_widget.dart';
import '../widgets/whole_container.dart';

class InfinixScreen extends StatelessWidget {
  const InfinixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Infinix'),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios_new_rounded),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:10,),
            search_widget(),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                whole_conatiner(
                  t2: 'Hollandais, High Quality Supper Wax',
                  img: 'assets/images/37.png',
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.black],// ✅ Show color box
                ),
                whole_conatiner(
                  t2: "Hollandais, High Quality Supper Wax",
                  img: "assets/images/38.png",
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.black],

                )
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                whole_conatiner(
                  t2: 'Hollandais, High Quality Supper Wax',
                  img: 'assets/images/39.png',
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.black],// ✅ Show color box
                ),
                whole_conatiner(
                  t2: "Hitaget Super Quality Wax",
                  img: "assets/images/37.png",
                  discountbutton: false,
                  showColorBox: false,

                )
              ],
            ),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex:1 ,),
    );

  }
}
