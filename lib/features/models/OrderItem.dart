
// Data Models
class OrderItem {
  final String id;
  final String title;
  final String imagePath;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.price,
    required this.quantity,
  });
}

class DeliveryAddress {
  final String address;
  final String city;

  DeliveryAddress({
    required this.address,
    required this.city,
  });
}

class PaymentMethod {
  final String cardNumber;
  final String type;

  PaymentMethod({
    required this.cardNumber,
    required this.type,
  });
}
