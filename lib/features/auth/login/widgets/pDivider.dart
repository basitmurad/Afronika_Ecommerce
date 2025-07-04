import 'package:afronika/utils/constant/paddings.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:flutter/material.dart';

class Pdivider extends StatelessWidget {
  final String title;
  const Pdivider({required this.title,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.sidePd,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 80, child: Divider(color: Colors.grey)),
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(width: 80, child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }
}
