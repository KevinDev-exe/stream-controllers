import 'package:flutter/material.dart';

import '../../../../core/helpers/currency_helper.dart';
import '../../domain/entities/invoice.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const InvoiceCard({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final order = invoice.order;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.local_cafe,
              size: 70,
              color: Colors.brown,
            ),
            const SizedBox(height: 8),
            const Text(
              'Cafetería Stream',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Factura de venta',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            const Divider(height: 34),
            InvoiceRow(
              label: 'Factura',
              value: '#${invoice.id.toString().padLeft(4, '0')}',
            ),
            InvoiceRow(
              label: 'Pedido',
              value: '#${order.id}',
            ),
            InvoiceRow(
              label: 'Cliente',
              value: order.customerName,
            ),
            InvoiceRow(
              label: 'Fecha',
              value:
                  '${invoice.issuedAt.day}/${invoice.issuedAt.month}/${invoice.issuedAt.year}',
            ),
            const Divider(height: 34),
            InvoiceRow(
              label: 'Producto',
              value: order.product.name,
            ),
            InvoiceRow(
              label: 'Cantidad',
              value: '${order.quantity}',
            ),
            InvoiceRow(
              label: 'Precio unitario',
              value: CurrencyHelper.formatCOP(order.product.price),
            ),
            const Divider(height: 34),
            InvoiceRow(
              label: 'Subtotal',
              value: CurrencyHelper.formatCOP(invoice.subtotal),
            ),
            InvoiceRow(
              label: 'IVA 19%',
              value: CurrencyHelper.formatCOP(invoice.tax),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: InvoiceRow(
                label: 'Total',
                value: CurrencyHelper.formatCOP(invoice.total),
                isTotal: true,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Factura generada correctamente. solo es un mensaje porfe ',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Simular descarga de factura'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.brown,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const InvoiceRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 20 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.brown : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}