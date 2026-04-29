import 'package:flutter/material.dart';

import '../../domain/entities/invoice.dart';
import '../widgets/widgets_invoice.dart';

class InvoicePage extends StatelessWidget {
  final Invoice invoice;

  const InvoicePage({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factura #${invoice.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: InvoiceCard(invoice: invoice),
      ),
    );
  }
}