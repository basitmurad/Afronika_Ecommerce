import 'package:flutter/material.dart';

import '../widgets/ordersummary_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('Order History'),
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios_new,size: 20,weight: 5,)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("All Order"),
                    Text("Processing"),
                    Text("Shipped"),
                    Text("Cancelled"),

                  ],
                ),
                SizedBox(height: 20,),
                OrderSummaryCard(
                  orderId: 'ORD-2024-001',
                  date: 'Jan 15, 2024',
                  items: '1 items',
                  status: 'Delivered',
                  amount: '\$132.00',
                  img: "assets/images/40.png",
                ),
                SizedBox(height: 18),
                OrderSummaryCard(
                  orderId: 'ORD-2024-002',
                  date: 'Jan 15, 2024',
                  items: '3 items',
                  status: 'Shipped',
                  amount: '\$89.50',
                  img: "assets/images/40.png",
                ),
                SizedBox(height: 18),
                OrderSummaryCard(
                  orderId: 'ORD-2024-003',
                  date: 'Jan 15, 2024',
                  items: '3 items',
                  status: 'Processing',
                  amount: '\$49.00',
                  img: "assets/images/40.png",
                ),
                SizedBox(height: 18),
                OrderSummaryCard(
                  orderId: 'ORD-2024-003',
                  date: 'Jan 15, 2024',
                  items: '3 items',
                  status: 'Cancelled',
                  amount: '\$199.00',
                  img: "assets/images/40.png",
                ),
              ],
            ),
          ),
      ),
    );
  }
}
