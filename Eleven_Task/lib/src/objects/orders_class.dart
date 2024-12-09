import 'package:intl/intl.dart';

class Order {
  final int id;
  final int userId;
  final DateTime createdAt;
  final double totalPrice;

  Order({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
      totalPrice: json['total_price'],
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int goodId;
  final int quantity;
  final String productName;
  final double productPrice;
  final String? productImage;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.goodId,
    required this.quantity,
    required this.productName,
    required this.productPrice,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      goodId: json['good_id'],
      quantity: json['quantity'],
      productName: json['product_name'],
      productPrice: json['product_price'].toDouble(),
      productImage: json['product_image'],
    );
  }
}

