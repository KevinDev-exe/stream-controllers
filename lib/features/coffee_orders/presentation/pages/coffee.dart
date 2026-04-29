import 'package:flutter/material.dart';

import '../../domain/entities/coffee_order.dart';
import '../../domain/entities/coffee_product.dart';
import '../../domain/entities/invoice.dart';
import '../controllers/coffee_order_controller.dart';
import '../widgets/widgets_coffee.dart';
import 'invoice_page.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({super.key});

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  final CoffeeOrderController _controller = CoffeeOrderController();

  final TextEditingController _customerController = TextEditingController();

  List<CoffeeProduct> _products = [];
  CoffeeProduct? _selectedProduct;
  int _quantity = 1;
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    _controller.invoiceStream.listen((invoice) {
      if (!mounted || invoice == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InvoicePage(invoice: invoice),
        ),
      );
    });
  }

  Future<void> _loadProducts() async {
    final products = await _controller.getProducts();

    if (!mounted) return;

    setState(() {
      _products = products;
      _selectedProduct = products.first;
      _isLoadingProducts = false;
    });
  }

  void _createOrder() {
    final String customerName = _customerController.text.trim();

    if (customerName.isEmpty || _selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el cliente y selecciona un producto.'),
        ),
      );
      return;
    }

    _controller.createOrder(
      customerName: customerName,
      product: _selectedProduct!,
      quantity: _quantity,
    );

    _customerController.clear();

    setState(() {
      _quantity = 1;
    });
  }

  @override
  void dispose() {
    _customerController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProducts) {
      return const Scaffold(
        appBar: CoffeeAppBar(),
        body: CoffeeLoading(),
      );
    }

    return Scaffold(
      appBar: const CoffeeAppBar(),
      body: StreamBuilder<List<CoffeeOrder>>(
        stream: _controller.ordersStream,
        initialData: const [],
        builder: (context, snapshot) {
          final List<CoffeeOrder> orders = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CoffeeHeader(),
                const SizedBox(height: 20),
                CoffeeDashboard(orders: orders),
                const SizedBox(height: 20),
                CoffeeCreateOrderForm(
                  customerController: _customerController,
                  products: _products,
                  selectedProduct: _selectedProduct,
                  quantity: _quantity,
                  onProductChanged: (product) {
                    setState(() {
                      _selectedProduct = product;
                    });
                  },
                  onIncreaseQuantity: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  onDecreaseQuantity: () {
                    if (_quantity == 1) return;

                    setState(() {
                      _quantity--;
                    });
                  },
                  onCreateOrder: _createOrder,
                ),
                const SizedBox(height: 20),
                CoffeeOrdersSection(
                  orders: orders,
                  onNextStatus: _controller.nextStatus,
                  onGenerateInvoice: _controller.generateInvoice,
                ),
                const SizedBox(height: 20),
                CoffeeResetButton(
                  onPressed: _controller.resetOrders,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}