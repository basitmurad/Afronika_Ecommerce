import 'package:flutter/material.dart';
class design1 extends StatelessWidget {
   final String img;
   final String t1;
  final int num1;

  const design1({
    super.key, required this.img, required this.num1, required this.t1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            height: 110,
            width: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            ),

            child: Image.asset(
              img,
              fit: BoxFit.fill,
            ),
          ),

          SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t1,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Text("${num1}"),
                      Text(
                        "items",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ), // Changed from width to height for spacing in Column
                ],
              ),
              SizedBox(width: 60,),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}