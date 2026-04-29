import 'package:flutter/material.dart';

import '../../../../core/constants/coffee_order_status.dart';
import '../../domain/entities/coffee_order.dart';

class CoffeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoffeeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Control de pedidos'),
      centerTitle: true,
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CoffeeHeader extends StatelessWidget {
  const CoffeeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(
          Icons.local_cafe,
          size: 80,
          color: Colors.brown,
        ),
        SizedBox(height: 10),
        Text(
          'Cafetería Stream',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Seguimiento del pedido en tiempo real',
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

class CoffeeOrderCard extends StatelessWidget {
  final CoffeeOrder order;

  const CoffeeOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.brown.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderInfoRow(
              icon: Icons.confirmation_number,
              label: 'Pedido',
              value: '#${order.id}',
            ),
            const SizedBox(height: 12),
            OrderInfoRow(
              icon: Icons.person,
              label: 'Cliente',
              value: order.customerName,
            ),
            const SizedBox(height: 12),
            OrderInfoRow(
              icon: Icons.coffee,
              label: 'Producto',
              value: order.productName,
            ),
            const SizedBox(height: 12),
            OrderInfoRow(
              icon: Icons.sync,
              label: 'Estado',
              value: order.status,
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
    return Row(
      children: [
        Icon(icon, color: Colors.brown),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
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
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isCompleted ? Colors.brown : Colors.grey,
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
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

class CoffeeActions extends StatelessWidget {
  final VoidCallback onNextStatus;
  final VoidCallback onReset;

  const CoffeeActions({
    super.key,
    required this.onNextStatus,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onNextStatus,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Cambiar estado del pedido'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reiniciar pedido'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.brown,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}

class CoffeeLoading extends StatelessWidget {
  const CoffeeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CoffeeErrorMessage extends StatelessWidget {
  final String message;

  const CoffeeErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18,
        ),
      ),
    );
  }
}