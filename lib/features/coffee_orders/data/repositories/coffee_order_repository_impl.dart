import 'dart:async';

import '../../../../core/constants/coffee_order_status.dart';
import '../../domain/entities/coffee_order.dart';
import '../../domain/repositories/coffee_order_repository.dart';

class CoffeeOrderRepositoryImpl implements CoffeeOrderRepository {
  final StreamController<CoffeeOrder> _orderController =
      StreamController<CoffeeOrder>.broadcast();

  int _currentStatusIndex = 0;

  CoffeeOrder _currentOrder = const CoffeeOrder(
    id: 1,
    customerName: 'Kevin',
    productName: 'Café americano',
    status: 'Pedido recibido',
  );

  CoffeeOrderRepositoryImpl() {
    _emitOrder();
  }

  @override
  Stream<CoffeeOrder> get orderStream => _orderController.stream;

  @override
  void nextStatus() {
    if (_currentStatusIndex < CoffeeOrderStatus.statuses.length - 1) {
      _currentStatusIndex++;

      _currentOrder = _currentOrder.copyWith(
        status: CoffeeOrderStatus.statuses[_currentStatusIndex],
      );

      _emitOrder();
    }
  }

  @override
  void resetOrder() {
    _currentStatusIndex = 0;

    _currentOrder = const CoffeeOrder(
      id: 1,
      customerName: 'Kevin',
      productName: 'Café americano',
      status: 'Pedido recibido',
    );

    _emitOrder();
  }

  void _emitOrder() {
    _orderController.add(_currentOrder);
  }

  @override
  void dispose() {
    _orderController.close();
  }
}