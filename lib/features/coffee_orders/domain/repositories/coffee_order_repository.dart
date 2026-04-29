import '../entities/coffee_order.dart';
import '../entities/coffee_product.dart';
import '../entities/invoice.dart';

abstract class CoffeeOrderRepository {
  Stream<List<CoffeeOrder>> get ordersStream;

  Stream<Invoice?> get invoiceStream;

  Future<List<CoffeeProduct>> getProducts();

  void createOrder({
    required String customerName,
    required CoffeeProduct product,
    required int quantity,
  });

  void nextStatus(int orderId);

  void generateInvoice(int orderId);

  void resetOrders();

  void dispose();
}