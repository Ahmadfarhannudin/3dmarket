import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/core/utils/model_source.dart';
import 'package:_3dmarket/core/widgets/buyer_app_bar.dart';

class MyAssetsScreen extends StatefulWidget {
  const MyAssetsScreen({super.key});

  @override
  State<MyAssetsScreen> createState() => _MyAssetsScreenState();
}

class _MyAssetsScreenState extends State<MyAssetsScreen> {
  String _filter = 'Semua';
  String _query = '';

  @override
  void initState() {
    super.initState();
    PurchaseStore.instance.addListener(_onPurchasesChanged);
  }

  @override
  void dispose() {
    PurchaseStore.instance.removeListener(_onPurchasesChanged);
    super.dispose();
  }

  void _onPurchasesChanged() => setState(() {});

  static const _baseAssets = <_MyAsset>[
    _MyAsset(
      title: 'Cyberpunk Cybernetic Arm Rigged',
      size: '48.6 MB',
      format: '.blend, .glb',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBn7CiEtaV9snGX3LtBMXVpd8S4R0_0lNpYQj4DNR3uTTbBjZ79a_nYW96Wm0sNTD5u5QK636XtiOmlIWI7Iby-KaRPN4YgXBOFpRHq5SG8j_yZzMk69IIBaVSiRF1aswlh92iQFv0aYD2l1NgZ-5EreB0cOFJ2LnbJsFY9h4J87OQL1so0IMVGOw-b3BblnzsILQroWBtM6xjH-DyswIFhCzBY5CqIVIO_eiXLeYI',
      license: 'Lisensi Komersial Terverifikasi',
      badge: 'v2.1 Updated',
      canOptions: true,
      free: false,
    ),
    _MyAsset(
      title: 'Chronograph Horology Masterpiece',
      size: '82.0 MB',
      format: '.blend, .glb',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC9LXGENDfI5y4ruOU7bhLIrfsg5LrKEH7BpxPwLCaQJt1MULYJHniLJCV3v_LdaZmyhJPRMV17DYsQghasGcNLO8RBW480IVG7PZPgVYNjaU1R0G4Ypt6xuYaFhtdFORrFbuh2GLz40Xi-H2O4XnnmEouCXuYLQ52h4CeCT665pjIfrsLeUPoEafXR3A5rf0PsJi-FieOwXaS6e2F8tlWm2o1RdpO4X-syRje6mZE',
      license: 'Lisensi Standar',
      canLicense: true,
      free: false,
    ),
    _MyAsset(
      title: 'Medieval Fortress Gate',
      size: '45.0 MB',
      format: '.blend, .fbx',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAwFnT65feGe9t-pA2U10_kTUkIA__VAn28o_CGLVFgFZC5dDvV6m2fbi9wXfuUEIerDxMlMOOCrmPiJDYEJWQKCfO8N5Ns9YznrZCUkwN4M-SWfFTmO4qSdJoWg9rCdBDbYPecwD5P_WxuZtyDYcplbSKhPzSefyczi0XrH-roSiBizMMtPMikZGwjaXJtgGpOo5yha0sWqMmP0RBmcCJg166badJjdOofuAfTEn0',
      license: 'Lisensi Standar',
      free: false,
    ),
    _MyAsset(
      title: 'Stylized Weapon Arsenal',
      size: '12.1 MB',
      format: '.blend, .fbx',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAcpqqeFDh9LCZIhmV_So7o9mzV37DXTGwgOji2eLZw1Gzxnt5ySKJC3-YIg3V2SvZP407dRfQv21jDONd6uz5DEzjYrYoNrdPp72nTKXtW_9i4a1NiCdCMYaB55wgeMo15hrA1l8hRtBHP2VvgRDZTj-vUQSmJRDUuvVAQ996jDKj4Q9pbTgFbGIuIFfhHJVH3X0ZVc0HWkw19E97uBs7yh6wgj5FnVOYB2RkSO_s',
      license: 'Aset Gratis',
      free: true,
    ),
  ];

  List<_MyAsset> get _allAssets {
    final purchased = PurchaseStore.instance.items.map((p) => _MyAsset(
          title: p.title,
          size: p.sizeLabel,
          format: p.format,
          image: p.modelUrl, // Use modelUrl for 3D preview
          license: p.itemPrice == 0
              ? 'Aset Gratis'
              : 'Lisensi Komersial Terverifikasi',
          badge: 'Baru Dibeli',
          canOptions: true,
          free: p.itemPrice == 0,
          isRealModel: true,
        ));
    return [...purchased, ..._baseAssets];
  }

  List<_MyAsset> get _filtered => _allAssets.where((a) {
        final q = _query.toLowerCase();
        final matchesQuery = a.title.toLowerCase().contains(q);
        final matchesFilter = switch (_filter) {
          'Dibeli' => !a.free,
          'Gratis' => a.free,
          _ => true,
        };
        return matchesQuery && matchesFilter;
      }).toList();

