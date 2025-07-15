import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/models/OrderItem.dart';
import '../utils/constant/app_test_style.dart';
import '../utils/device/device_utility.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItem item;

  const OrderItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.grey[50]!;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color secondaryText = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AappTextStyle.roboto(
                    color: textColor,
                    fontSize: 16,
                    weight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Qty: ${item.quantity}',
                  style: AappTextStyle.roboto(
                    weight: FontWeight.w400,
                    color: secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: AappTextStyle.roboto(
              color: textColor,
              fontSize: 16,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
