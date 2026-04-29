class CoffeeOrderStatus {
  static const String received = 'Pedido recibido';
  static const String preparing = 'En preparación';
  static const String ready = 'Listo para entregar';
  static const String delivered = 'Entregado';

  static const List<String> statuses = [
    received,
    preparing,
    ready,
    delivered,
  ];
}