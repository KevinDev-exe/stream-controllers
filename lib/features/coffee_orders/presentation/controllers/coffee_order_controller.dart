import '../../data/datasources/coffee_order_remote_data_source.dart';
import '../../data/repositories/coffee_order_repository_impl.dart';
import '../../domain/entities/coffee_order.dart';
import '../../domain/entities/coffee_product.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/generate_invoice.dart';
import '../../domain/usecases/get_invoice_stream.dart';
import '../../domain/usecases/get_orders_stream.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/next_order_status.dart';
import '../../domain/usecases/reset_orders.dart';

class CoffeeOrderController {
  late final CoffeeOrderRepositoryImpl _repository;

  late final GetProducts _getProducts;
  late final GetOrdersStream _getOrdersStream;
  late final GetInvoiceStream _getInvoiceStream;
  late final CreateOrder _createOrder;
  late final NextOrderStatus _nextOrderStatus;
  late final GenerateInvoice _generateInvoice;
  late final ResetOrders _resetOrders;

  CoffeeOrderController() {
    _repository = CoffeeOrderRepositoryImpl(
      remoteDataSource: CoffeeOrderRemoteDataSource(),
    );

    _getProducts = GetProducts(_repository);
    _getOrdersStream = GetOrdersStream(_repository);
    _getInvoiceStream = GetInvoiceStream(_repository);
    _createOrder = CreateOrder(_repository);
    _nextOrderStatus = NextOrderStatus(_repository);
    _generateInvoice = GenerateInvoice(_repository);
    _resetOrders = ResetOrders(_repository);
  }

  Stream<List<CoffeeOrder>> get ordersStream => _getOrdersStream();

  Stream<Invoice?> get invoiceStream => _getInvoiceStream();

  Future<List<CoffeeProduct>> getProducts() {
    return _getProducts();
  }

  void createOrder({
    required String customerName,
    required CoffeeProduct product,
    required int quantity,
  }) {
    _createOrder(
      customerName: customerName,
      product: product,
      quantity: quantity,
    );
  }

  void nextStatus(int orderId) {
    _nextOrderStatus(orderId);
  }

  void generateInvoice(int orderId) {
    _generateInvoice(orderId);
  }

  void resetOrders() {
    _resetOrders();
  }

  void dispose() {
    _repository.dispose();
  }
}