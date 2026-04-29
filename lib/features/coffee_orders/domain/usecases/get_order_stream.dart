import '../entities/coffee_order.dart';
import '../repositories/coffee_order_repository.dart';

class GetOrderStream {
  final CoffeeOrderRepository repository;

  GetOrderStream(this.repository);

  Stream<CoffeeOrder> call() {
    return repository.orderStream;
  }
}