import 'package:flutter/material.dart';

import '../../../../core/constants/coffee_order_status.dart';
import '../../../../core/helpers/currency_helper.dart';
import '../../domain/entities/coffee_order.dart';
import '../../domain/entities/coffee_product.dart';

class CoffeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoffeeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Coffee Orders Manager'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CoffeeHeader extends StatelessWidget {
  const CoffeeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.local_cafe,
          size: 76,
          color: Colors.brown,
        ),
        SizedBox(height: 8),
        Text(
          'Sistema de Pedidos',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Crea pedidos, actualiza estados y genera facturas en tiempo real',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class CoffeeDashboard extends StatelessWidget {
  final List<CoffeeOrder> orders;

  const CoffeeDashboard({
    super.key,
    required this.orders,
  });

  int get pendingOrders {
    return orders
        .where((order) => order.status != CoffeeOrderStatus.delivered)
        .length;
  }

  double get totalSales {
    return orders
        .where((order) => order.status == CoffeeOrderStatus.delivered)
        .fold(0, (previousValue, order) => previousValue + order.total);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DashboardCard(
            title: 'Pedidos',
            value: '${orders.length}',
            icon: Icons.receipt_long,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DashboardCard(
            title: 'Pendientes',
            value: '$pendingOrders',
            icon: Icons.pending_actions,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DashboardCard(
            title: 'Ventas',
            value: CurrencyHelper.formatCOP(totalSales),
            icon: Icons.attach_money,
          ),
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.brown,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoffeeCreateOrderForm extends StatelessWidget {
  final TextEditingController customerController;
  final List<CoffeeProduct> products;
  final CoffeeProduct? selectedProduct;
  final int quantity;
  final ValueChanged<CoffeeProduct?> onProductChanged;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onCreateOrder;

  const CoffeeCreateOrderForm({
    super.key,
    required this.customerController,
    required this.products,
    required this.selectedProduct,
    required this.quantity,
    required this.onProductChanged,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onCreateOrder,
  });

  @override
  Widget build(BuildContext context) {
    final double previewTotal = selectedProduct == null
        ? 0
        : (selectedProduct!.price * quantity) * 1.19;

    return Card(
      elevation: 4,
      color: Colors.brown.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Crear nuevo pedido',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: customerController,
              decoration: const InputDecoration(
                labelText: 'Nombre del cliente',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<CoffeeProduct>(
              value: selectedProduct,
              decoration: const InputDecoration(
                labelText: 'Producto',
                prefixIcon: Icon(Icons.coffee),
              ),
              items: products.map((product) {
                return DropdownMenuItem<CoffeeProduct>(
                  value: product,
                  child: Text(
                    '${product.name} - ${CurrencyHelper.formatCOP(product.price)}',
                  ),
                );
              }).toList(),
              onChanged: onProductChanged,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Text(
                  'Cantidad:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDecreaseQuantity,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onIncreaseQuantity,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total estimado con IVA: ${CurrencyHelper.formatCOP(previewTotal)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCreateOrder,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Crear pedido'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoffeeOrdersSection extends StatelessWidget {
  final List<CoffeeOrder> orders;
  final void Function(int orderId) onNextStatus;
  final void Function(int orderId) onGenerateInvoice;

  const CoffeeOrdersSection({
    super.key,
    required this.orders,
    required this.onNextStatus,
    required this.onGenerateInvoice,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const EmptyOrdersMessage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de pedidos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...orders.map(
          (order) => CoffeeOrderCard(
            order: order,
            onNextStatus: () => onNextStatus(order.id),
            onGenerateInvoice: () => onGenerateInvoice(order.id),
          ),
        ),
      ],
    );
  }
}

class CoffeeOrderCard extends StatelessWidget {
  final CoffeeOrder order;
  final VoidCallback onNextStatus;
  final VoidCallback onGenerateInvoice;

  const CoffeeOrderCard({
    super.key,
    required this.order,
    required this.onNextStatus,
    required this.onGenerateInvoice,
  });

  bool get isDelivered => order.status == CoffeeOrderStatus.delivered;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  child: Text('#${order.id}'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order.customerName,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 14),
            OrderInfoRow(
              icon: Icons.coffee,
              label: 'Producto',
              value: order.product.name,
            ),
            OrderInfoRow(
              icon: Icons.shopping_bag,
              label: 'Cantidad',
              value: '${order.quantity}',
            ),
            OrderInfoRow(
              icon: Icons.payments,
              label: 'Total',
              value: CurrencyHelper.formatCOP(order.total),
            ),
            const SizedBox(height: 14),
            CoffeeStatusTimeline(currentStatus: order.status),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isDelivered ? null : onNextStatus,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Avanzar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onGenerateInvoice,
                    icon: const Icon(Icons.receipt),
                    label: const Text('Factura'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.brown,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const OrderInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.brown,
            size: 21,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.brown,
    );
  }
}

class CoffeeStatusTimeline extends StatelessWidget {
  final String currentStatus;

  const CoffeeStatusTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: CoffeeOrderStatus.statuses.map((status) {
        final bool isActive = status == currentStatus;
        final bool isCompleted = CoffeeOrderStatus.statuses.indexOf(status) <=
            CoffeeOrderStatus.statuses.indexOf(currentStatus);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isCompleted ? Colors.brown : Colors.grey,
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  status,
                  style: TextStyle(
                    fontWeight:
                        isActive ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.brown : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class EmptyOrdersMessage extends StatelessWidget {
  const EmptyOrdersMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          children: const [
            Icon(
              Icons.receipt_long,
              size: 60,
              color: Colors.brown,
            ),
            SizedBox(height: 12),
            Text(
              'Aún no hay pedidos registrados.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Crea un pedido para verlo en el historial en tiempo real.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoffeeResetButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CoffeeResetButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.restart_alt),
      label: const Text('Reiniciar sistema'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.brown,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}

class CoffeeLoading extends StatelessWidget {
  const CoffeeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.brown,
      ),
    );
  }
}