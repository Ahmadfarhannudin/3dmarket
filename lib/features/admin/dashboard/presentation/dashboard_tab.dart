import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/catalog/presentation/asset_detail_sheet.dart';
import 'package:_3dmarket/features/admin/catalog/presentation/upload_asset_screen.dart';
import 'package:_3dmarket/features/admin/dashboard/data/admin_dashboard_repository.dart';
import 'package:_3dmarket/features/admin/orders/data/admin_orders_repository.dart';
import 'package:_3dmarket/features/admin/orders/presentation/admin_order_detail_screen.dart';
import 'package:_3dmarket/features/admin/orders/presentation/admin_orders_screen.dart';
import 'package:_3dmarket/features/admin/shared/admin_store.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Tab ringkasan performa studio pada panel admin.
class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key, required this.store});

  final AdminStore store;

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String _period = '30 Hari (Aktif)';

  List<AdminAsset> get _assets => widget.store.assets;
  List<AdminOrder> get _orders => widget.store.orders;
  AdminPeriodMetrics get _metrics => adminPeriodData[_period]!;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => _dashboardBody(),
    );
  }

  void _openUpload() => openUploadAssetScreen(context, widget.store);

  Widget _dashboardBody() {
    final m = _metrics;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            const AdminPill(label: 'Panel Kurator & Pusat Analitik', dot: true),
            const SizedBox(width: 8),
            const Text(
              'v4.2 Sync',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 11,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Studio',
                    style: TextStyle(
                      fontFamily: 'Noto Serif',
                      fontVariations: [FontVariation('wght', 600)],
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Pemantauan distribusi lisensi real-time 3DMarket.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => adminSnack(
                  context,
                  'Laporan $_period diekspor sebagai CSV ke folder Download.',
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_download_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Laporan',
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
            ),
          ],
        ),
        const SizedBox(height: 14),
        _periodSelector(),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AdminMetricCard(
                label: 'Total Pendapatan',
                value: m.revenue,
                icon: Icons.trending_up,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                footer: Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      m.revenueDelta,
                      style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'bln lalu',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminMetricCard(
                label: 'Total Unduhan',
                value: m.downloads,
                suffix: 'Aset',
                icon: Icons.cloud_download_outlined,
                iconBg: AppColors.secondaryContainer,
                iconColor: AppColors.onSecondaryContainer,
                footer: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: m.paid,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const TextSpan(text: ' bayar  Â·  '),
                      TextSpan(
                        text: m.free,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const TextSpan(text: ' gratis'),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AdminMetricCard(
                label: 'Aset Aktif',
                value: '$_activeAssets',
                suffix: 'Model',
                icon: Icons.view_in_ar_outlined,
                iconBg: AppColors.tertiaryFixed,
                iconColor: AppColors.tertiary,
                footer: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_draftAssets draft antre review',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminMetricCard(
                label: 'Pesanan Berhasil',
                value: m.orders,
                suffix: 'Trx',
                icon: Icons.verified_outlined,
                iconBg: AppColors.surfaceContainerHigh,
                iconColor: AppColors.primary,
                footer: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Konversi '),
                      TextSpan(
                        text: m.conversion,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const TextSpan(text: ' studio'),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _chartCard(),
        const SizedBox(height: 18),
        AdminSectionTitle(
          overline: 'Katalog Unggulan',
          title: 'Aset Terlaris',
          trailing: 'Lihat Semua',
          onTrailing: () => context.go(AppRouter.adminCatalog),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < _topAssets.length; i++) ...[
          _bestSellerRow(_topAssets[i], i + 1),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        AdminSectionTitle(
          overline: 'Aktivitas Toko',
          title: 'Transaksi Lisensi Terbaru',
          badge: '3 Baru',
        ),
        const SizedBox(height: 10),
        for (final order in _orders) ...[
          AdminOrderRow(
            order: order,
            onTap: () => showAdminOrderSheet(
              context,
              order,
              onMarkPaid: () => widget.store.markOrderPaid(order),
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        _vaultBanner(),
      ],
    );
  }

  List<AdminAsset> get _topAssets => _assets.take(5).toList();
  int get _activeAssets => _assets.where((a) => a.active).length;
  int get _draftAssets => _assets.where((a) => !a.active).length;
  Widget _periodSelector() {
    const periods = ['7 Hari', '30 Hari (Aktif)', 'Tahun Ini'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final p in periods)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _period = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: _period == p
                        ? AppColors.surfaceContainerLowest
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _period == p
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    p,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontVariations: [
                        FontVariation('wght', _period == p ? 600 : 500),
                      ],
                      fontSize: 11,
                      fontWeight: _period == p
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: _period == p
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chartCard() {
    final m = _metrics;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: adminCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'TREN PERFORMA',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontVariations: [FontVariation('wght', 700)],
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'Blender 4.2 Lead',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Kurva Pendapatan & Lisensi',
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    m.chartTotal,
                    style: const TextStyle(
                      fontFamily: 'Noto Serif',
                      fontVariations: [FontVariation('wght', 700)],
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    'Akumulasi 30 Hari',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 9.5,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < m.bars.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            m.barLabels[i],
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 9.5,
                              fontWeight: i == m.bars.length - 1
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: i == m.bars.length - 1
                                  ? AppColors.primary
                                  : AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AdminBar(
                            fill: m.bars[i],
                            emphasize: i == m.bars.length - 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mg ${i + 1}',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 9.5,
                              fontWeight: i == m.bars.length - 1
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: i == m.bars.length - 1
                                  ? AppColors.primary
                                  : AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _breakdownRow(
            color: AppColors.primary,
            title: 'Standard Commercial',
            subtitle: 'Lisensi studio indie & personal',
            percent: '72%',
            percentColor: AppColors.primary,
          ),
          const SizedBox(height: 6),
          _breakdownRow(
            color: AppColors.tertiary,
            title: 'Extended Studio',
            subtitle: 'Game engine & redistribusi AAA',
            percent: '28%',
            percentColor: AppColors.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _breakdownRow({
    required Color color,
    required String title,
    required String subtitle,
    required String percent,
    required Color percentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            percent,
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: percentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bestSellerRow(AdminAsset asset, int rank) {
    final index = _assets.indexOf(asset);

    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showAdminAssetSheet(
          context,
          asset,
          onManage: () => context.go(AppRouter.adminCatalog),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              AdminAssetThumb(
                imageUrl: index >= 0
                    ? adminAssetImages[index % adminAssetImages.length]
                    : null,
                rank: rank,
                rankHighlight: rank == 1,
              ),
              const SizedBox(width: 12),
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
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          asset.sales,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Â·',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.outline.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (asset.rating == 'Lisensi Terbuka')
                          const Text(
                            'Lisensi Terbuka',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          )
                        else
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 11,
                                color: AppColors.tertiary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                asset.rating,
                                style: const TextStyle(
                                  fontFamily: 'Public Sans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (asset.free)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Gratis',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  else
                    Text(
                      asset.price,
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: rank == 1
                            ? AppColors.primary
                            : AppColors.onSurface,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    asset.format,
                    style: const TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 9.5,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vaultBanner() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF3366CC)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -28,
            child: Icon(
              Icons.view_in_ar,
              size: 120,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: AppColors.primaryFixed,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'CLOUD VAULT AKTIF',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontVariations: [FontVariation('wght', 700)],
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.primaryFixed,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '100% Enkripsi SHA-256',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Siap Memperluas Galeri 3D Anda?',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Model terverifikasi langsung masuk jaringan katalog global '
                  '3DMarket.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextButton.icon(
                          onPressed: _openUpload,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.surfaceContainerLowest,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle_outline, size: 16),
                          label: const Text(
                            'Upload Model Baru',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: TextButton(
                        onPressed: () => context.go(AppRouter.adminSettings),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.10),
                          foregroundColor: AppColors.onPrimary,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.tune, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* -------------------------------- Katalog ------------------------------- */
}
