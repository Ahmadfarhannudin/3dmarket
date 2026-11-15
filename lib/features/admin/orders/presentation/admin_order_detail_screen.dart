import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:_3dmarket/core/data/license_pdf_generator.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/orders/data/admin_orders_repository.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Bottom sheet detail pesanan beserta aksi pelunasan manual dan informasi lisensi.
void showAdminOrderSheet(
  BuildContext context,
  AdminOrder order, {
  required VoidCallback onMarkPaid,
}) {
    final paid = order.status == AdminOrderStatus.paid;

    // Cari record pembelian jika order ini berasal dari sinkronisasi pembeli.
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                order.title,
                style: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontVariations: [FontVariation('wght', 600)],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${order.creator} • ${order.assetFormat} • ${order.sizeLabel}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 16),
              adminSheetRow('Status', paid ? 'Lunas' : 'Pending'),
              adminSheetRow('Pembayaran', order.payment),
              adminSheetRow('Nominal', order.amount),
              adminSheetRow('Waktu', order.time),
              if (paid) ...[
                const SizedBox(height: 16),
                _LicenseCard(order: order),
                const SizedBox(height: 8),
                if (order.description.isNotEmpty) ...[
                  const Text(
                    'Deskripsi Aset',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final record = PurchaseStore.instance.items.firstWhere(
                        (p) => p.orderId == order.id,
                        orElse: () => _mockRecord(order),
                      );
                      LicensePdfGenerator.showPreview(context, record);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text(
                      'Preview & Unduh Sertifikat Lisensi',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (!paid)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () {
                      onMarkPaid();
                      Navigator.pop(sheetContext);
                      adminSnack(context, '${order.id} ditandai lunas.');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Tandai Lunas'),
                  ),
                ),
              if (paid)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      adminSnack(context, 'Detail ${order.id} dibuka di riwayat transaksi.');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.surfaceContainer,
                      foregroundColor: AppColors.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Lihat Faktur'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

class _LicenseCard extends StatefulWidget {
  const _LicenseCard({required this.order});

  final AdminOrder order;

  @override
  State<_LicenseCard> createState() => _LicenseCardState();
}

class _LicenseCardState extends State<_LicenseCard> {
  bool _copied = false;
  String get _licenseCode => extractLicenseKey(widget.order.id);

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _licenseCode));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.key,
                size: 16,
                color: AppColors.tertiary,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'LISENSI KOMERSIAL DITERBITKAN',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Perpetual',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _licenseCode,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _copy,
                  style: TextButton.styleFrom(
                    foregroundColor: _copied
                        ? const Color(0xFF1B5E20)
                        : AppColors.primary,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    _copied ? Icons.check : Icons.content_copy,
                    size: 14,
                  ),
                  label: Text(
                    _copied ? 'Tersalin!' : 'Salin Kode',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Membuat PurchaseRecord contoh dari AdminOrder saat data pembeli tidak tersedia
/// (mis. order demo atau record sudah dihapus dari store).
PurchaseRecord _mockRecord(AdminOrder order) => PurchaseRecord(
      orderId: order.id,
      licenseKey: extractLicenseKey(order.id),
      title: order.title,
      category: 'Umum',
      format: order.assetFormat,
      sizeLabel: order.sizeLabel,
      creator: order.creator,
      description: order.description,
      modelUrl: '',
      itemPrice: priceValue(order.amount),
      serviceFee: 2000,
      total: priceValue(order.amount) + 2000,
      paymentMethod: order.payment,
      purchasedAt: DateTime.now(),
    );
