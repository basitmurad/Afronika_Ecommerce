import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/bottomnav_bar.dart';
import '../widgets/search_widget.dart';
import '../widgets/whole_container.dart';

class SonyheadsetScreen extends StatelessWidget {
  const SonyheadsetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Sony Headphones"),
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
                  img: 'assets/images/40.png',
                  discountbutton: false,
                  showColorBox: false,
                ),
                whole_conatiner(
                  t2: "Hollandais, High Quality Supper Wax",
                  img: "assets/images/40.png",
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.greenAccent],

                )
              ],
            ),


          ],
        ),
      ),
      bottomNavigationBar:CustomBottomNavBar(currentIndex: 1),
    );

  }
}
