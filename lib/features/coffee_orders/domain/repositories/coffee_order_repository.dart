import '../entities/coffee_order.dart';

abstract class CoffeeOrderRepository {
  Stream<CoffeeOrder> get orderStream;

  void nextStatus();

  void resetOrder();

  void dispose();
}