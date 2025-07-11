import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class cartbox_screen extends StatelessWidget {
  final String img;

  const cartbox_screen({
    super.key, required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 170,
          width: 320,
          child: Row(
            children: [
              Container(
                height: 90,
                width: 110,
                child: Center(
                  child: Image.asset(img),
                ),
              ),
              SizedBox(width: 5), // Add spacing between image and text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sony WH-CH520 Wireless Headphones"),
                      Text("With Microphone - Black"),
                      Row(

                        children: const [
                          Text(
                            "\$132.00",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
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
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(CupertinoIcons.plus,size: 15,),
                              SizedBox(width: 8,),
                              Text("2"),
                              SizedBox(width: 8,),
                              Icon(CupertinoIcons.minus,size: 15,)
                            ],),
                          Text("Save for Later ")
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Icon(CupertinoIcons.delete),
            ],),

        ),
      ],
    );
  }
}
