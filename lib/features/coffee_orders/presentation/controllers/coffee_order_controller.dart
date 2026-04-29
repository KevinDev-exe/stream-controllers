import '../../data/repositories/coffee_order_repository_impl.dart';
import '../../domain/entities/coffee_order.dart';
import '../../domain/usecases/get_order_stream.dart';
import '../../domain/usecases/next_order_status.dart';
import '../../domain/usecases/reset_order.dart';

class CoffeeOrderController {
  final CoffeeOrderRepositoryImpl _repository = CoffeeOrderRepositoryImpl();

  late final GetOrderStream _getOrderStream;
  late final NextOrderStatus _nextOrderStatus;
  late final ResetOrder _resetOrder;

  CoffeeOrderController() {
    _getOrderStream = GetOrderStream(_repository);
    _nextOrderStatus = NextOrderStatus(_repository);
    _resetOrder = ResetOrder(_repository);
  }

  Stream<CoffeeOrder> get orderStream => _getOrderStream();

  void nextStatus() {
    _nextOrderStatus();
  }

  void resetOrder() {
    _resetOrder();
  }

  void dispose() {
    _repository.dispose();
  }
}