import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/utils/model_source.dart';
import 'package:_3dmarket/app/router.dart';

/// Model 3D nyata yang tersedia di `assets/models/characters/`.
const _f14Model = 'assets/models/characters/grumman_f-14_tomcat_fighter_jet.glb';

const _assetImages = [
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBYC6_ziPUYuvCYRTD7qvQ1_6_2KUv973Y8lZ76Q4wvqeYg6cROHL7ovfYvBgDkMadl-lGzRjZw1-pF0fEztAGvtlqmWLLMnDZD_rWoZYQ_ScI9HM1fq9BKicrkl5E63Bb06RdxG0qgfxkBPCHR9Zsq0aGfqWkJd7sCwzm_m_WVrpksTOl4zEIHH829Krd6_FV4Lm9WnpU6lZb5R2PQbfE0KflYArvU1RlsjSdIiHA',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDd22_m6BKlaca7wWpaRryPCE0rqRBNAFHQlxVcdeSpkNMaA2viBsSUaU3Y7ioQPi410KDbxqB3I5rrsmqTpzaJnLu_IctkR7lSnAeO2Vl90bdAmJgqt69UyLVMr4_l_ZYjjnaQ8G4Rptulp-QTl7OUJ3Okvrbh5-365CdHXw1Yy5E3ggwEBnVwb6bGEleky_5yz3XeV-Vnhvo2B9DAbHYD1axn-U0BX1qS8A6YmII',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDyuOJgHGhC_Qnec62DPOCd437Es9tIno52Ur_c_3L8nJ1DHT57NjiPz8G_F5zJoySGD58ZpLnpAFAIxJpkLRxCFtxFreCo20BDik0qZPOcweaydYsclrdYf_S3vqxMW3iTJw3NtHv0GoYwGCloSqvjj71MjIQCCNs2BTZmSAbz_FHItPjpBmRl_NzCBHzE2Gf7bZ91Ip8FfKN9okhjd34hQIMFC-QHlNKYzPHH4Bo',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAfzQ2SHA60z2IwK1GmuiI1JjoH1lRqTnuJj52e1uUfUFTta2Vn8DMKWN9-sU4_kZvbE32skWtoLjMng7q44LJWA0ZMK092BO-FuwZMLYH9PZw9RMBkNJmLd97KpIg2hXdYB_d5x4jW9Dr5o4nBIJGiZSkTFZDzlis4Hnf4E5NiKGZM6EofLi5KbKUgf-ntaGEYPmrLtEtrdYYKvP5iSQjlzt_5IzsuIyP41LoK18A',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm2g3QOPA2tJKWcqMPqpLNPQFj1hVi-ZfAEiYmt7P4QiiH4Ik8urUO9N9ja4jgAjRvQ1bSCKsTgqfy8wZVgIs-cqZ5HhNjFCR8KiRt2QazJhrYBT6hrjNT--F_8tH8wVmgHjEzn5tTWF2Wozdke1Xf0QaY_YvVFkQ4UynoNZFAV1cGvWaSNdCRRZQypBsa0lb8AiYy0JWBfAp6Vcm1pDWWsC3O3hI7DK23DXtdro',
];

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _tab = 0;

  String _period = '30 Hari (Aktif)';

  String _assetQuery = '';
  String _assetFilter = 'Semua';
  String _orderQuery = '';
  String _orderFilter = 'Semua';

  bool _meshValidation = true;
  bool _autoSync = true;
  bool _maintenance = false;

  final _assets = <_AdminAsset>[
    _AdminAsset(
      title: 'Grumman F-14 Tomcat Fighter Jet',
      sales: '76x terjual',
      rating: '4.9',
      price: 'Rp 12,50 Jt',
      format: '.glb',
      meta: 'Kendaraan Â· 32.4 MB Â· 148k Tris',
      modelPath: _f14Model,
      free: false,
      active: true,
    ),
    _AdminAsset(
      title: 'Cybernetic Chrono Arm Mk. IV',
      sales: '128x terjual',
      rating: '4.9',
      price: 'Rp 11,39 Jt',
      format: '.fbx',
      meta: 'Karakter & Siber Â· 48.6 MB Â· 48.2k Quads',
      imageUrl: _assetImages[1],
      free: false,
      active: true,
    ),
    _AdminAsset(
      title: 'Tactical Exo Helmet Armor',
      sales: '84x terjual',
      rating: '4.8',
      price: 'Rp 6,30 Jt',
      format: '.blend',
      meta: 'Karakter & Siber Â· 22.1 MB Â· 31.4k Quads',
      imageUrl: _assetImages[2],
      free: false,
      active: true,
    ),
    _AdminAsset(
      title: 'Chronograph Horology',
      sales: '62x terjual',
      rating: '5.0',
      price: 'Rp 7,13 Jt',
      format: 'Rigged',
      meta: 'Props Â· 18.2 MB Â· 26.0k Quads',
      imageUrl: _assetImages[3],
      free: false,
      active: true,
    ),
    _AdminAsset(
      title: 'Sci-Fi Mech Vanguard-X',
      sales: '45x terjual',
      rating: '4.9',
      price: 'Rp 6,70 Jt',
      format: 'Animated',
      meta: 'Sci-Fi Â· 54.7 MB Â· 96.3k Quads',
      imageUrl: _assetImages[4],
      free: false,
      active: true,
    ),
    _AdminAsset(
      title: 'Stylized Fantasy Arsenal',
      sales: '312x diunduh',
      rating: 'Lisensi Terbuka',
      price: 'Gratis',
      format: 'Low-Poly',
      meta: 'Weapon Â· 6.4 MB Â· 12.8k Tris',
      free: true,
      active: true,
    ),
    _AdminAsset(
      title: 'Nordic Haven Lounge Chair',
      sales: '0x terjual',
      rating: 'Draft',
      price: 'Rp 4,20 Jt',
      format: 'Blend',
      meta: 'Arsitektur Â· 12.0 MB Â· 9.6k Quads',
      free: false,
      active: false,
    ),
  ];

  final _orders = <_AdminOrder>[
    _AdminOrder(
      id: '#ORD-20261110-8921',
      time: '14:32 WIB',
      title: 'Cyberpunk Arm (Standard)',
      payment: 'QRIS Instant',
      amount: 'Rp 91.000',
      status: _OrderStatus.paid,
      note: 'Auto-Sync',
    ),
    _AdminOrder(
      id: '#ORD-20261110-8919',
      time: '12:15 WIB',
      title: 'Tactical Exo Helmet',
      payment: 'GoPay',
      amount: 'Rp 75.000',
      status: _OrderStatus.paid,
      note: 'Auto-Sync',
    ),
    _AdminOrder(
      id: '#ORD-20261109-8890',
      time: 'Kemarin',
      title: 'Mech Vanguard-X (Studio)',
      payment: 'BCA Virtual Account',
      amount: 'Rp 149.000',
      status: _OrderStatus.pending,
      note: '23j tersisa',
    ),
  ];

  static const _periodData = <String, _PeriodMetrics>{
    '7 Hari': _PeriodMetrics(
      revenue: 'Rp 3,42 Jt',
      revenueDelta: '+6.1%',
      downloads: '286',
      paid: '192',
      free: '94',
      orders: '38',
      conversion: '3.1%',
      chartTotal: 'Rp 3,42 M',
      bars: [0.62, 0.74, 0.88, 1.0],
      barLabels: ['0.7jt', '0.8jt', '1.0jt', '1.1jt'],
    ),
    '30 Hari (Aktif)': _PeriodMetrics(
      revenue: 'Rp 14,85 Jt',
      revenueDelta: '+18.4%',
      downloads: '1.240',
      paid: '842',
      free: '398',
      orders: '162',
      conversion: '4.2%',
      chartTotal: 'Rp 14,85 M',
      bars: [0.53, 0.84, 0.91, 1.0],
      barLabels: ['2.4jt', '3.8jt', '4.1jt', '4.5jt'],
    ),
    'Tahun Ini': _PeriodMetrics(
      revenue: 'Rp 186,4 Jt',
      revenueDelta: '+34.7%',
      downloads: '14.820',
      paid: '9.612',
      free: '5.208',
      orders: '1.842',
      conversion: '5.4%',
      chartTotal: 'Rp 186,4 M',
      bars: [0.41, 0.66, 0.82, 1.0],
      barLabels: ['38jt', '61jt', '76jt', '93jt'],
    ),
  };

  _PeriodMetrics get _metrics => _periodData[_period]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _AdminHeader(tab: _tab),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  _dashboardTab(),
                  _catalogTab(),
                  _ordersTab(),
                  _settingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _AdminNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }

  /* ------------------------------- Dashboard ------------------------------ */

  Widget _dashboardTab() {
    final m = _metrics;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            const _Pill(
              label: 'Panel Kurator & Pusat Analitik',
              dot: true,
            ),
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
                onTap: () => _snack(
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
              child: _MetricCard(
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
                      style: TextStyle(fontSize: 10, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
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
              child: _MetricCard(
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
              child: _MetricCard(
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
        _sectionTitle(
          overline: 'Katalog Unggulan',
          title: 'Aset Terlaris',
          trailing: 'Lihat Semua',
          onTrailing: () => setState(() => _tab = 1),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < _topAssets.length; i++) ...[
          _bestSellerRow(_topAssets[i], i + 1),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        _sectionTitle(
          overline: 'Aktivitas Toko',
          title: 'Transaksi Lisensi Terbaru',
          badge: '3 Baru',
        ),
        const SizedBox(height: 10),
        for (final order in _orders) ...[
          _orderRow(order),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        _vaultBanner(),
      ],
    );
  }

  List<_AdminAsset> get _topAssets => _assets.take(5).toList();
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
      decoration: _cardDecoration(),
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
                          _Bar(
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

  Widget _bestSellerRow(_AdminAsset asset, int rank) {
    final index = _assets.indexOf(asset);

    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAssetSheet(asset),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _AssetThumb(
                imageUrl: index >= 0 ? _assetImages[index % _assetImages.length] : null,
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

  Widget _orderRow(_AdminOrder order) {
    final paid = order.status == _OrderStatus.paid;

    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showOrderSheet(order),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: paid
                      ? AppColors.primaryFixed
                      : AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  paid ? Icons.receipt_long : Icons.hourglass_empty,
                  size: 18,
                  color: paid ? AppColors.primary : AppColors.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            order.id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          order.time,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: paid
                                ? AppColors.primary.withValues(alpha: 0.10)
                                : AppColors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            paid ? 'Lunas' : 'Pending',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: paid
                                  ? AppColors.primary
                                  : AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            order.payment,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: AppColors.secondary,
                            ),
                          ),
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
                  Text(
                    order.amount,
                    style: const TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.note,
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      color: paid ? AppColors.tertiary : AppColors.error,
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
                          onPressed: _showUploadFullPage,
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
                        onPressed: () => setState(() => _tab = 3),
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
              const _EmptyState(
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
                          onTap: () => _snack('Pergi ke halaman inspeksi file.'),
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
            onPressed: _showUploadFullPage,
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

  Widget _catalogCard(_AdminAsset asset) {
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
                        _ToggleSwitch(
                          value: asset.active,
                          onChanged: (v) {
                            setState(() => asset.active = v);
                            _snack(
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
                  onTap: () => _showUploadFullPage(asset: asset),
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
  Widget _catalogThumb(_AdminAsset asset, int index) {
    if (asset.modelPath != null && asset.modelPath!.toLowerCase().endsWith('.glb')) {
      return IgnorePointer(
        child: ModelViewer(
          src: modelSource(asset.modelPath!),
          backgroundColor: AppColors.surfaceContainerHigh,
          autoRotate: true,
          cameraControls: false,
          disableZoom: true,
          disablePan: true,
          loading: Loading.eager,
          debugLogging: false,
          relatedCss: 'model-viewer{--poster-color:transparent;}',
        ),
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

  void _preview3d(_AdminAsset asset) {
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
                      src: modelSource(asset.modelPath!),
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
                          _showUploadFullPage(asset: asset);
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

  Future<void> _showUploadFullPage({_AdminAsset? asset}) async {
    final result = await Navigator.push<_UploadResult>(
      context,
      MaterialPageRoute(builder: (_) => _UploadFullPage(asset: asset)),
    );
    if (result == null || !mounted) return;

    if (result.deleted) {
      setState(() => _assets.remove(asset));
      _snack('${asset?.title ?? 'Aset'} dihapus dari katalog.');
      return;
    }

    final updated = result.asset!;
    setState(() {
      if (asset == null) {
        _assets.insert(0, updated);
      } else {
        final i = _assets.indexOf(asset);
        if (i >= 0) _assets[i] = updated;
      }
    });
    _setTab(1);
    _snack(
      asset == null
          ? '${updated.title} ditambahkan ke katalog.'
          : '${updated.title} diperbarui.',
    );
  }

  void _setTab(int index) => setState(() => _tab = index);

  Widget _ordersTab() {
    final filtered = _orders.where((o) {
      final matchesQuery =
          o.title.toLowerCase().contains(_orderQuery.toLowerCase()) ||
          o.id.toLowerCase().contains(_orderQuery.toLowerCase());
      final matchesFilter = switch (_orderFilter) {
        'Lunas' => o.status == _OrderStatus.paid,
        'Pending' => o.status == _OrderStatus.pending,
        _ => true,
      };
      return matchesQuery && matchesFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _tabTitle('Kelola Pesanan', 'Distribusi lisensi', 'ORDER MANAGER'),
        const SizedBox(height: 12),
        _searchField(
          hint: 'Cari ID atau nama aset...',
          onChanged: (v) => setState(() => _orderQuery = v),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final f in ['Semua', 'Lunas', 'Pending'])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _filterChip(
                  label: f,
                  selected: _orderFilter == f,
                  onTap: () => setState(() => _orderFilter = f),
                ),
              ),
            const Spacer(),
            Text(
              '${filtered.length} transaksi',
              style: const TextStyle(fontSize: 10.5, color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const _EmptyState(
            icon: Icons.receipt_long,
            message: 'Belum ada pesanan pada filter ini.',
          ),
        for (final order in filtered) ...[
          _orderRow(order),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  /* ------------------------------- Pengaturan ----------------------------- */

  Widget _settingsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _tabTitle('Pengaturan Studio', 'Konfigurasi operasional', 'SETTINGS'),
        const SizedBox(height: 16),
        _settingsSection(
          'Operasional',
          [
            _SettingsRowData(
              icon: Icons.group_outlined,
              title: 'Kelola Pengguna & Kreator',
              subtitle: '1.420 akun â€¢ 12 permohonan baru',
              onTap: () => _showInfoSheet(
                'Pengguna & Kreator',
                ['1.420 akun aktif', '12 permohonan kreator baru', 'Admin: 3'],
              ),
            ),
            _SettingsRowData(
              icon: Icons.category_outlined,
              title: 'Kelola Kategori & Taksonomi',
              subtitle: '8 kategori aktif',
              onTap: () => _showInfoSheet(
                'Kategori & Taksonomi',
                [
                  'Karakter',
                  'Arsitektur',
                  'Kendaraan',
                  'Sci-Fi',
                  'Props',
                  'Lingkungan',
                  'Weapon',
                  'Material',
                ],
              ),
            ),
            _SettingsRowData(
              icon: Icons.view_carousel_outlined,
              title: 'Kelola Banner & Promosi',
              subtitle: '3 banner aktif',
              onTap: () => _showInfoSheet(
                'Banner & Promosi',
                ['Diskon Rilis 40%', 'Spotlight Kurator', 'Bundle Sci-Fi'],
              ),
            ),
          ],
        ),
        _settingsSection(
          'Penyimpanan & Validasi',
          [
            _SettingsRowData(
              icon: Icons.cloud_outlined,
              title: 'Penyimpanan Berkas 3D',
              subtitle: '248,5 GB dari 1 TB',
              onTap: () => _showInfoSheet(
                'Penyimpanan Berkas 3D',
                ['Terpakai: 248,5 GB', 'Sisa: 775,5 GB', 'Model: 3.842 file'],
              ),
            ),
            _SettingsRowData(
              icon: Icons.verified_user_outlined,
              title: 'Validasi Mesh Otomatis',
              subtitle: 'Cek N-Gons dan non-manifold saat upload',
              trailing: Switch(
                value: _meshValidation,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
                onChanged: (v) => setState(() => _meshValidation = v),
              ),
            ),
            _SettingsRowData(
              icon: Icons.sync,
              title: 'Auto-Sync Lisensi',
              subtitle: 'Sinkronkan status transaksi real-time',
              trailing: Switch(
                value: _autoSync,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
                onChanged: (v) => setState(() => _autoSync = v),
              ),
            ),
            _SettingsRowData(
              icon: Icons.construction_outlined,
              title: 'Mode Maintenance',
              subtitle: 'Sembunyikan katalog dari pembeli',
              trailing: Switch(
                value: _maintenance,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.error,
                onChanged: (v) {
                  setState(() => _maintenance = v);
                  _snack(
                    v
                        ? 'Mode maintenance aktif. Katalog disembunyikan.'
                        : 'Mode maintenance dimatikan.',
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: TextButton.icon(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.login,
              (_) => false,
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.errorContainer.withValues(alpha: 0.40),
              foregroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout, size: 18),
            label: const Text(
              'KELUAR DARI STUDIO ADMIN',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingsSection(String title, List<_SettingsRowData> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: AppColors.secondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                _SettingsRow(data: rows[i]),
                if (i != rows.length - 1)
                  Divider(
                    height: 1,
                    color: AppColors.outline.withValues(alpha: 0.12),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /* --------------------------------- Shared -------------------------------- */

  Widget _tabTitle(String title, String subtitle, String overline) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overline,
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontVariations: [FontVariation('wght', 700)],
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppColors.tertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Noto Serif',
            fontVariations: [FontVariation('wght', 600)],
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: AppColors.onSurface,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.secondary),
        ),
      ],
    );
  }

  Widget _sectionTitle({
    required String overline,
    required String title,
    String? trailing,
    VoidCallback? onTrailing,
    String? badge,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overline.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontVariations: [FontVariation('wght', 600)],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: onTrailing,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  trailing,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  size: 13,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _searchField({
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 12.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: AppColors.secondary),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppColors.secondary,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontVariations: [FontVariation('wght', selected ? 600 : 500)],
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.onPrimary : AppColors.secondary,
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /* --------------------------------- Sheets -------------------------------- */

  void _showAssetSheet(_AdminAsset asset) {
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
              _sheetRow('Terjual', asset.sales),
              _sheetRow('Rating', asset.rating),
              _sheetRow('Harga', asset.price),
              _sheetRow('Format', asset.format),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    setState(() => _tab = 1);
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

  void _showOrderSheet(_AdminOrder order) {
    final paid = order.status == _OrderStatus.paid;

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
              _sheetRow('Status', paid ? 'Lunas' : 'Pending'),
              _sheetRow('Pembayaran', order.payment),
              _sheetRow('Nominal', order.amount),
              _sheetRow('Waktu', order.time),
              const SizedBox(height: 16),
              if (!paid)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        order.status = _OrderStatus.paid;
                        order.note = 'Auto-Sync';
                      });
                      Navigator.pop(sheetContext);
                      _snack('${order.id} ditandai lunas.');
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
                      _snack('Detail ${order.id} dibuka di riwayat transaksi.');
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

  void _showInfoSheet(String title, List<String> items) {
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
                title,
                style: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontVariations: [FontVariation('wght', 600)],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.secondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Header                                   */
/* -------------------------------------------------------------------------- */

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({required this.tab});

  final int tab;

  static const _titles = ['Dashboard', 'Katalog', 'Pesanan', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '3DMARKET',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontVariations: [FontVariation('wght', 700)],
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'STUDIO ADMIN',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _titles[tab],
                  style: const TextStyle(
                    fontFamily: 'Noto Serif',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    height: 1.2,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRouter.notifications,
            ),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none,
                  size: 22,
                  color: AppColors.onSurfaceVariant,
                ),
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 17,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                    Nav                                     */
/* -------------------------------------------------------------------------- */

class _AdminNav extends StatelessWidget {
  const _AdminNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.dashboard, label: 'Dashboard'),
    (icon: Icons.inventory_2, label: 'Katalog'),
    (icon: Icons.shopping_bag, label: 'Pesanan'),
    (icon: Icons.settings, label: 'Pengaturan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _items[i].icon,
                          size: 22,
                          color: i == currentIndex
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].label,
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontVariations: [
                              FontVariation(
                                'wght',
                                i == currentIndex ? 600 : 400,
                              ),
                            ],
                            fontSize: 10,
                            letterSpacing: -0.1,
                            height: 1.1,
                            fontWeight: i == currentIndex
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: i == currentIndex
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                  Components                                */
/* -------------------------------------------------------------------------- */

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.footer,
    this.suffix,
  });

  final String label;
  final String value;
  final String? suffix;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    height: 1.3,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value),
                if (suffix != null)
                  TextSpan(
                    text: ' $suffix',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  ),
              ],
            ),
            style: const TextStyle(
              fontFamily: 'Noto Serif',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              height: 1.1,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          footer,
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fill, required this.emphasize});

  final double fill;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final trackColor = emphasize
        ? AppColors.primaryFixed
        : AppColors.surfaceContainerHigh;

    return Container(
      height: emphasize ? 92 : 74,
      width: double.infinity,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: fill,
          child: Container(
            decoration: BoxDecoration(
              gradient: emphasize
                  ? const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.primary, Color(0xFF3366CC)],
                    )
                  : null,
              color: emphasize ? null : AppColors.primary.withValues(alpha: 0.80),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: emphasize ? 5 : 0),
            child: emphasize
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.onPrimary,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _AssetThumb extends StatelessWidget {
  const _AssetThumb({
    required this.imageUrl,
    this.rank,
    this.rankHighlight = false,
  });

  final String? imageUrl;
  final int? rank;
  final bool rankHighlight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 52,
              height: 52,
              color: AppColors.surfaceContainer,
              child: imageUrl == null
                  ? const Icon(
                      Icons.view_in_ar,
                      size: 22,
                      color: AppColors.outline,
                    )
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.view_in_ar,
                        size: 22,
                        color: AppColors.outline,
                      ),
                    ),
            ),
          ),
          if (rank != null)
            Positioned(
              top: 3,
              left: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: rankHighlight
                      ? AppColors.primary
                      : AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: rankHighlight
                        ? AppColors.onPrimary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.dot = false});

  final String label;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            const _PulseDot(),
            const SizedBox(width: 5),
          ],
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.35,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.tertiary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.outline),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                    Data                                    */
/* -------------------------------------------------------------------------- */

class _AdminAsset {
  _AdminAsset({
    required this.title,
    required this.sales,
    required this.rating,
    required this.price,
    required this.format,
    required this.meta,
    required this.free,
    required this.active,
    this.imageUrl,
    this.modelPath,
  });

  String title;
  String sales;
  String rating;
  String price;
  String format;
  String meta;
  bool free;
  bool active;
  final String? imageUrl;

  /// Path aset `.glb` di dalam bundle (mis. `assets/models/...`).
  final String? modelPath;
}

enum _OrderStatus { paid, pending }

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 40,
        height: 22,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(11),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadFullPage extends StatefulWidget {
  const _UploadFullPage({this.asset});

  final _AdminAsset? asset;

  @override
  State<_UploadFullPage> createState() => _UploadFullPageState();
}

class _UploadResult {
  const _UploadResult.saved(this.asset) : deleted = false;
  const _UploadResult.deleted()
      : asset = null,
        deleted = true;

  final _AdminAsset? asset;
  final bool deleted;
}

class _UploadFullPageState extends State<_UploadFullPage> {
  static const _formats = ['.blend', '.fbx', '.obj', '.glb', '.gltf', '.zip'];
  static const _categories = [
    'Karakter & Siber',
    'Hard Surface & Props',
    'Sci-Fi Mech & Robotika',
    'Visualisasi Arsitektur',
    'Kendaraan & Penerbangan',
    'Lingkungan',
  ];
  static const _dccVersions = [
    'Blender 4.2 LTS',
    'Blender 4.0+',
    'Blender 3.6 LTS',
  ];
  static const _textures = [
    '4K PBR UDIM',
    '2K PBR Standard',
    'Procedural Nodes',
  ];

  late final TextEditingController _titleCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _quadsCtrl;
  late final TextEditingController _descCtrl;
  final _tagCtrl = TextEditingController();

  final _tags = <String>['rigged', 'blender4', 'cyberpunk', 'udim-4k'];
  final _formatsChecked = <String>{'.blend', '.fbx', '.obj', '.glb'};

  Uint8List? _thumbBytes;
  String? _thumbName;
  String? _modelName;
  int? _modelSize;

  late bool _publish;
  String _format = '.glb';
  String _category = 'Karakter & Siber';
  String _dcc = 'Blender 4.2 LTS';
  String _texture = '4K PBR UDIM';

  bool get _isEdit => widget.asset != null;
  String get _modelPreview => widget.asset?.modelPath ?? _f14Model;

  @override
  void initState() {
    super.initState();
    final asset = widget.asset;
    _titleCtrl = TextEditingController(text: asset?.title ?? '');
    _priceCtrl = TextEditingController(
      text: asset == null ? '89.000' : asset.price.replaceAll('Rp ', ''),
    );
    _quadsCtrl = TextEditingController(
      text: asset?.meta.split('Â·').last.trim() ?? '48.200 Quads',
    );
    _descCtrl = TextEditingController(
      text: asset == null
          ? ''
          : '${asset.title} siap pakai untuk cinematic maupun game engine. '
              'Topologi bersih, UV unwrapped, dan tekstur PBR resolusi tinggi.',
    );
    _publish = asset?.active ?? false;
    _format = asset?.format ?? '.glb';
    _category = asset == null
        ? _categories.first
        : (_categories.firstWhere(
            (c) => asset.meta.startsWith(c),
            orElse: () => _categories.first,
          ));
    _modelName = asset?.title.toLowerCase().replaceAll(' ', '_');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _quadsCtrl.dispose();
    _descCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) return;
    setState(() {
      _thumbBytes = file.bytes;
      _thumbName = file.name;
    });
  }

  Future<void> _pickModel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['blend', 'fbx', 'obj', 'glb', 'gltf', 'zip'],
    );
    final file = result?.files.single;
    if (file == null) return;
    setState(() {
      _modelName = file.name;
      _modelSize = file.size;
      final dot = file.name.lastIndexOf('.');
      if (dot > 0) {
        final ext = file.name.substring(dot).toLowerCase();
        if (_formats.contains(ext)) _format = ext;
      }
    });
    _snack('${file.name} siap diunggah.');
  }

  void _addTag() {
    final value = _tagCtrl.text.trim().replaceAll('#', '');
    if (value.isEmpty) return;
    if (_tags.contains(value)) {
      _snack('Tag #$value sudah ada.');
      return;
    }
    setState(() {
      _tags.add(value);
      _tagCtrl.clear();
    });
  }

  String get _sizeLabel {
    if (_modelSize == null) return '32.4 MB';
    final mb = _modelSize! / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  _AdminAsset _buildAsset({required bool publish}) {
    return _AdminAsset(
      title: _titleCtrl.text.trim(),
      sales: widget.asset?.sales ?? '0x terjual',
      rating: widget.asset?.rating ?? 'Baru',
      price: _priceCtrl.text.trim().isEmpty
          ? 'Gratis'
          : 'Rp ${_priceCtrl.text.trim()}',
      format: _format,
      meta: '$_category Â· $_sizeLabel Â· ${_quadsCtrl.text.trim()}',
      free: _priceCtrl.text.trim().isEmpty,
      active: publish,
      imageUrl: widget.asset?.imageUrl,
      modelPath: _modelPreview,
    );
  }

  void _save({required bool publish}) {
    if (_titleCtrl.text.trim().isEmpty) {
      _snack('Judul model wajib diisi.');
      return;
    }
    Navigator.pop(
      context,
      _UploadResult.saved(_buildAsset(publish: publish)),
    );
  }

  void _delete() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus aset?'),
        content: const Text(
          'Aset akan dihapus dari katalog studio. Tindakan ini tidak bisa '
          'dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context, const _UploadResult.deleted());
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 150),
          children: [
            _header(),
            const SizedBox(height: 16),
            _statusCard(),
            const SizedBox(height: 22),
            _sectionHead(
              '1. Berkas 3D Master & WebGL Preview',
              'Arsip aset geometri presisi tinggi dan model kompresi web.',
              Icons.view_in_ar_outlined,
            ),
            const SizedBox(height: 10),
            _masterFileCard(),
            const SizedBox(height: 10),
            _previewCard(),
            const SizedBox(height: 22),
            _sectionHead(
              '2. Galeri Media & Render',
              'Tampilkan presisi anatomi model melalui visual studio.',
              Icons.photo_library_outlined,
            ),
            const SizedBox(height: 10),
            _thumbnailCard(),
            const SizedBox(height: 22),
            _sectionHead(
              '3. Metadata & Deskripsi Editorial',
              'Taksonomi dan dokumentasi teknis untuk pembeli.',
              Icons.edit_note_outlined,
            ),
            const SizedBox(height: 10),
            _metadataCard(),
            const SizedBox(height: 22),
            _sectionHead(
              '4. Parameter Teknis Geometri',
              'Audit topologi otomatis untuk kesiapan produksi.',
              Icons.tune,
            ),
            const SizedBox(height: 10),
            _technicalCard(),
            const SizedBox(height: 22),
            _sectionHead(
              '5. Monetisasi & Lisensi Komersial',
              'Struktur royalti pencipta dan lisensi studio.',
              Icons.payments_outlined,
            ),
            const SizedBox(height: 10),
            _pricingCard(),
            const SizedBox(height: 18),
            _readinessCard(),
          ],
        ),
      ),
      bottomNavigationBar: _actionBar(),
    );
  }

  /* ------------------------------- Sections ------------------------------- */

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'ADMIN PIPELINE Â· MODE EDIT & UNGGAH',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.primary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'v4.2 Rigged',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: AppColors.tertiary,
                ),
              ),
            ),
            const SizedBox(width: 2),
            IconButton(
              onPressed: () => Navigator.pop(context),
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.close,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _isEdit ? 'Sedang Diedit:' : 'Unggah Model Baru:',
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 11.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _isEdit && _titleCtrl.text.isNotEmpty
              ? _titleCtrl.text
              : 'Model 3D Tanpa Judul',
          style: const TextStyle(
            fontFamily: 'Noto Serif',
            fontVariations: [FontVariation('wght', 700)],
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            height: 1.2,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'ID Aset: #MOD-4289',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 10.5,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }

  Widget _statusCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.public, size: 19, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Katalog',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  _publish
                      ? 'Dipublikasikan (Katalog Publik)'
                      : 'Draft (Tersembunyi)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: _publish ? AppColors.primary : AppColors.tertiary,
                  ),
                ),
              ],
            ),
          ),
          _ToggleSwitch(
            value: _publish,
            onChanged: (v) => setState(() => _publish = v),
          ),
        ],
      ),
    );
  }

  Widget _sectionHead(String title, String subtitle, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontVariations: [FontVariation('wght', 600)],
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.5,
                  height: 1.35,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, size: 18, color: AppColors.outline),
      ],
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _masterFileCard() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'BERKAS SUMBER UTAMA (.blend / .zip)',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              if (_modelName != null) ...[
                const Icon(Icons.verified, size: 13, color: AppColors.primary),
                const SizedBox(width: 3),
                const Text(
                  'Validated',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.view_in_ar,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _modelName ?? 'Belum ada berkas dipilih',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          Text(
                            _sizeLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: AppColors.outline,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: AppColors.outline,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              'Mesh manifold Â· zero N-gon',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _pickModel,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerHighest,
                    foregroundColor: AppColors.onSurface,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _modelName == null ? 'Pilih' : 'Ganti',
                    style: const TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickModel,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Unggah Arsip Tambahan (.zip, .fbx, .obj)',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewCard() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Text(
                      'WEB 3D PREVIEW (.GLB)',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 6),
                    _MiniBadge(label: 'WebGL Ready'),
                  ],
                ),
              ),
              Text(
                _sizeLabel,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: ModelViewer(
                src: modelSource(_modelPreview),
                backgroundColor: AppColors.surfaceContainerHighest,
                autoRotate: true,
                cameraControls: true,
                loading: Loading.eager,
                debugLogging: false,
                relatedCss: 'model-viewer{--poster-color:transparent;}',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.threed_rotation,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              const Expanded(
                child: Text(
                  'Putar & uji orbit 3D langsung di kartu ini',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '60 FPS Normal',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumbnailCard() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'THUMBNAIL UTAMA (16:9)',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Cover Katalog',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onTertiaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: _pickThumbnail,
            borderRadius: BorderRadius.circular(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                width: double.infinity,
                color: AppColors.surfaceContainerHigh,
                child: _thumbBytes != null
                    ? Image.memory(_thumbBytes!, fit: BoxFit.cover)
                    : widget.asset?.imageUrl != null
                        ? Image.network(
                            widget.asset!.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _thumbPlaceholder(),
                          )
                        : _thumbPlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Format JPG / PNG maks 15MB',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: AppColors.outline,
                  ),
                ),
              ),
              Text(
                _thumbName ?? 'Belum ada gambar',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumbPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.add_photo_alternate_outlined,
          size: 30,
          color: AppColors.outline,
        ),
        const SizedBox(height: 6),
        const Text(
          'Ketuk untuk unggah thumbnail',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 11,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _metadataCard() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Judul Model 3D'),
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(fontSize: 13),
            onChanged: (_) => setState(() {}),
            decoration: _inputDecoration('cth: Cybernetic Chrono Arm Mk. IV'),
          ),
          const SizedBox(height: 12),
          _label('Kategori Kurasi'),
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            style: const TextStyle(fontSize: 12.5, color: AppColors.onSurface),
            dropdownColor: AppColors.surfaceContainerLowest,
            icon: const Icon(
              Icons.expand_more,
              size: 20,
              color: AppColors.outline,
            ),
            decoration: _inputDecoration(null),
            items: _categories
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _category = v);
            },
          ),
          const SizedBox(height: 12),
          _label('Tags & Index Pencarian'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tag in _tags)
                _TagChip(
                  label: tag,
                  onRemove: () => setState(() => _tags.remove(tag)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tagCtrl,
                  style: const TextStyle(fontSize: 12),
                  onSubmitted: (_) => _addTag(),
                  decoration: _inputDecoration('Tambah tag baru...'),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _addTag,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHighest,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 38),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '+ Tambah',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _label('Deskripsi Lengkap & Catatan Rilis'),
          TextField(
            controller: _descCtrl,
            maxLines: 4,
            style: const TextStyle(fontSize: 12, height: 1.45),
            decoration: _inputDecoration(
              'Uraikan fitur utama, rigging, dan tekstur aset...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _technicalCard() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Format Berkas Disediakan'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in _formats)
                _CheckPill(
                  label: f,
                  checked: _formatsChecked.contains(f),
                  onTap: () => setState(() {
                    if (!_formatsChecked.remove(f)) _formatsChecked.add(f);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Jumlah Poligon'),
                    TextField(
                      controller: _quadsCtrl,
                      style: const TextStyle(fontSize: 12),
                      decoration: _inputDecoration('48.200 Quads'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Format Utama'),
                    DropdownButtonFormField<String>(
                      initialValue: _format,
                      isExpanded: true,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurface,
                      ),
                      dropdownColor: AppColors.surfaceContainerLowest,
                      decoration: _inputDecoration(null),
                      items: _formats
                          .map(
                            (f) => DropdownMenuItem(value: f, child: Text(f)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _format = v);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Target Versi DCC'),
                    DropdownButtonFormField<String>(
                      initialValue: _dcc,
                      isExpanded: true,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurface,
                      ),
                      dropdownColor: AppColors.surfaceContainerLowest,
                      decoration: _inputDecoration(null),
                      items: _dccVersions
                          .map(
                            (d) => DropdownMenuItem(value: d, child: Text(d)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _dcc = v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Resolusi Tekstur'),
                    DropdownButtonFormField<String>(
                      initialValue: _texture,
                      isExpanded: true,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurface,
                      ),
                      dropdownColor: AppColors.surfaceContainerLowest,
                      decoration: _inputDecoration(null),
                      items: _textures
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _texture = v);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pricingCard() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                _LicenseTab(
                  label: 'Gratis / Komunitas',
                  selected: _priceCtrl.text.trim().isEmpty,
                  onTap: () => setState(() => _priceCtrl.clear()),
                ),
                _LicenseTab(
                  label: 'Premium Komersial',
                  selected: _priceCtrl.text.trim().isNotEmpty,
                  onTap: () {
                    if (_priceCtrl.text.trim().isEmpty) {
                      setState(() => _priceCtrl.text = '89.000');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _label('Standard Commercial License')),
              const Text(
                'Platform Fee 10%',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9.5,
                  color: AppColors.tertiary,
                ),
              ),
            ],
          ),
          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
            onChanged: (_) => setState(() {}),
            decoration: _inputDecoration('0').copyWith(prefixText: 'Rp '),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kosongkan harga untuk menjadikan aset gratis bagi komunitas.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9.5,
              color: AppColors.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _readinessCard() {
    const items = [
      'Mesh manifold & quad only',
      'UV unwrapped zero overlap',
      'Rig bone constraints valid',
      'GLB web viewer tergenerate',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'KESIAPAN PUBLIKASI',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Text(
                _publish ? '100% Siap' : 'Draft',
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: _publish ? 1 : 0.6,
              minHeight: 5,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final item in items)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.96),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextButton.icon(
                        onPressed: () => _save(publish: false),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          foregroundColor: AppColors.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save_outlined, size: 16),
                        label: const Text(
                          'Simpan Draf',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 44,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFF3366CC)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton.icon(
                          onPressed: () => _save(publish: true),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.publish, size: 16),
                          label: const Text(
                            'Publikasikan Model',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isEdit)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: TextButton.icon(
                    onPressed: _delete,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      minimumSize: const Size(0, 26),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.delete_sweep_outlined, size: 14),
                    label: const Text(
                      'Hapus Aset dari Katalog Studio',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /* -------------------------------- Helpers ------------------------------- */

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Public Sans',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11.5,
        color: AppColors.outline,
      ),
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Public Sans',
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 9, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$label',
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 10.5,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 2),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(999),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close, size: 12, color: AppColors.outline),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckPill extends StatelessWidget {
  const _CheckPill({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: checked
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: checked
                ? AppColors.primary.withValues(alpha: 0.35)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              checked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 14,
              color: checked ? AppColors.primary : AppColors.outline,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 10.5,
                fontWeight: checked ? FontWeight.w600 : FontWeight.w500,
                color: checked ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LicenseTab extends StatelessWidget {
  const _LicenseTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceContainerLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 10.5,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminOrder {
  _AdminOrder({
    required this.id,
    required this.time,
    required this.title,
    required this.payment,
    required this.amount,
    required this.status,
    required this.note,
  });

  final String id;
  final String time;
  final String title;
  final String payment;
  final String amount;
  _OrderStatus status;
  String note;
}

class _PeriodMetrics {
  const _PeriodMetrics({
    required this.revenue,
    required this.revenueDelta,
    required this.downloads,
    required this.paid,
    required this.free,
    required this.orders,
    required this.conversion,
    required this.chartTotal,
    required this.bars,
    required this.barLabels,
  });

  final String revenue;
  final String revenueDelta;
  final String downloads;
  final String paid;
  final String free;
  final String orders;
  final String conversion;
  final String chartTotal;
  final List<double> bars;
  final List<String> barLabels;
}

class _SettingsRowData {
  const _SettingsRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.data});

  final _SettingsRowData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  data.icon,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        fontSize: 10.5,
                        height: 1.3,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (data.trailing != null)
                data.trailing!
              else
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

