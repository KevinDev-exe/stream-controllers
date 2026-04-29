import 'package:flutter/material.dart';

import '../../domain/entities/coffee_order.dart';
import '../controllers/coffee_order_controller.dart';
import '../widgets/widgets_coffee.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({super.key});

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  final CoffeeOrderController _controller = CoffeeOrderController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CoffeeAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<CoffeeOrder>(
          stream: _controller.orderStream,
          initialData: const CoffeeOrder(
            id: 1,
            customerName: 'Kevin',
            productName: 'Café americano',
            status: 'Pedido recibido',
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CoffeeErrorMessage(
                message: 'Error: ${snapshot.error}',
              );
            }

            if (!snapshot.hasData) {
              return const CoffeeLoading();
            }

            final order = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CoffeeHeader(),
                const SizedBox(height: 20),
                CoffeeOrderCard(order: order),
                const SizedBox(height: 20),
                CoffeeStatusTimeline(currentStatus: order.status),
                const Spacer(),
                CoffeeActions(
                  onNextStatus: _controller.nextStatus,
                  onReset: _controller.resetOrder,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}