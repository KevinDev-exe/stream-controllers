import '../../domain/entities/coffee_order.dart';
import '../../domain/entities/coffee_product.dart';

class CoffeeOrderModel extends CoffeeOrder {
  const CoffeeOrderModel({
    required super.id,
    required super.customerName,
    required super.product,
    required super.quantity,
    required super.status,
    required super.createdAt,
  });

  factory CoffeeOrderModel.fromEntity(CoffeeOrder order) {
    return CoffeeOrderModel(
      id: order.id,
      customerName: order.customerName,
      product: order.product,
      quantity: order.quantity,
      status: order.status,
      createdAt: order.createdAt,
    );
  }

  CoffeeOrderModel copyModelWith({
    int? id,
    String? customerName,
    CoffeeProduct? product,
    int? quantity,
    String? status,
    DateTime? createdAt,
  }) {
    return CoffeeOrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}