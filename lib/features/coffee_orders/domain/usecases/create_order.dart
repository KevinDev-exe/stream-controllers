import '../entities/coffee_product.dart';
import '../repositories/coffee_order_repository.dart';

class CreateOrder {
  final CoffeeOrderRepository repository;

  CreateOrder(this.repository);

  void call({
    required String customerName,
    required CoffeeProduct product,
    required int quantity,
  }) {
    repository.createOrder(
      customerName: customerName,
      product: product,
      quantity: quantity,
    );
  }
}