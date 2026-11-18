import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/invoice_pdf_generator.dart';
import 'package:_3dmarket/core/data/license_pdf_generator.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';

/// Detail satu transaksi sekaligus titik unduh faktur dan sertifikat lisensi.
///
/// Seluruh isi halaman diambil dari [PurchaseRecord] milik transaksi tersebut
/// sehingga cocok dengan metadata aset yang dibeli.
class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.record});

  final PurchaseRecord record;

  @override
  Widget build(BuildContext context) {
    final isCommercial = record.itemPrice > 0;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          isCommercial ? 'Faktur Pembelian' : 'Detail Unduhan',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            InvoicePdfGenerator.invoiceNumber(record.orderId),
                            style: const TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record.purchasedAtLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8FAF1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isCommercial ? 'Lunas' : 'Selesai',
                        style: const TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF006C4A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  record.title,
                  style: const TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kreator: ${record.creator}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 28),
                _Row('Kategori', record.category),
                _Row('Format', record.format.toUpperCase()),
                _Row('Ukuran Berkas', record.sizeLabel),
                _Row('Metode Pembayaran', record.paymentMethod),
                _Row('ID Pesanan', record.orderId),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _Row('Harga Aset', record.itemPriceLabel),
                _Row(
                  'Biaya Layanan',
                  record.serviceFee == 0
                      ? 'Gratis'
                      : formatRupiah(record.serviceFee),
                ),
                const Divider(height: 24),
                _Row('Total Dibayar', record.totalLabel, emphasize: true),
              ],
            ),
          ),
          if (isCommercial) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KUNCI LISENSI KOMERSIAL',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    record.licenseKey,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () => InvoicePdfGenerator.showPreview(context, record),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.receipt_long_outlined, size: 19),
              label: const Text(
                'Preview & Unduh Faktur PDF',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => LicensePdfGenerator.showPreview(context, record),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side:
                    BorderSide(color: AppColors.primary.withValues(alpha: 0.45)),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.workspace_premium_outlined, size: 19),
              label: const Text(
                'Preview & Unduh Sertifikat Lisensi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Faktur adalah bukti transaksi keuangan. Hak pakai aset diatur '
              'dalam Sertifikat Lisensi Komersial dengan kode lisensi di atas. '
              'Lisensi perpetual berlaku untuk proyek komersial tanpa royalti '
              'tambahan; redistribusi file mentah dilarang.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lisensi Penggunaan Gratis',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Aset ini gratis untuk penggunaan personal dan edukasi. Anda dapat menggunakan aset ini dalam portofolio atau proyek non-komersial.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.secondary),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: emphasize ? 16 : 13,
                color: emphasize ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
