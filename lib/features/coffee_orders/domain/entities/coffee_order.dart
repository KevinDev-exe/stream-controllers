class CoffeeOrder {
  final int id;
  final String customerName;
  final String productName;
  final String status;

  const CoffeeOrder({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.status,
  });

  CoffeeOrder copyWith({
    int? id,
    String? customerName,
    String? productName,
    String? status,
  }) {
    return CoffeeOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      productName: productName ?? this.productName,
      status: status ?? this.status,
    );
  }
}