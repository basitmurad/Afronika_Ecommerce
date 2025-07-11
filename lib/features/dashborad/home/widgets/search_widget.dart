import 'package:flutter/material.dart';
class search_widget extends StatelessWidget {
  const search_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 8,),
        Container(
          height: 55,
          width: 260,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none, // Remove the default underline
              prefixIcon: Icon(Icons.search),
              hintText: "Search items",
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),
        ),
        SizedBox(width: 10,),
        Row(
          children: [
            Text("Filters:",style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),),
            SizedBox(width: 5,),
            Icon(Icons.tune,size: 22,color: Colors.black,),
          ],
        )
      ],
    );
  }
}
