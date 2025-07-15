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
