import 'package:flutter/material.dart';

import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/catalog/presentation/upload_asset_screen.dart';
import 'package:_3dmarket/features/admin/shared/admin_store.dart';

/// Halaman ubah detail aset yang sudah ada.
///
/// Memakai formulir yang sama dengan [UploadAssetScreen] agar konsistensi UI
/// dan validasi tetap terjaga.
class EditAssetScreen extends StatelessWidget {
  const EditAssetScreen({super.key, required this.asset});

  final AdminAsset asset;

  static Future<void> open(BuildContext context, AdminStore store, AdminAsset asset) {
    return openUploadAssetScreen(context, store, asset: asset);
  }

  @override
  Widget build(BuildContext context) => UploadAssetScreen(asset: asset);
}
