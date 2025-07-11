import 'package:afronika/features/dashborad/home/screen/shop_screen.dart';
import 'package:flutter/material.dart';

import 'history_screen.dart';


class SucessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80,),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 60,
                      weight: 10,
                      grade: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // ✅ Order Confirmation Text
                Text(
                  "Order Placed Successfully!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16),

                // ✅ Order ID
                Text(
                  "Order ID: #A12345678",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 8),

                // ✅ Delivery Time
                Text(
                  "Estimated Delivery: 3–5 business days",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 24),

                // ✅ Thank You Message
                Text(
                  "Thank you for shopping with us!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 48),

                // ✅ Done Button
                InkWell(

                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryScreen()));
                      },
                      child: Container(
                        height: 60,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Done",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),

                ),

                SizedBox(height: 5),

                // ✅ Continue Shopping Button
                 TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopScreen()));
                    },
                    child: Text(
                      "Continue Shopping",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//