  String get _tabLabelSemua => 'Semua (${_allAssets.length})';
  String get _tabLabelDibeli => 'Dibeli (${_allAssets.where((a) => !a.free).length})';
  String get _tabLabelGratis => 'Gratis (${_allAssets.where((a) => a.free).length})';

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BuyerAppBar(section: 'ASET SAYA'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'VAULT KOLEKSI RESMI',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Aset Saya',
            style: TextStyle(
              fontFamily: 'Noto Serif',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              color: AppColors.onSurface,
            ),
          ),
          const Text(
            'Koleksi aset 3D & lisensi yang Anda miliki',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          _storageCard(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Cari di koleksi saya...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                    prefixIcon: const Icon(Icons.search, size: 19),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLowest,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _filterButton(),
            ],
          ),
          const SizedBox(height: 16),
          _tabBar(),
          const SizedBox(height: 16),
          if (_filtered.isEmpty)
            _emptyState()
          else
            for (final asset in _filtered) ...[
              _assetCard(asset),
              const SizedBox(height: 16),
            ],
          const SizedBox(height: 10),
          _guaranteeNotice(),
        ],
      ),
    );
  }

  Widget _storageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PENYIMPANAN TERPAKAI',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Total Unduhan: 1.4 GB',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF009B68),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Arsip Aman\nSelamanya',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 9.5,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () => _toast('Urutan koleksi diperbarui.'),
        icon: const Icon(Icons.tune, size: 20, color: AppColors.onSurface),
      ),
    );
  }

  Widget _tabBar() {
    final tabs = [
      ('Semua', _tabLabelSemua),
      ('Dibeli', _tabLabelDibeli),
      ('Gratis', _tabLabelGratis),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          for (final t in tabs)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _filter = t.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _filter == t.$1
                        ? AppColors.surfaceContainerLowest
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _filter == t.$1
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    t.$2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 11,
                      fontWeight:
                          _filter == t.$1 ? FontWeight.w600 : FontWeight.w500,
                      color:
                          _filter == t.$1 ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _assetCard(_MyAsset asset) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _thumbnail(asset),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (asset.license == 'Aset Gratis')
                      _licenseBadge(asset.license, const Color(0xFFFFF4D6),
                          const Color(0xFF8A5300))
                    else
                      _licenseBadge(asset.license, const Color(0xFFF9E37A),
                          const Color(0xFF211B00)),
                    const SizedBox(height: 6),
                    if (asset.badge != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          asset.badge!,
                          style: const TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      asset.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _specRow(Icons.account_tree_outlined, 'Format: ${asset.format}'),
                    const SizedBox(height: 2),
                    _specRow(Icons.inventory_2_outlined, 'Ukuran: ${asset.size}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: TextButton.icon(
                    onPressed: () => _toast('Arsip ${asset.title} sedang disiapkan...'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: const Icon(Icons.cloud_download_outlined, size: 17),
                    label: Text(
                      'Unduh .blend (${asset.size})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              if (asset.canOptions || asset.canLicense) ...[
                const SizedBox(width: 8),
                if (asset.canOptions)
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextButton(
                        onPressed: () => _toast('Opsi format alternatif dibuka.'),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainer,
                          foregroundColor: AppColors.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Opsi File (.glb, Tekstur 4K)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (asset.canLicense)
                  SizedBox(
                    height: 42,
                    child: TextButton.icon(
                      onPressed: () => _toast('Sertifikat lisensi diunduh.'),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerLow,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: const Icon(Icons.description_outlined, size: 16),
                      label: const Text(
                        'Lihat Lisensi',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumbnail(_MyAsset asset) {
    final img = asset.image;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (asset.isRealModel)
              IgnorePointer(
                child: ModelViewer(
                  src: resolveModelSource(img),
                  backgroundColor: AppColors.surfaceContainer,
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
              Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.surfaceContainer,
                  child: const Icon(Icons.view_in_ar, color: AppColors.outline),
                ),
              ),
            if (img.contains('Weapon'))
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6D5E00),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'Free',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  '4.0+',
                  style: TextStyle(
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

  Widget _licenseBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Public Sans',
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  Widget _specRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 32, color: AppColors.outline),
          SizedBox(height: 8),
          Text(
            'Koleksi belum tersedia.',
            style: TextStyle(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _guaranteeNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.tertiary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jaminan Akses Tanpa Batas',
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'File selalu dapat diunduh ulang tanpa batas waktu. '
                      'Periksa pembaruan node pack di tab Notifikasi.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _toast('Membuka tab Notifikasi...'),
                      child: const Text(
                        'Pembaruan tersedia di tab Notifikasi.',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
}

class _MyAsset {
  const _MyAsset({
    required this.title,
    required this.size,
    required this.format,
    required this.image,
    required this.license,
    this.badge,
    this.canOptions = false,
    this.canLicense = false,
    required this.free,
    this.isRealModel = false,
  });

  final String title;
  final String size;
  final String format;
  final String image;
  final String license;
  final String? badge;
  final bool canOptions;
  final bool canLicense;
  final bool free;
  final bool isRealModel;
}
