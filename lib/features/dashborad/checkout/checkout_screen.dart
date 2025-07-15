import 'package:afronika/common/GButton.dart';
import 'package:afronika/features/dashborad/checkout/order_summary_screen.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../../../common/payment_option.dart';
import '../../../utils/constant/app_test_style.dart';
import '../../models/CartItem.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem>? cartItems; // Optional cart items for reference


  const PaymentMethodScreen({
    super.key,
    required this.totalAmount, this.cartItems,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPaymentMethod = 'credit_card';

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,

        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Method',
          style: AappTextStyle.roboto(
            fontSize: 18,
            weight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,

          ),


        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Select Payment Method',
              style: AappTextStyle.roboto(
                fontSize: 18,
                weight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your preferred payment option',
              style: AappTextStyle.roboto(
                fontSize: 16,
                weight: FontWeight.w400,
                color: isDark ? Colors.grey[300]! : Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Payment Options
            PaymentOption(
              icon: Icons.credit_card,
              title: 'Credit/Debit Card',
              subtitle: 'Visa, Mastercard, etc.',
              value: 'credit_card',
              selectedValue: selectedPaymentMethod,
              onTap: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              }, dark: isDark,
            ),
            const SizedBox(height: 16),

            PaymentOption(
              icon: Icons.account_balance_wallet,
              title: 'Paystack',
              dark: isDark,
              subtitle: 'Fast and secure',
              value: 'paystack',
              selectedValue: selectedPaymentMethod,
              onTap: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(height: 16),

            PaymentOption(
              icon: Icons.payments,
              title: 'Cash on Delivery',
              dark: isDark,
              subtitle: 'Pay when you receive',
              value: 'cash_on_delivery',
              selectedValue: selectedPaymentMethod,
              onTap: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // Security Notice
            Row(
              children: [
                Icon(
                  Icons.security,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'All transactions are secure and encrypted',
                  style: AappTextStyle.roboto(
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: isDark ? Colors.grey[300]! : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Payment Icons
            Row(
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
                      fontSize: 12,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'MC',
                    style: AappTextStyle.roboto(
                      fontSize: 12,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'AMEX',
                    style: AappTextStyle.roboto(
                      fontSize: 10,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[600],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'DISC',
                    style: AappTextStyle.roboto(
                      fontSize: 10,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Total Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount',
                  style: AappTextStyle.roboto(
                    fontSize: 16,
                    weight: FontWeight.w400,
                    color: isDark ? Colors.grey[300]! : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.totalAmount.toStringAsFixed(2)}',
                  style: AappTextStyle.roboto(
                    fontSize: 24,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Continue Button

            AButton(text: 'Continue', onPressed: () {
              _handlePaymentContinue();
            },),

            const SizedBox(height: 50),

            // Bottom indicator
          ],
        ),
      ),
    );
  }

  void _handlePaymentContinue() {
    // Handle different payment methods
    switch (selectedPaymentMethod) {
      case 'credit_card':
      // Navigate to card input screen
        debugPrint('Credit Card selected');
        // Navigate to Order Summary
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderSummaryScreen(
                  paymentMethod: selectedPaymentMethod,
                  subtotal: 132.00,
                  shipping: 5.00,
                  orderItems: [],
                  deliveryAddress: 'sdfsdfs',
                ),
          ),
        );
        break;
      case 'paystack':
      // Handle Paystack payment
        debugPrint('Paystack selected');
        break;
      case 'cash_on_delivery':
      // Handle cash on delivery
        debugPrint('Cash on Delivery selected');
        break;
    }
  }
}


