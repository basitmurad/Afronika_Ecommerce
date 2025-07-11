import 'package:flutter/material.dart';
class OrderSummaryCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String items;
  final String status;
  final String amount;
  final String img;

  const OrderSummaryCard({
    required this.orderId,
    required this.date,
    required this.items,
    required this.status,
    required this.amount,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    final statusColors = _getStatusColors(status);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderId,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    items,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  StatusColors _getStatusColors(String status) {
    switch (status) {
      case 'Delivered':
        return StatusColors(Colors.greenAccent, Colors.green);
      case 'Shipped':
        return StatusColors(Colors.lightBlueAccent, Colors.deepPurpleAccent);
      case 'Processing':
        return StatusColors(Colors.orangeAccent, Colors.deepOrangeAccent);
      case 'Cancelled':
        return StatusColors(Colors.orangeAccent, Colors.red);
      default:
        return StatusColors(Colors.grey, Colors.black);
    }
  }
}

class StatusColors {
  final Color backgroundColor;
  final Color textColor;

  StatusColors(this.backgroundColor, this.textColor);
}