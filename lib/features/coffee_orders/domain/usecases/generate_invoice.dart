import '../repositories/coffee_order_repository.dart';

class GenerateInvoice {
  final CoffeeOrderRepository repository;

  GenerateInvoice(this.repository);

  void call(int orderId) {
    repository.generateInvoice(orderId);
  }
}