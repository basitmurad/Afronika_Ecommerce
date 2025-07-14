import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';

import '../utils/constant/app_test_style.dart';

class CartCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final bool isDark;
  final int quantity;

  final VoidCallback onDelete;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onOrder;

  const CartCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.isDark,
    required this.quantity,
    required this.onDelete,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                image: AssetImage(imagePath),
              ),
            ),
            const SizedBox(height: 12),

            // Title + Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AappTextStyle.roboto(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16.0,
                      weight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  price,
                  style: AappTextStyle.roboto(
                    color: isDark ? AColors.primary : Colors.black,
                    fontSize: 14.0,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Quantity Controls and Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity Controls
                Row(
                  children: [
                    // Decrease Quantity Button
                    IconButton(
                      onPressed: quantity > 1 ? onDecreaseQuantity : null,
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: quantity > 1
                            ? (isDark ? Colors.white : Colors.black54)
                            : Colors.grey[400],
                      ),
                      tooltip: 'Decrease quantity',
                    ),

                    // Quantity Display
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        quantity.toString(),
                        style: AappTextStyle.roboto(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16.0,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Increase Quantity Button
                    IconButton(
                      onPressed: onIncreaseQuantity,
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: isDark ? Colors.white : Colors.black54,
                      ),
                      tooltip: 'Increase quantity',
                    ),
                  ],
                ),

                // Delete Button
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400]),
                  tooltip: 'Remove from Cart',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Order Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onOrder,
                child: Text(
                  'Order Now',
                  style: AappTextStyle.roboto(
                    color: Colors.white,
                    fontSize: 14.0,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}