import 'package:flutter/material.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/orders/data/admin_orders_repository.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Bottom sheet detail pesanan beserta aksi pelunasan manual.
void showAdminOrderSheet(
  BuildContext context,
  AdminOrder order, {
  required VoidCallback onMarkPaid,
}) {
    final paid = order.status == AdminOrderStatus.paid;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
              const SizedBox(height: 12),
              adminSheetRow('Status', paid ? 'Lunas' : 'Pending'),
              adminSheetRow('Pembayaran', order.payment),
              adminSheetRow('Nominal', order.amount),
              adminSheetRow('Waktu', order.time),
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

