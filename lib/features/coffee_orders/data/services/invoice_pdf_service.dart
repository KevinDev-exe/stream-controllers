import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/helpers/currency_helper.dart';
import '../../domain/entities/invoice.dart';

class InvoicePdfService {
  Future<void> downloadInvoice(Invoice invoice) async {
    final Uint8List pdfBytes = await _buildInvoicePdf(invoice);

    await FileSaver.instance.saveAs(
      name: 'factura_${invoice.id.toString().padLeft(4, '0')}',
      bytes: pdfBytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  Future<Uint8List> _buildInvoicePdf(Invoice invoice) async {
    final pdf = pw.Document();
    final order = invoice.order;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(18),
                decoration: pw.BoxDecoration(
                  color: PdfColors.brown100,
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'CAFETERIA STREAM',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.brown800,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Factura de venta',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 28),

              pw.Text(
                'Datos de la factura',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),

              _invoiceRow(
                'Factura',
                '#${invoice.id.toString().padLeft(4, '0')}',
              ),
              _invoiceRow('Pedido', '#${order.id}'),
              _invoiceRow('Cliente', order.customerName),
              _invoiceRow(
                'Fecha',
                '${invoice.issuedAt.day}/${invoice.issuedAt.month}/${invoice.issuedAt.year}',
              ),
              _invoiceRow('Estado del pedido', order.status),

              pw.SizedBox(height: 28),

              pw.Text(
                'Detalle del pedido',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),

              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey400,
                  width: 0.8,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.brown100,
                    ),
                    children: [
                      _tableHeader('Producto'),
                      _tableHeader('Cantidad'),
                      _tableHeader('Precio'),
                      _tableHeader('Total'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _tableCell(order.product.name),
                      _tableCell(order.quantity.toString()),
                      _tableCell(
                        CurrencyHelper.formatCOP(order.product.price),
                      ),
                      _tableCell(
                        CurrencyHelper.formatCOP(order.subtotal),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 28),

              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 230,
                  child: pw.Column(
                    children: [
                      _invoiceRow(
                        'Subtotal',
                        CurrencyHelper.formatCOP(invoice.subtotal),
                      ),
                      _invoiceRow(
                        'IVA 19%',
                        CurrencyHelper.formatCOP(invoice.tax),
                      ),
                      pw.Divider(),
                      _invoiceRow(
                        'TOTAL',
                        CurrencyHelper.formatCOP(invoice.total),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  'Gracias por su compra. Esta factura fue generada desde la aplicación Coffee Orders Manager utilizando Flutter y StreamController.',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    fontSize: 11,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _invoiceRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: isTotal ? 15 : 12,
                fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isTotal ? 15 : 12,
              fontWeight: pw.FontWeight.bold,
              color: isTotal ? PdfColors.brown800 : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.brown800,
        ),
      ),
    );
  }

  pw.Widget _tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text),
    );
  }
}