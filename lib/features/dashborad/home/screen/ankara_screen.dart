import 'package:flutter/material.dart';

import '../widgets/bottomnav_bar.dart';
import '../widgets/search_widget.dart';
import '../widgets/whole_container.dart';

class AnkaraScreen extends StatelessWidget {
  const AnkaraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios_new_rounded,size: 20,)),
        title: const Text("Ankara"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const search_widget(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                whole_conatiner(
                  t2: 'Polyester Duchase Stain',
                  img: 'assets/images/nine.png',
                  discountbutton: false,
                  showColorBox: true, // ✅ Show color box
                ),
                whole_conatiner(
                    t2: "Hollandais, High Quality Supper Wax",
                    img: "assets/images/19.png",
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.blue],
                )
              ],
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                whole_conatiner(
                  t2: 'Binta, Bintarealwax Ankara African',
                  img: 'assets/images/22.png',
                  discountbutton: true,
                  showColorBox: false,
                  circleColors: [Colors.blue], // ✅ 1 blue circle
                ),
                whole_conatiner(

                  t2: 'Polyester Plain Fabric',
                  img: 'assets/images/23.png',
                  discountbutton: false,
                  showColorBox: false,
                  circleColors: [], // ✅ Nothing
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                whole_conatiner(
                  t2: 'Kampala Fabric Materials',
                  img: 'assets/images/20.png',
                  discountbutton: false,
                  showColorBox: false,
                  circleColors: [ // ✅ 3 circles
                    Colors.blue,
                    Colors.purple,
                    Colors.brown,
                  ],
                ),
                whole_conatiner(
                  t2: 'Polyester Plain Fabric',
                  img: 'assets/images/21.png',
                  discountbutton: false,
                  showColorBox: false,
                  circleColors: [], // ✅ Nothing
                ),
              ],
            ),
          ],
        ),
      ),

       bottomNavigationBar:  CustomBottomNavBar(currentIndex: 1,),
    );
  }
}
