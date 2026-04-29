import '../entities/invoice.dart';
import '../repositories/coffee_order_repository.dart';

class GetInvoiceStream {
  final CoffeeOrderRepository repository;

  GetInvoiceStream(this.repository);

  Stream<Invoice?> call() {
    return repository.invoiceStream;
  }
}