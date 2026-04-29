import 'dart:async';

import '../../../../core/constants/coffee_order_status.dart';
import '../../domain/entities/coffee_order.dart';
import '../../domain/entities/coffee_product.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/coffee_order_repository.dart';
import '../datasources/coffee_order_remote_data_source.dart';
import '../models/coffee_order_model.dart';
import '../models/invoice_model.dart';

class CoffeeOrderRepositoryImpl implements CoffeeOrderRepository {
  final CoffeeOrderRemoteDataSource remoteDataSource;

  CoffeeOrderRepositoryImpl({
    required this.remoteDataSource,
  });

  final StreamController<List<CoffeeOrder>> _ordersController =
      StreamController<List<CoffeeOrder>>.broadcast();

  final StreamController<Invoice?> _invoiceController =
      StreamController<Invoice?>.broadcast();

  final List<CoffeeOrder> _orders = [];

  int _nextOrderId = 1;
  int _nextInvoiceId = 1;

  @override
  Stream<List<CoffeeOrder>> get ordersStream => _ordersController.stream;

  @override
  Stream<Invoice?> get invoiceStream => _invoiceController.stream;

  @override
  Future<List<CoffeeProduct>> getProducts() {
    return remoteDataSource.getProducts();
  }

  @override
  void createOrder({
    required String customerName,
    required CoffeeProduct product,
    required int quantity,
  }) {
    final CoffeeOrder order = CoffeeOrderModel(
      id: _nextOrderId,
      customerName: customerName,
      product: product,
      quantity: quantity,
      status: CoffeeOrderStatus.received,
      createdAt: DateTime.now(),
    );

    _nextOrderId++;
    _orders.insert(0, order);
    _emitOrders();
  }

  @override
  void nextStatus(int orderId) {
    final int orderIndex = _orders.indexWhere((order) => order.id == orderId);

    if (orderIndex == -1) return;

    final CoffeeOrder currentOrder = _orders[orderIndex];

    final int currentStatusIndex =
        CoffeeOrderStatus.statuses.indexOf(currentOrder.status);

    if (currentStatusIndex == CoffeeOrderStatus.statuses.length - 1) return;

    final String newStatus =
        CoffeeOrderStatus.statuses[currentStatusIndex + 1];

    final CoffeeOrder updatedOrder = currentOrder.copyWith(
      status: newStatus,
    );

    _orders[orderIndex] = updatedOrder;
    _emitOrders();
  }

  @override
  void generateInvoice(int orderId) {
    final CoffeeOrder? order = _findOrderById(orderId);

    if (order == null) return;

    final Invoice invoice = InvoiceModel.fromOrder(
      id: _nextInvoiceId,
      order: order,
    );

    _nextInvoiceId++;
    _invoiceController.add(invoice);
  }

  @override
  void resetOrders() {
    _orders.clear();
    _nextOrderId = 1;
    _nextInvoiceId = 1;

    _emitOrders();
    _invoiceController.add(null);
  }

  CoffeeOrder? _findOrderById(int orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (_) {
      return null;
    }
  }

  void _emitOrders() {
    _ordersController.add(List.unmodifiable(_orders));
  }

  @override
  void dispose() {
    _ordersController.close();
    _invoiceController.close();
  }
}