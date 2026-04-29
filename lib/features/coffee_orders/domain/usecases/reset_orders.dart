import '../repositories/coffee_order_repository.dart';

class ResetOrders {
  final CoffeeOrderRepository repository;

  ResetOrders(this.repository);

  void call() {
    repository.resetOrders();
  }
}