import 'package:flutter/material.dart';
class cart_amounts extends StatelessWidget {
  final String txt;
  final String amount;

  const cart_amounts({
    super.key, required this.txt, required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,right: 18,bottom: 4,left: 15.0),
      child: Row(
        children: [
          Text(txt,style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),),
          Spacer(),
          Text(amount,style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),),


        ],
      ),
    );
  }
}
