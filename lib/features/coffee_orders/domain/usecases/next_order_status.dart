import '../repositories/coffee_order_repository.dart';

class NextOrderStatus {
  final CoffeeOrderRepository repository;

  NextOrderStatus(this.repository);

  void call() {
    repository.nextStatus();
  }
}