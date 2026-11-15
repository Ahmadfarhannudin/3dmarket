import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/core/data/uploaded_assets.dart';
import 'package:_3dmarket/core/widgets/asset_card.dart';
import 'package:_3dmarket/core/widgets/buyer_app_bar.dart';
import 'package:_3dmarket/app/router.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int filter = 0;
  final search = TextEditingController();
  List<CatalogAsset> _assets = [];
  bool _loading = true;

  static const filters = [
    'Semua',
    'Hanya Gratis',
    'Premium / Berbayar',
    'Rigged & Animated',
    'Low Poly',
  ];

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    UploadedAssets.instance.addListener(_onUploadsChanged);
    search.addListener(() => setState(() {}));
  }

  void _onUploadsChanged() => _loadCatalog();

  Future<void> _loadCatalog() async {
    final items = await AssetCatalog.load();
    if (mounted) {
      setState(() {
        _assets = items;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    UploadedAssets.instance.removeListener(_onUploadsChanged);
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: const BuyerAppBar(section: 'JELAJAH'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
      children: [
        TextField(
          controller: search,
          decoration: const InputDecoration(
            hintText: 'Cari model 3D, kategori, tag...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters
                .asMap()
                .entries
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(e.value),
                      selected: filter == e.key,
                      onSelected: (_) => setState(() => filter = e.key),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_assets.length} kurasi'),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune),
              label: const Text('Filter'),
            ),
          ],
        ),
        _loading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .68,
                ),
                itemCount: _assets.length,
                itemBuilder: (_, i) {
                  final asset = _assets[i];
                  final free = asset.isFree;
                  final visible = (filter != 1 || free) &&
                      (filter != 2 || !free) &&
                      asset.title.toLowerCase().contains(search.text.toLowerCase());

                  if (!visible) return const SizedBox.shrink();

                  return _HoverCard(
                    child: AssetCard(
                      title: asset.title,
                      price: asset.price,
                      imageUrl: asset.assetKey,
                      rating: asset.rating,
                      downloads: asset.downloads,
                      isFree: free,
                      format: asset.format,
                      modelPath: asset.assetKey,
                      category: asset.subtitle,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.detail,
                        arguments: asset,
                      ),
                    ),
                  );
                },
              ),
      ],
    ),
  );
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
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}


