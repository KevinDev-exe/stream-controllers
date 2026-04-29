import '../repositories/coffee_order_repository.dart';

class ResetOrder {
  final CoffeeOrderRepository repository;

  ResetOrder(this.repository);

  void call() {
    repository.resetOrder();
  }
}