import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/utils/model_source.dart';
import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/catalog/presentation/upload_asset_screen.dart';
import 'package:_3dmarket/features/admin/shared/admin_store.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Tab katalog: inventaris model 3D beserta aksi publikasi dan pratinjau.
class AdminCatalogScreen extends StatefulWidget {
  const AdminCatalogScreen({super.key, required this.store});

  final AdminStore store;

  @override
  State<AdminCatalogScreen> createState() => _AdminCatalogScreenState();
}

class _AdminCatalogScreenState extends State<AdminCatalogScreen> {
  String _assetQuery = '';
  String _assetFilter = 'Semua';

  List<AdminAsset> get _assets => widget.store.assets;

  Future<void> _openUpload({AdminAsset? asset}) =>
      openUploadAssetScreen(context, widget.store, asset: asset);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => _catalogTab(),
    );
  }
  Widget _catalogTab() {
    final filtered = _assets.where((a) {
      final matchesQuery = a.title.toLowerCase().contains(
        _assetQuery.toLowerCase(),
      );
      final matchesFilter = switch (_assetFilter) {
        'Aktif' => a.active,
        'Draft' => !a.active,
        _ => true,
      };
      return matchesQuery && matchesFilter;
    }).toList();

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            // Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARSIP KATALOG 3D & INVENTARIS',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: AppColors.tertiary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Kelola Katalog Model',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Metrics band
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _metricCell(
                    label: 'Total Model',
                    value: '${_assets.length}',
                    highlight: true,
                  ),
                  const VerticalDivider(width: 1, thickness: 1, color: Color(0x2E737784)),
                  _metricCell(
                    label: 'Bulan Ini',
                    value: 'Rp 14.8M',
                    highlight: false,
                    accent: AppColors.tertiary,
                  ),
                  const VerticalDivider(width: 1, thickness: 1, color: Color(0x2E737784)),
                  _metricCell(
                    label: 'Tingkat Retensi',
                    value: '99.2%',
                    highlight: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Search
            TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _assetQuery = v),
              style: const TextStyle(fontSize: 12.5),
              decoration: InputDecoration(
                hintText: 'Cari judul aset, format (.blend/.fbx), ID...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: AppColors.outline,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Status chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _statusChip(
                    label: 'Semua (${_assets.length})',
                    active: _assetFilter == 'Semua',
                    onTap: () => setState(() => _assetFilter = 'Semua'),
                  ),
                  const SizedBox(width: 6),
                  _statusChip(
                    label: 'Dipublikasikan (${_assets.where((a)=>a.active).length})',
                    active: _assetFilter == 'Aktif',
                    onTap: () => setState(() => _assetFilter = 'Aktif'),
                  ),
                  const SizedBox(width: 6),
                  _statusChip(
                    label: 'Draft (${_assets.where((a)=>!a.active).length})',
                    active: _assetFilter == 'Draft',
                    onTap: () => setState(() => _assetFilter = 'Draft'),
                  ),
                  const SizedBox(width: 6),
                  _statusChip(
                    label: 'Diarsipkan (0)',
                    active: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Secondary filter row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Urutkan:',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Terbaru Ditambahkan',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const Icon(
                        Icons.expand_more,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Kategori:',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Semua Kategori',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const Icon(
                        Icons.tune,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Asset cards
            if (filtered.isEmpty)
              const AdminEmptyState(
                icon: Icons.inventory_2_outlined,
                message: 'Tidak ada aset yang cocok dengan filter.',
              )
            else
              for (final asset in filtered) ...[
                _catalogCard(asset),
                const SizedBox(height: 10),
              ],
            // Compatibility notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info,
                      size: 16,
                      color: AppColors.onTertiaryFixed,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '2 Aset Membutuhkan Penyesuaian',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Update kompatibilitas mesh & shader untuk Blender 4.2 LTS tersedia.',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => adminSnack(context, 'Pergi ke halaman inspeksi file.'),
                          child: const Row(
                            children: [
                              Text(
                                'Periksa Sekarang',
                                style: TextStyle(
                                  fontFamily: 'Public Sans',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward,
                                size: 12,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // FAB
        Positioned(
          right: 20,
          bottom: 84,
          child: FloatingActionButton(
            onPressed: _openUpload,
            backgroundColor: const Color(0xFF094CB2),
            foregroundColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.cloud_upload, size: 26),
          ),
        ),
      ],
    );
  }

  final TextEditingController _searchCtrl = TextEditingController();

  Widget _metricCell({
    required String label,
    required String value,
    required bool highlight,
    Color? accent,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 8.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Noto Serif',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.primary : (accent ?? AppColors.onSurface),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 10.5,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _catalogCard(AdminAsset asset) {
    final index = _assets.indexOf(asset);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail 3D / gambar
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: AppColors.surfaceContainerHigh,
                          child: _catalogThumb(asset, index),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withValues(
                            alpha: 0.92,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          asset.format,
                          style: const TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: asset.active
                                ? AppColors.surfaceContainerHigh
                                : AppColors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            asset.active ? 'PUBLIK' : 'DRAFT',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: asset.active
                                  ? AppColors.tertiary
                                  : AppColors.secondary,
                            ),
                          ),
                        ),
                        Text(
                          'Blender 4.2 LTS',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 9.5,
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      asset.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      asset.meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: asset.free ? 'Gratis' : asset.price,
                                  style: TextStyle(
                                    fontFamily: 'Noto Serif',
                                    fontVariations: [
                                      const FontVariation('wght', 700),
                                    ],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: asset.free
                                        ? AppColors.onSurface
                                        : AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: '  Â·  ${asset.sales}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AdminToggleSwitch(
                          value: asset.active,
                          onChanged: (v) {
                            setState(() => asset.active = v);
                            adminSnack(context, 
                              asset.active
                                  ? '${asset.title} dipublikasikan.'
                                  : '${asset.title} dipindah ke draft.',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _openUpload(asset: asset),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: AppColors.onSurface,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Edit Detail',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _preview3d(asset),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_in_ar, size: 16, color: AppColors.primary),
                      SizedBox(width: 5),
                      Text(
                        'Preview 3D',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Thumbnail katalog: utamakan render model 3D asli (.glb), lalu gambar
  /// jaringan, terakhir placeholder ikon.
  Widget _catalogThumb(AdminAsset asset, int index) {
    final modelUrl = asset.modelPath;
    if (modelUrl != null &&
        (asset.format.toLowerCase() == '.glb' ||
            modelUrl.toLowerCase().endsWith('.glb') ||
            modelUrl.startsWith('blob:'))) {
      return Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ModelViewer(
                key: ValueKey('thumb-$modelUrl'),
                src: resolveModelSource(modelUrl),
                backgroundColor: AppColors.surfaceContainerHigh,
                autoRotate: true,
                cameraControls: false,
                disableZoom: true,
                disablePan: true,
                loading: Loading.eager,
                debugLogging: false,
                relatedCss: 'model-viewer{--poster-color:transparent;}',
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _preview3d(asset),
              ),
            ),
          ),
        ],
      );
    }
    if (asset.imageUrl != null) {
      return Image.network(
        asset.imageUrl!,
        fit: BoxFit.cover,
        width: 96,
        height: 96,
        errorBuilder: (_, _, _) => const Icon(
          Icons.view_in_ar,
          size: 30,
          color: AppColors.outline,
        ),
      );
    }
    return const Icon(Icons.view_in_ar, size: 30, color: AppColors.outline);
  }

  void _preview3d(AdminAsset asset) {
    final hasModel = asset.modelPath != null;
    showDialog<void>(
      context: context,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: const Color(0xFF0B0D12),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asset.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Noto Serif',
                              fontVariations: [FontVariation('wght', 600)],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${asset.format}  Â·  ${asset.meta}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 10.5,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.view_in_ar, size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'LIVE 3D',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: hasModel
                  ? ModelViewer(
                      src: resolveModelSource(asset.modelPath!),
                      backgroundColor: const Color(0xFF0B0D12),
                      autoRotate: true,
                      cameraControls: true,
                      loading: Loading.eager,
                      debugLogging: false,
                      relatedCss: 'model-viewer{--poster-color:transparent;}',
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.view_in_ar,
                            size: 46,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Pratinjau 3D belum tersedia untuk\n${asset.title}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              height: 1.4,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _openUpload(asset: asset);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text(
                          'Edit Detail',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text(
                          'Tutup Pratinjau',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}




