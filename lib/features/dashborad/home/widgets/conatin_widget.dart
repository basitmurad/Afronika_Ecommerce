import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ConatinerWidget extends StatelessWidget {
  final String t1;
  final String t2;
    final String img1;


  const ConatinerWidget({
    super.key, required this.t1, required this.img1, required this.t2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 140,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
              child: Image.asset(
              img1,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(t1,style: TextStyle(
                      fontSize: 12,

                  ),),
                  Text(t2,style: TextStyle(
                      fontSize: 12,
                  ),)
                ],
              ),
             Icon(Icons.arrow_forward_ios),
            ],
          )
        ],
      ),

    );
  }
}
