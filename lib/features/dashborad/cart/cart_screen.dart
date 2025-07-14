import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afronika/utils/constant/colors.dart';
import '../../../utils/constant/app_test_style.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart items data
  List<CartItem> cartItems = [
    CartItem(
      id: '1',
      imagePath: 'assets/images/product1.png',
      title: 'African Print Shirt',
      price: '\$29.99',
      quantity: 2,
    ),
    CartItem(
      id: '2',
      imagePath: 'assets/images/product2.png',
      title: 'Traditional Dashiki',
      price: '\$45.99',
      quantity: 1,
    ),
    CartItem(
      id: '3',
      imagePath: 'assets/images/product3.png',
      title: 'Ankara Dress',
      price: '\$55.99',
      quantity: 3,
    ),
  ];

  // Check if dark mode is enabled
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  // Calculate total price
  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      double price = double.parse(item.price.replaceAll('\$', ''));
      total += price * item.quantity;
    }
    return total;
  }

  // Calculate total items
  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: AappTextStyle.roboto(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20.0,
            weight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        actions: [
          // Cart item count badge
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalItems items',
                  style: AappTextStyle.roboto(
                    color: Colors.white,
                    fontSize: 12.0,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartCard(
                  imagePath: item.imagePath,
                  title: item.title,
                  price: item.price,
                  isDark: isDark,
                  quantity: item.quantity,
                  onDelete: () => _removeFromCart(item.id),
                  onIncreaseQuantity: () => _increaseQuantity(item.id),
                  onDecreaseQuantity: () => _decreaseQuantity(item.id),
                  onOrder: () => _orderSingleItem(item),
                );
              },
            ),
          ),

          // Bottom Summary and Checkout
          _buildBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: AappTextStyle.roboto(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18.0,
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some items to get started',
            style: AappTextStyle.roboto(
              color: Colors.grey[600]!,
              fontSize: 14.0,
              weight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Continue Shopping',
              style: AappTextStyle.roboto(
                color: Colors.white,
                fontSize: 14.0,
                weight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total ($totalItems items)',
                style: AappTextStyle.roboto(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16.0,
                  weight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: AappTextStyle.roboto(
                  color: AColors.primary,
                  fontSize: 18.0,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _checkoutAll,
              child: Text(
                'Checkout All Items',
                style: AappTextStyle.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Cart functionality methods
  void _removeFromCart(String itemId) {
    setState(() {
      cartItems.removeWhere((item) => item.id == itemId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _increaseQuantity(String itemId) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        cartItems[index].quantity++;
      }
    });
  }

  void _decreaseQuantity(String itemId) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1 && cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  void _orderSingleItem(CartItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Confirmation'),
        content: Text('Order ${item.title} (Quantity: ${item.quantity})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _processOrder([item]);
            },
            child: const Text('Order'),
          ),
        ],
      ),
    );
  }

  void _checkoutAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Checkout Confirmation'),
        content: Text('Checkout all items for \$${totalPrice.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _processOrder(cartItems);
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  void _processOrder(List<CartItem> items) {
    // Here you would typically process the order
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 3),
      ),
    );

    // Remove ordered items from cart
    setState(() {
      for (var item in items) {
        cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      }
    });
  }
}

// CartItem model class
class CartItem {
  final String id;
  final String imagePath;
  final String title;
  final String price;
  int quantity;

  CartItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

// CartCard widget (include this in the same file or import it)
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