
import 'package:flutter/material.dart';

import '../widgets/bottomnav_bar.dart';
import '../widgets/search_widget.dart';
import '../widgets/whole_container.dart';
class AppleScreen extends StatelessWidget {
  const AppleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Apple"),
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
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                whole_conatiner(
                  t2: 'Hitaget Super Quality Wax',
                  img: 'assets/images/24.png',
                  discountbutton: false,
                  showColorBox: false, // ✅ Show color box
                ),
                whole_conatiner(
                  t2: "Hollandais, High Quality Supper Wax",
                  img: "assets/images/25.png",
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
                  t2: 'Binta, Bintarealwax Ankara African',
                  img: 'assets/images/26.png',
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.blue],// ✅ Show color box
                ),
                whole_conatiner(
                  t2: "Polyester Plain Fabric",
                  img: "assets/images/27.png",
                  discountbutton: true,
                  showColorBox: false,
                )
              ],
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                whole_conatiner(
                  t2: 'Kampala Fabric Materials',
                  img: 'assets/images/28.png',
                  discountbutton: false,
                  showColorBox: false,
                  circleColors: [Colors.blue,Colors.deepPurple,Colors.brown],// ✅ Show color box
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
