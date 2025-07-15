import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../../../utils/device/device_utility.dart';
import '../../../utils/constant/app_test_style.dart';
import '../../models/OrderItem.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);
    final Color bgColor = isDark ? Colors.black : Colors.white;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.grey[100]!;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color secondaryText = isDark ? Colors.grey[400]! : Colors.grey[700]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Animation Area
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -20,
                    right: -10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -20,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              Text(
                'Order Placed Successfully!',
                style: AappTextStyle.roboto(
                  color: textColor,
                  fontSize: 24,
                  weight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Text(
                'Order ID: $orderId',
                style: AappTextStyle.roboto(
                  weight: FontWeight.w400,
                  color: secondaryText,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Estimated Delivery: 3-5 business days',
                style: AappTextStyle.roboto(
                  color: secondaryText,
                  fontSize: 16, weight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Thank you for shopping with us!',
                style: AappTextStyle.roboto(
                  color: textColor,
                  fontSize: 18,
                  weight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      RouteName.navigationMenu,
                      arguments: 0, // Assuming 0 is the index for the Shop tab
                    );

                    // Navigator.pushReplacementNamed(context, RouteName.navigationMenu);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: AappTextStyle.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),



              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

