
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../cart/cart_screen.dart';


class whole_conatiner extends StatelessWidget {
  final String img;
  final String t2;
  final bool? discountbutton;
  final bool? showColorBox;
  final List<Color>? circleColors;

  const whole_conatiner({
    super.key,
    required this.t2,
    required this.img,
    this.discountbutton,
    this.showColorBox,
    this.circleColors,
  });

  @override
  Widget build(BuildContext context) {


    return Container(
      height: 280,
      width: 174,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Top Row with Image and Heart
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (discountbutton == true)
                Transform.translate(
                  offset: const Offset(0.001, -35),
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Center(
                      child: Text(
                        "-15%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 90,
                width: 90,
                child: Image.asset(img, fit: BoxFit.cover),
              ),
              Transform.translate(
                offset: const Offset(1, -30),
                child: const Icon(CupertinoIcons.heart, color: Colors.black),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ColorBox OR Circles OR Empty Fixed Space
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              t2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("  \$132.00",style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
                SizedBox(width: 15),
                Text(
                  "\$156.00",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 30, // Fixed height
            child: showColorBox == true
                ? Container(
              height: 40,
              width: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.8),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Select Color"),
                    Icon(Icons.unfold_more_outlined)
                  ],
                ),
              ),
            )
                : (circleColors != null && circleColors!.isNotEmpty)
                ? Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Row(
                children: circleColors!.map((color) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: color,
                    ),
                  );
                }).toList(),
              ),
            )
                : const SizedBox.shrink(), // nothing but keeps height
          ),
          const SizedBox(height: 10),

          // Qty + Add to Cart
          Padding(
            padding: const EdgeInsets.only(left: 7,right: 4),
            child: Row(
              children: [
                const Text('Qty:1'),
                 Icon(Icons.unfold_more_outlined),

                const Spacer(),
                InkWell(
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
                  },
                  child: Container(
                    height: 40,
                    width: 98,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(child: Text("Add Cart",style: TextStyle(
                      color: Colors.white
                    ),)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}


