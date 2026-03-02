import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../shared/models/order.dart';

class InvoiceGenerator {
  static Future<void> generateAndShareInvoice(Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(order),
              pw.SizedBox(height: 32),
              _buildCustomerInfo(order),
              pw.SizedBox(height: 32),
              _buildItemsTable(order),
              pw.Spacer(),
              _buildTotal(order),
              pw.SizedBox(height: 32),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'CROMA_INVOICE_${order.id.substring(0, 8).toUpperCase()}.pdf',
    );
  }

  static pw.Widget _buildHeader(Order order) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('CROMA', style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold, letterSpacing: 4)),
            pw.Text('PREMIUM FACTORY', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('RECIBO / INVOICE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text('#${order.id.substring(0, 12).toUpperCase()}', style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 4),
            pw.Text(
              '${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')}',
              style: pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCustomerInfo(Order order) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('ENVIAR A / BILL TO:', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              pw.SizedBox(height: 4),
              pw.Text(order.shippingAddress.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.Text(order.shippingAddress.address, style: const pw.TextStyle(fontSize: 10)),
              pw.Text('${order.shippingAddress.city}, ${order.shippingAddress.postalCode}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text(order.shippingAddress.country, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('ESTADO / STATUS:', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              pw.SizedBox(height: 4),
              pw.Text(order.status.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(Order order) {
    return pw.Table(
      border: const pw.TableBorder(
        bottom: pw.BorderSide(color: PdfColors.grey300),
        horizontalInside: pw.BorderSide(color: PdfColors.grey200),
      ),
      children: [
        // Table Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('PRODUCTO', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('TALLA', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('CANT', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('PRECIO', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
          ],
        ),
        // Table Items
        ...order.items.map((item) {
          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(item.productName, style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(item.size, style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(item.quantity.toString(), style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('${item.price.toStringAsFixed(2)} EUR', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right)),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTotal(Order order) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: pw.BoxDecoration(
            color: PdfColors.black,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('TOTAL', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 14)),
              pw.Text('${order.totalAmount.toStringAsFixed(2)} EUR', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text('CROMA PREMIUM STORE', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
          pw.SizedBox(height: 2),
          pw.Text('Gracias por tu compra. Para devoluciones visita tu panel de usuario.', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
        ],
      ),
    );
  }
}
