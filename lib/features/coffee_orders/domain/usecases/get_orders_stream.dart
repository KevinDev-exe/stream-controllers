import '../entities/coffee_order.dart';
import '../repositories/coffee_order_repository.dart';

class GetOrdersStream {
  final CoffeeOrderRepository repository;

  GetOrdersStream(this.repository);

  Stream<List<CoffeeOrder>> call() {
    return repository.ordersStream;
  }
}