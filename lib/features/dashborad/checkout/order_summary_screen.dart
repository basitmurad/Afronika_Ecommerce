import 'package:afronika/common/GButton.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../../common/OrderItemCard.dart';
import '../../../utils/constant/app_test_style.dart';
import '../../../utils/device/device_utility.dart';
import '../../models/OrderItem.dart';
import 'order_success_screen.dart' hide OrderItemCard;

class OrderSummaryScreen extends StatelessWidget {
  final List<OrderItem> orderItems;
  final String deliveryAddress;
  final String paymentMethod;
  final double subtotal;
  final double shipping;

  const OrderSummaryScreen({
    super.key,
    required this.orderItems,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.shipping,
  });

  @override
  Widget build(BuildContext context) {
    final double total = subtotal + shipping;
    final bool isDark = ADeviceUtils.isDarkMode(context);
    final Color bgColor = isDark ? Colors.black : Colors.white;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.grey[100]!;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color secondaryText = isDark ? Colors.grey[400]! : Colors.grey[700]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order summary',
          style: AappTextStyle.roboto(
            color: textColor,
            fontSize: 20.0,
            weight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Order',
              style: AappTextStyle.roboto(
                fontSize: 20,
                weight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Order Items
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  final item = orderItems[index];
                  return OrderItemCard(item: item);
                },
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery To',
                  style: AappTextStyle.roboto(
                    fontSize: 18,
                    weight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Change',
                    style: AappTextStyle.roboto(
                      fontSize: 16,
                      color: Colors.blue,
                        weight: FontWeight.w500

                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: secondaryText,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deliveryAddress,
                          style: AappTextStyle.roboto(
                            fontSize: 16,
                            weight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'City Name Here', // Replace if city is separate
                          style: AappTextStyle.roboto(
                            fontSize: 14,
                            color: secondaryText,
                              weight: FontWeight.w500

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment',
                  style: AappTextStyle.roboto(
                    fontSize: 18,
                    weight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Change',
                    style: AappTextStyle.roboto(
                      fontSize: 16,
                      color: Colors.blue,
                        weight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'VISA',
                      style: AappTextStyle.roboto(
                        color: Colors.white,
                        fontSize: 12,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    paymentMethod,
                    style: AappTextStyle.roboto(
                      fontSize: 16,
                      weight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: AappTextStyle.roboto(
                          fontSize: 16,
                          color: secondaryText,
                            weight: FontWeight.w400
                        ),
                      ),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: AappTextStyle.roboto(
                          fontSize: 16,
                          weight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping:',
                        style: AappTextStyle.roboto(
                          fontSize: 16,
                          color: secondaryText, weight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '\$${shipping.toStringAsFixed(2)}',
                        style: AappTextStyle.roboto(
                          fontSize: 16,
                          weight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: AappTextStyle.roboto(
                          fontSize: 18,
                          weight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: AappTextStyle.roboto(
                          fontSize: 18,
                          weight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            AButton(text: 'Place Order', onPressed: () { _placeOrder(context); },),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    final orderId = '#A${Random().nextInt(99999999).toString().padLeft(8, '0')}';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(orderId: orderId),
      ),
    );
  }
}
