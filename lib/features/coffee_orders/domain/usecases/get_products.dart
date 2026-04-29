import '../entities/coffee_product.dart';
import '../repositories/coffee_order_repository.dart';

class GetProducts {
  final CoffeeOrderRepository repository;

  GetProducts(this.repository);

  Future<List<CoffeeProduct>> call() {
    return repository.getProducts();
  }
}