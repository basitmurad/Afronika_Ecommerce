import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';

import '../utils/constant/app_test_style.dart';

class WishlistCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final bool isDark;

  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromWishlist;

  const WishlistCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.isDark,
    required this.onAddToCart,
    required this.onRemoveFromWishlist,
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

            // Buttons
            Row(
              children: [
                // Add to Cart Button
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onAddToCart,
                    child: Text(
                      'Add to Cart',
                      style: AappTextStyle.roboto(
                        color: Colors.white,
                        fontSize: 14.0,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Remove from Wishlist Button
                IconButton(
                  onPressed: onRemoveFromWishlist,
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400]),
                  tooltip: 'Remove from Wishlist',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
