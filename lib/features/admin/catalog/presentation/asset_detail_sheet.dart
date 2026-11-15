import 'package:flutter/material.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Ringkasan singkat sebuah aset katalog beserta jalan pintas ke tab Katalog.
void showAdminAssetSheet(
  BuildContext context,
  AdminAsset asset, {
  required VoidCallback onManage,
}) {
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    asset.title,
                    style: const TextStyle(
                      fontFamily: 'Noto Serif',
                      fontVariations: [FontVariation('wght', 600)],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: asset.active
                        ? AppColors.primary.withValues(alpha: 0.10)
                        : AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    asset.active ? 'AKTIF' : 'DRAFT',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: asset.active
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            adminSheetRow('Terjual', asset.sales),
            adminSheetRow('Rating', asset.rating),
            adminSheetRow('Harga', asset.price),
            adminSheetRow('Format', asset.format),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  onManage();
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Kelola di Katalog'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
