import 'package:flutter/material.dart';
class PaymentWidget extends StatelessWidget {
  final Icon ic1;
  final String t1;
  final String t2;
  final bool selected;
  final VoidCallback onTap;

  const PaymentWidget({
    super.key,
    required this.ic1,
    required this.t1,
    required this.t2,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(   // For tap effect
      onTap: onTap,
      child: Container(
        height: 80,
        width: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? Colors.orange : Colors.grey, width: 0.8),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ic1,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t1,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    t2,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              // Replace circle with Radio button
              Radio<bool>(
                value: true,
                groupValue: selected,
                onChanged: (val) {
                  onTap();
                },
                activeColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
