import 'package:flutter/material.dart';

import '../widgets/bottomnav_bar.dart';
import '../widgets/search_widget.dart';
import '../widgets/whole_container.dart';

class LaptopScreen extends StatelessWidget {
  const LaptopScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Laptop'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,size: 20,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:10,),
            search_widget(),
            SizedBox(height: 18,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                whole_conatiner(
                  t2: 'Hollandais, High Quality Supper Wax',
                  img: 'assets/images/34.png',
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.black],// ✅ Show color box
                ),
                whole_conatiner(
                  t2: "Hitaget Super Quality Wax",
                  img: "assets/images/35.png",
                  discountbutton: false,
                  showColorBox: false,

                )
              ],
            ),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                whole_conatiner(
                  t2: 'Hitaget Super Quality Wax',
                  img: 'assets/images/36.png',
                  discountbutton: false,
                  showColorBox: false,

                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar:CustomBottomNavBar(currentIndex: 1,),
    );

  }
}
