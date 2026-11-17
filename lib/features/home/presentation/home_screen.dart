import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/navigation/main_tab.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/core/data/uploaded_assets.dart';
import 'package:_3dmarket/core/utils/model_source.dart';
import 'package:_3dmarket/core/widgets/asset_card.dart';
import 'package:_3dmarket/core/widgets/buyer_app_bar.dart';
import 'package:_3dmarket/core/widgets/favorite_button.dart';
import 'package:_3dmarket/app/router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<CatalogAsset> _assets = const [];
  bool _loadingAssets = true;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    UploadedAssets.instance.addListener(_onUploadsChanged);
  }

  void _onUploadsChanged() => _loadCatalog();

  Future<void> _loadCatalog() async {
    final items = await AssetCatalog.load();
    if (mounted) {
      setState(() {
        _assets = items;
        _loadingAssets = false;
      });
    }
  }

  @override
  void dispose() {
    UploadedAssets.instance.removeListener(_onUploadsChanged);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BuyerAppBar(section: 'BERANDA'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroduction(context),
            _buildPromoBanner(context),
            _buildCategories(context),
            _buildFeaturedCarousel(context),
            _buildLatestAssets(context),
            _buildCreatorBanner(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
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
              const SizedBox(width: 8),
              const Text(
                'EDISI KHUSUS 2026',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.tertiary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Kurasi Aset 3D Terbaik untuk Blender',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Koleksi model berpresisi tinggi, siap pakai untuk rendering Cycles & EEVEE dengan standar editorial Alexandria.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return _HoverCard(
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDbRv2ogkBfctlvHj8UAfP8XaMmcCXQso8NGLdSEVf2TzBDcCGBeU1FGMKzCCi4xexkwB8MaNuAWE1SWXVMdMmUqJYOULZhDONdOxpFG5wk91n34M_xbuEO_TK39eT3zLV7QeJmmP53Jv8n47YctIAZSN6gwKZBuCqu-gPNuE6z96hab39cGlxNGaaSrb48KhPM24Ikr0Wz-oacLObbsIUPBFmIUASmYc_v6k9GTyY',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.onPrimaryFixed.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: AppColors.onTertiaryFixed,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'DISKON RILIS 40%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onTertiaryFixed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SPOTLIGHT KURATOR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryFixed,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Cyberpunk Alleyway Scene',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Lighting set lengkap, PBR materials 4K, dan aset modular siap pakai.',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Rp 129.000',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Rp 215.000',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white54,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRouter.detail),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Lihat Aset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      'Semua',
      'Karakter',
      'Arsitektur',
      'Kendaraan',
      'Sci-Fi',
      'Props',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KATEGORI ARSIP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                'Indeks Penuh',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final isSelected = index == 0;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(categories[index]),
                  selected: isSelected,
                  onSelected: (val) {},
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  backgroundColor: AppColors.surfaceContainerHigh,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCarousel(BuildContext context) {
    // Data diambil dari katalog aset (isi folder assets/models/characters).
    final featured = _assets.take(6).toList();
    final kuratorAssets = featured
        .map(
          (asset) => AssetCard(
            title: asset.title,
            price: asset.price,
            imageUrl: asset.assetKey,
            rating: asset.rating,
            downloads: asset.downloads,
            format: asset.format,
            isFree: asset.isFree,
            modelPath: asset.assetKey,
            category: asset.subtitle,
            asset: asset,
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.detail,
              arguments: asset,
            ),
          ),
        )
        .toList();

    void scrollBy(double offset) {
      _scrollController.animateTo(
        (_scrollController.offset + offset).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilihan Kurator Utama',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Model pilihan dengan topologi bersih dan material Cycles.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _scrollBtn(Icons.chevron_left, () => scrollBy(-296)),
                  const SizedBox(width: 6),
                  _scrollBtn(Icons.chevron_right, () => scrollBy(296)),
                  const SizedBox(width: 10),
                  const Icon(Icons.verified, color: AppColors.tertiary, size: 20),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: _dragCarousel(_scrollController, kuratorAssets.map<Widget>((a) => _HoverCard(child: a)).toList()),
        ),
      ],
    );
  }

  Widget _scrollBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, size: 18, color: AppColors.onSurface),
        ),
      ),
    );
  }

  Widget _dragCarousel(ScrollController controller, List<Widget> items) {
    double pointerStart = 0;
    double scrollStart = 0;
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Listener(
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.mouse && event.buttons == kPrimaryButton) {
            pointerStart = event.position.dx;
            scrollStart = controller.offset;
          }
        },
        onPointerMove: (event) {
          if (event.kind == PointerDeviceKind.mouse && event.buttons == kPrimaryButton) {
            final max = controller.position.maxScrollExtent;
            controller.jumpTo((scrollStart - (event.position.dx - pointerStart)).clamp(0.0, max));
          }
        },
        child: SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                items[i],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestAssets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aset Rilis Terbaru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ditambahkan minggu ini untuk kebutuhan produksi terkini.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => MainTab.open(context, MainTab.explore),
                child: const Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_loadingAssets)
            const Center(child: CircularProgressIndicator())
          else if (_assets.isEmpty)
            const Center(child: Text('Tidak ada aset ditemukan.'))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _assets.length > 4 ? 4 : _assets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final asset = _assets[index];
                return _HoverCard(child: _buildSmallCard(asset));
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSmallCard(CatalogAsset asset) {
    final title = asset.title;
    final price = asset.price;
    final isFree = asset.isFree;
    final format = asset.format;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.detail,
        arguments: asset,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: asset.hasModelPreview
                        ? IgnorePointer(
                            child: ModelViewer(
                              src: resolveModelSource(asset.assetKey),
                              backgroundColor: AppColors.surfaceContainerLow,
                              autoRotate: true,
                              cameraControls: false,
                              disableZoom: true,
                              disablePan: true,
                              loading: Loading.eager,
                              debugLogging: false,
                              relatedCss:
                                  'model-viewer{--poster-color:transparent;}',
                            ),
                          )
                        : Image.asset(
                            'assets/images/onboarding_hero.png',
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: AppColors.surfaceContainerLow,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.view_in_ar,
                                size: 34,
                                color: AppColors.outline,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: FavoriteButton(asset: asset, size: 30),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isFree ? AppColors.tertiary : AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          format,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gabung Studio Kreator',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Jual aset Blender Anda ke ribuan artist 3D global.',
                  style: TextStyle(fontSize: 11, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.admin),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onSurface,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Studio', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  const _HoverCard({required this.child});
  final Widget child;

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}



