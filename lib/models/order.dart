import 'product.dart';

enum DeliveryType { pickup, city, russia }
enum PaymentMethod { card, cashOnDelivery, cardOnDelivery }

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final DeliveryType deliveryType;
  final String? deliveryAddress;
  final PaymentMethod paymentMethod;
  final String customerName;
  final String customerPhone;
  final String customerEmail;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.deliveryType,
    this.deliveryAddress,
    required this.paymentMethod,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
  });
}

class OrderItem {
  final Product product;
  final int quantity;
  final double price;

  const OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });
}