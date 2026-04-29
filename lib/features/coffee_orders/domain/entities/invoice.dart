import 'coffee_order.dart';

class Invoice {
  final int id;
  final CoffeeOrder order;
  final DateTime issuedAt;

  const Invoice({
    required this.id,
    required this.order,
    required this.issuedAt,
  });

  double get subtotal => order.subtotal;

  double get tax => order.tax;

  double get total => order.total;
}