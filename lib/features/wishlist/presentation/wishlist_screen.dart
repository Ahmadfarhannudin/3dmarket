import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/core/navigation/main_tab.dart';
import 'package:_3dmarket/core/utils/model_source.dart';
import 'package:_3dmarket/features/wishlist/domain/wishlist_state.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  static const _tabs = ['Semua Simpanan', '3D Assets', 'Shaders & Material'];
  static const _categories = [
    'Semua',
    'Karakter & Rig',
    'Environment & Props',
    'Shader / Nodes',
  ];

  String _tab = 'Semua Simpanan';
  String _category = 'Semua';
  String _sort = 'Terbaru Disimpan';

  List<CatalogAsset> _visibleItems(List<CatalogAsset> source) {
    var items = source;
    if (_tab == 'Shaders & Material') items = const [];

    if (_category != 'Semua') {
      final needle = _category.toLowerCase();
      items = items.where((asset) {
        final cat = asset.category.toLowerCase();
        if (needle.startsWith('karakter')) {
          return cat.contains('karakter') || cat.contains('character');
        }
        if (needle.startsWith('environment')) {
          return cat.contains('arsitektur') ||
              cat.contains('props') ||
              cat.contains('environment');
        }
        return false;
      }).toList();
    }

    final sorted = [...items];
    if (_sort == 'Harga Terendah') {
      sorted.sort((a, b) => priceValue(a.price).compareTo(priceValue(b.price)));
    } else if (_sort == 'Harga Tertinggi') {
      sorted.sort((a, b) => priceValue(b.price).compareTo(priceValue(a.price)));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.94),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
        title: const Text(
          'Koleksi & Wishlist',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _snack('Pencarian wishlist segera hadir.'),
            icon: const Icon(Icons.search, size: 22),
          ),
          IconButton(
            onPressed: () => _snack('Tautan koleksi disalin.'),
            icon: const Icon(Icons.share_outlined, size: 20),
          ),
          Container(
            margin: const EdgeInsets.only(right: 14, left: 2),
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 17, color: AppColors.onPrimary),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: WishlistStore.instance,
        builder: (context, _) {
          final all = WishlistStore.instance.items;
          final items = _visibleItems(all);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              _tabPills(),
              const SizedBox(height: 14),
              _heroCard(all),
              const SizedBox(height: 14),
              _categoryChips(all),
              const SizedBox(height: 12),
              _toolbar(items.length, all.length),
              const SizedBox(height: 12),
              if (items.isEmpty)
                _emptyState(showExplore: all.isEmpty)
              else
                for (final asset in items) ...[
                  _wishlistCard(asset),
                  const SizedBox(height: 12),
                ],
              const SizedBox(height: 16),
              _radarNotice(),
            ],
          );
        },
      ),
    );
  }

  // â”€â”€â”€ Bagian atas â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _tabPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final tab in _tabs) ...[
            GestureDetector(
              onTap: () => setState(() => _tab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _tab == tab
                      ? AppColors.primaryContainer
                      : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: _tab == tab
                        ? AppColors.primary.withValues(alpha: 0.35)
                        : AppColors.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 12,
                    fontWeight: _tab == tab ? FontWeight.w700 : FontWeight.w500,
                    color: _tab == tab
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _heroCard(List<CatalogAsset> all) {
    final freeCount = all.where((a) => a.isFree).length;
    final totalValue = all.fold<int>(
      0,
      (sum, asset) => sum + priceValue(asset.price),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'ARSIP KURASI PRIBADI â€¢ ${all.length} ITEM TERSIMPAN',
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Koleksi Favorit & Wishlist',
            style: TextStyle(
              fontFamily: 'Noto Serif',
              fontSize: 25,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Daftar pantau aset 3D Blender pilihan untuk proyek produksi, '
            'animasi, dan game dev. Dapatkan notifikasi saat terjadi '
            'penurunan harga atau pembaruan berkas terbaru.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _stat('${all.length} Model', 'Tersimpan'),
              ),
              _statDivider(),
              Expanded(
                child: _stat('$freeCount Aset', 'Gratis'),
              ),
              _statDivider(),
              Expanded(
                child: _stat(_compactRupiah(totalValue), 'Nilai Portofolio'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 10,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _statDivider() => Container(
        width: 1,
        height: 30,
        color: AppColors.outline.withValues(alpha: 0.18),
      );

  Widget _categoryChips(List<CatalogAsset> all) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in _categories) ...[
            GestureDetector(
              onTap: () => setState(() => _category = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _category == category
                      ? AppColors.primary
                      : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  category == 'Semua' ? 'Semua (${all.length})' : category,
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _category == category
                        ? AppColors.onPrimary
                        : AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _toolbar(int visible, int total) {
    return Row(
      children: [
        PopupMenuButton<String>(
          initialValue: _sort,
          onSelected: (value) => setState(() => _sort = value),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'Terbaru Disimpan', child: Text('Terbaru Disimpan')),
            PopupMenuItem(value: 'Harga Terendah', child: Text('Harga Terendah')),
            PopupMenuItem(value: 'Harga Tertinggi', child: Text('Harga Tertinggi')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.22),
              ),
            ),
            child: Row(
              children: [
                Text(
                  _sort,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Menampilkan $visible dari $total',
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 10.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // â”€â”€â”€ Kartu aset â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _wishlistCard(CatalogAsset asset) {
    final isFree = asset.isFree;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.045),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _thumbnail(asset),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.creator.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${asset.category} â€¢ ${asset.sizeLabel} â€¢ '
                      '${asset.format.toUpperCase().replaceAll('.', '')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      asset.price,
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isFree ? AppColors.tertiary : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isFree ? 'Lisensi CC BY 4.0' : 'Lisensi Komersial',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  WishlistStore.instance.remove(asset);
                  _snack('${asset.title} dihapus dari wishlist.');
                },
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.favorite,
                    size: 20,
                    color: Color(0xFFD93A4A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRouter.detail,
                  arguments: asset,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  side: BorderSide(
                    color: AppColors.outline.withValues(alpha: 0.22),
                  ),
                  minimumSize: const Size(0, 38),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Lihat 3D Preview',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRouter.detail,
                  arguments: asset,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  elevation: 0,
                  minimumSize: const Size(0, 38),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  isFree ? 'Unduh Sekarang' : 'Beli Sekarang',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumbnail(CatalogAsset asset) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (asset.hasModelPreview)
              IgnorePointer(
                child: ModelViewer(
                  src: resolveModelSource(asset.assetKey),
                  backgroundColor: AppColors.surfaceContainerLow,
                  autoRotate: true,
                  cameraControls: false,
                  disableZoom: true,
                  disablePan: true,
                  loading: Loading.eager,
                  debugLogging: false,
                  relatedCss: 'model-viewer{--poster-color:transparent;}',
                ),
              )
            else
              Container(
                color: AppColors.surfaceContainerHigh,
                child: const Icon(
                  Icons.view_in_ar,
                  color: AppColors.outline,
                ),
              ),
            Positioned(
              left: 5,
              top: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  asset.format.toUpperCase().replaceAll('.', ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // â”€â”€â”€ Bagian bawah â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _emptyState({required bool showExplore}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _tab == 'Shaders & Material'
                ? 'Belum ada shader tersimpan'
                : 'Belum ada aset tersimpan',
            style: const TextStyle(
              fontFamily: 'Noto Serif',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tekan ikon hati pada kartu aset di Beranda atau Jelajah untuk '
            'menyimpannya ke koleksi ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (showExplore && _tab != 'Shaders & Material') ...[
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () => MainTab.open(context, MainTab.explore),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.travel_explore, size: 17),
              label: const Text(
                'Jelajahi Katalog',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _radarNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              size: 19,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Radar Notifikasi Harga Aktif',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Anda akan menerima sinyal notifikasi ketika kreator '
                  'memberikan voucher promo atau berkas versi Blender terbaru '
                  'dirilis.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _compactRupiah(int value) {
    if (value >= 1000000) {
      final millions = value / 1000000;
      return 'Rp ${millions.toStringAsFixed(millions >= 10 ? 0 : 2).replaceAll('.', ',')} Jt';
    }
    if (value >= 1000) {
      final thousands = value / 1000;
      return 'Rp ${thousands.toStringAsFixed(0)} Rb';
    }
    return 'Rp $value';
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
