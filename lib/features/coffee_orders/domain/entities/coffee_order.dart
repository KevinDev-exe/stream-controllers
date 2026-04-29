import 'coffee_product.dart';

class CoffeeOrder {
  final int id;
  final String customerName;
  final CoffeeProduct product;
  final int quantity;
  final String status;
  final DateTime createdAt;

  const CoffeeOrder({
    required this.id,
    required this.customerName,
    required this.product,
    required this.quantity,
    required this.status,
    required this.createdAt,
  });

  double get subtotal => product.price * quantity;

  double get tax => subtotal * 0.19;

  double get total => subtotal + tax;

  CoffeeOrder copyWith({
    int? id,
    String? customerName,
    CoffeeProduct? product,
    int? quantity,
    String? status,
    DateTime? createdAt,
  }) {
    return CoffeeOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}