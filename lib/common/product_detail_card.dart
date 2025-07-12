import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';

class ProductDetailCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double currentPrice;
  final double originalPrice;
  final bool isDark;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistPressed;
  final VoidCallback? onTap; // Add this for navigation

  final bool isWishlisted;

  const ProductDetailCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.currentPrice,
    required this.originalPrice,
    this.isDark = false,
    this.onAddToCart,
    this.onWishlistPressed,
    this.isWishlisted = false, this.onTap,
  });

  @override
  State<ProductDetailCard> createState() => _ProductDetailCardState();
}

class _ProductDetailCardState extends State<ProductDetailCard> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.grey[900] :AColors.lightGray200,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Wishlist Button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: widget.onWishlistPressed,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: widget.isWishlisted ? Colors.red : Colors.grey[600],
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Details Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      widget.title,
                      style: AappTextStyle.roboto(
                        fontSize: 12,
                        weight: FontWeight.w400,
                        color: widget.isDark ? Colors.white : Colors.black,

                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    // Price Section
                    Row(
                      children: [
                        Text(
                          '\$${widget.currentPrice.toStringAsFixed(2)}',
                          style: AappTextStyle.roboto(
                            fontSize: 12,
                            weight: FontWeight.w500,
                            color: widget.isDark ? Colors.white : Colors.black,

                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${widget.originalPrice.toStringAsFixed(2)}',
                          style: AappTextStyle.roboto(
                            fontSize: 12,
                            weight: FontWeight.w500,
                            color: Colors.grey[500]!,

                          ),

                        ),
                      ],
                    ),


                    SizedBox(height: 4,),
                    // Quantity and Add to Cart Section
                    Row(
                      children: [
                        // Quantity Selector
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: _decrementQuantity,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _incrementQuantity,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.add,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Add to Cart Button
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onAddToCart,
                            child:
                            Container(
                              padding: EdgeInsets.only(top: 4,
                              bottom: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF9800), Color(0xFFFFA726)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF9800).withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child:  Center(
                                child: Text(
                                  'Add cart',
                                  style: AappTextStyle.roboto(
                                    fontSize: 12,
                                    weight: FontWeight.w500,
                                    color: Colors.white,

                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}