import 'package:afronika/features/dashborad/home/widgets/productcard.dart';
import 'package:flutter/material.dart';
class HorizontalProductList2 extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  const HorizontalProductList2({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
               Row(
                children: [
                  Text("All"),
                  SizedBox(width: 6,),
                  Icon(Icons.expand_more, size: 20),
                ],
              ),
            ],
          ),
        ),
       SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding:  EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              return ProductCard2(
                imagePath: products[index]['image'],
                name: products[index]['name'],
                price: products[index]['price'],
              );
            },
          ),
        ),
      ],
    );
  }
}