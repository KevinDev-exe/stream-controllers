import '../../domain/entities/coffee_order.dart';
import '../../domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.id,
    required super.order,
    required super.issuedAt,
  });

  factory InvoiceModel.fromOrder({
    required int id,
    required CoffeeOrder order,
  }) {
    return InvoiceModel(
      id: id,
      order: order,
      issuedAt: DateTime.now(),
    );
  }
}