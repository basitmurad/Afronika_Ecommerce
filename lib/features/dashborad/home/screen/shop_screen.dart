import 'package:afronika/features/dashborad/home/screen/samsung_screens.dart';
import 'package:afronika/features/dashborad/home/screen/sonyheadset_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/bottomnav_bar.dart';
import '../widgets/conatin_widget.dart';
import '../widgets/imagesliderwidget.dart';
import 'LaptopScreen .dart';
import 'ankara_screen.dart';
import 'apple_screen.dart';
import 'infinix_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(CupertinoIcons.back,size: 30,)),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSliderWidget(),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AnkaraScreen()));
                  },
                    child: ConatinerWidget(t1: 'Ankara', img1: 'assets/images/nine.png', t2: '   10 items',)),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AppleScreen()));
                  },
                    child: ConatinerWidget(t1: 'Apple', img1: 'assets/images/ten.png', t2: '   04 items',)),
              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SamsungScreens()));
                  },
                    child: ConatinerWidget(t1: " Samsung", img1: "assets/images/18.png", t2: '  10 items')),
                ConatinerWidget(t1: "Tablets", img1: "assets/images/12.png", t2: '   10 items'),],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LaptopScreen()));
                  },
                    child: ConatinerWidget(t1: "Laptop", img1: "assets/images/13.png", t2:'   10 items')),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>InfinixScreen()));
                  },
                    child: ConatinerWidget(t1: "Infinix", img1: "assets/images/14.png", t2: '   10 items')),],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SonyheadsetScreen()));
                  },
                    child: ConatinerWidget(t1: "   Sony Headphone", img1: "assets/images/15.png", t2: '10 items')),
                ConatinerWidget(t1: "Tecno", img1: "assets/images/16.png", t2:'   10 items'),],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10,),
                ConatinerWidget(t1: "Xiaomi", img1: "assets/images/17.png", t2: "10 items"),],),
            
          ],
        ),
      ),
     bottomNavigationBar: CustomBottomNavBar (currentIndex: 1,),
    );
  }
}


