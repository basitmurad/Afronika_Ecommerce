import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';

import '../utils/constant/app_test_style.dart';

class CartCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String? originalPrice; // Optional original price for strikethrough
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
    this.originalPrice,
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                image: AssetImage(imagePath),
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AappTextStyle.roboto(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      weight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price Row
                  Row(
                    children: [
                      Text(
                        price,
                        style: AappTextStyle.roboto(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16.0,
                          weight: FontWeight.w600,
                        ),
                      ),
                      if (originalPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          originalPrice!,
                          style: AappTextStyle.roboto(
                            color: Colors.grey[500]!,
                            fontSize: 12.0,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bottom Row with Quantity Controls and Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Row(
                        children: [
                          // Decrease Button
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: quantity > 1 ? onDecreaseQuantity : null,
                              icon: Icon(
                                Icons.remove,
                                size: 16,
                                color: quantity > 1
                                    ? (isDark ? Colors.white : Colors.black54)
                                    : Colors.grey[400],
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),

                          // Quantity Display
                          Container(
                            width: 40,
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              quantity.toString(),
                              style: AappTextStyle.roboto(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 14.0,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Increase Button
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: onIncreaseQuantity,
                              icon: Icon(
                                Icons.add,
                                size: 16,
                                color: isDark ? Colors.white : Colors.black54,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),

                      // Action Buttons
                      Row(
                        children: [
                          // Save for Later Button
                          // TextButton(
                          //   onPressed: onOrder,
                          //   style: TextButton.styleFrom(
                          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          //     minimumSize: Size.zero,
                          //   ),
                          //   child: Text(
                          //     'Save for later',
                          //     style: AappTextStyle.roboto(
                          //       color: isDark ? Colors.blue[300]! : Colors.blue,
                          //       fontSize: 12.0,
                          //       weight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),

                          // Delete Button
                          IconButton(
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.grey[500],
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}