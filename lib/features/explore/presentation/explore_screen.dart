import 'package:flutter/material.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/core/data/uploaded_assets.dart';
import 'package:_3dmarket/core/widgets/asset_card.dart';
import 'package:_3dmarket/core/widgets/buyer_app_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

/// Pilihan filter lanjutan yang dipilih dari bottom sheet.
class _FilterSelection {
  const _FilterSelection({
    required this.format,
    required this.price,
    required this.rating,
  });

  final String format;
  final String price;
  final String rating;

  int get activeCount =>
      (format != 'Semua Format' ? 1 : 0) +
      (price != 'Semua Harga' ? 1 : 0) +
      (rating != 'Semua Rating' ? 1 : 0);
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _filters = [
    'Semua',
    'Hanya Gratis',
    'Premium / Berbayar',
    'Rigged & Animated',
    'Low Poly',
  ];

  static const _sortOptions = [
    'Terpopuler',
    'Terbaru',
    'Harga Terendah',
    'Harga Tertinggi',
    'Rating Tertinggi',
  ];

  int filter = 0;
  String _sort = 'Terpopuler';
  _FilterSelection _advanced = const _FilterSelection(
    format: 'Semua Format',
    price: 'Semua Harga',
    rating: 'Semua Rating',
  );
  final search = TextEditingController();
  List<CatalogAsset> _assets = [];
  bool _loading = true;

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

  // ─── Penyaringan ──────────────────────────────────────────────────────

  bool get _hasQueryOrFilter =>
      search.text.trim().isNotEmpty ||
      filter != 0 ||
      _advanced.activeCount > 0;

  List<CatalogAsset> get _visibleAssets {
    final query = search.text.trim().toLowerCase();
    final items = _assets.where((asset) {
      if (!_matchesChip(asset)) return false;
      if (!_matchesAdvanced(asset)) return false;
      if (query.isEmpty) return true;
      final haystack = [
        asset.title,
        asset.category,
        asset.creator,
        asset.fileName,
        asset.format,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();

    switch (_sort) {
      case 'Terbaru':
        items.sort((a, b) {
          if (a.isUploaded == b.isUploaded) return 0;
          return a.isUploaded ? -1 : 1;
        });
        break;
      case 'Harga Terendah':
        items.sort((a, b) => priceValue(a.price).compareTo(priceValue(b.price)));
        break;
      case 'Harga Tertinggi':
        items.sort((a, b) => priceValue(b.price).compareTo(priceValue(a.price)));
        break;
      case 'Rating Tertinggi':
        items.sort(
          (a, b) =>
              _ratingValue(b.rating).compareTo(_ratingValue(a.rating)),
        );
        break;
      default:
        items.sort(
          (a, b) => _numeric(b.downloads).compareTo(_numeric(a.downloads)),
        );
    }
    return items;
  }

  bool _matchesChip(CatalogAsset asset) {
    switch (filter) {
      case 1:
        return asset.isFree;
      case 2:
        return !asset.isFree;
      case 3:
        final text = '${asset.title} ${asset.category}'.toLowerCase();
        return text.contains('rig') ||
            text.contains('anim') ||
            text.contains('karakter');
      case 4:
        final text = '${asset.title} ${asset.fileName}'.toLowerCase();
        return text.contains('low') || text.contains('poly');
      default:
        return true;
    }
  }

  bool _matchesAdvanced(CatalogAsset asset) {
    if (_advanced.format != 'Semua Format' &&
        asset.format.replaceAll('.', '').toUpperCase() != _advanced.format) {
      return false;
    }

    final price = priceValue(asset.price);
    switch (_advanced.price) {
      case 'Gratis':
        if (!asset.isFree) return false;
        break;
      case 'Di bawah Rp 100.000':
        if (asset.isFree || price >= 100000) return false;
        break;
      case 'Rp 100.000 ke atas':
        if (asset.isFree || price < 100000) return false;
        break;
    }

    final rating = _ratingValue(asset.rating);
    if (_advanced.rating == '4.5 ke atas' && rating < 4.5) return false;
    if (_advanced.rating == '4.8 ke atas' && rating < 4.8) return false;
    return true;
  }

  static double _ratingValue(String rating) =>
      double.tryParse(rating) ?? 0;

  static int _numeric(String value) =>
      int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  void _resetAll() {
    setState(() {
      search.clear();
      filter = 0;
      _sort = 'Terpopuler';
      _advanced = const _FilterSelection(
        format: 'Semua Format',
        price: 'Semua Harga',
        rating: 'Semua Rating',
      );
    });
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<_FilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(initial: _advanced),
    );
    if (result != null && mounted) {
      setState(() => _advanced = result);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final items = _visibleAssets;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BuyerAppBar(section: 'JELAJAH'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
        children: [
          _searchBar(),
          const SizedBox(height: 12),
          _filterChips(),
          const SizedBox(height: 14),
          _toolbar(items.length),
          if (_activeFilters().isNotEmpty) ...[
            const SizedBox(height: 10),
            _activeFilterRow(),
          ],
          const SizedBox(height: 14),
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (items.isEmpty)
            _emptyState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .68,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final asset = items[i];
                return _HoverCard(
                  child: AssetCard(
                    title: asset.title,
                    price: asset.price,
                    imageUrl: asset.assetKey,
                    rating: asset.rating,
                    downloads: asset.downloads,
                    isFree: asset.isFree,
                    format: asset.format,
                    modelPath: asset.assetKey,
                    category: asset.subtitle,
                    asset: asset,
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

  // ─── Search & filter UI ───────────────────────────────────────────────

  Widget _searchBar() {
    final hasText = search.text.isNotEmpty;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(
            Icons.search,
            size: 20,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: search,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                color: AppColors.onSurface,
              ),
              decoration: const InputDecoration(
                hintText: 'Cari model 3D, kategori, tag (.glb)...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (hasText)
            IconButton(
              tooltip: 'Hapus pencarian',
              onPressed: () {
                search.clear();
                setState(() {});
              },
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.close,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in _filters.asMap().entries) ...[
            _Pill(
              label: entry.key == 0
                  ? 'Semua (${_assets.length})'
                  : entry.value,
              selected: filter == entry.key,
              onTap: () => setState(() => filter = entry.key),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _toolbar(int count) {
    final active = _advanced.activeCount;
    return Row(
      children: [
        PopupMenuButton<String>(
          initialValue: _sort,
          onSelected: (value) => setState(() => _sort = value),
          offset: const Offset(0, 42),
          color: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) => [
            for (final option in _sortOptions)
              PopupMenuItem(
                value: option,
                child: Row(
                  children: [
                    if (option == _sort)
                      const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.primary,
                      )
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: option == _sort
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: option == _sort
                            ? AppColors.primary
                            : AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.swap_vert,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _sort,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$count kurasi',
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 11.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: _openFilterSheet,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: active > 0
                  ? AppColors.primaryContainer
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: active > 0
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : AppColors.outline.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  size: 16,
                  color: active > 0
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  active > 0 ? 'Filter ($active)' : 'Filter',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active > 0
                        ? AppColors.primary
                        : AppColors.onSurface,
                  ),
                ),
                if (active > 0) ...[
                  const SizedBox(width: 5),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<(String, VoidCallback)> _activeFilters() {
    final chips = <(String, VoidCallback)>[];
    if (_advanced.format != 'Semua Format') {
      chips.add((
        'Format: ${_advanced.format}',
        () => setState(
          () => _advanced = _FilterSelection(
            format: 'Semua Format',
            price: _advanced.price,
            rating: _advanced.rating,
          ),
        ),
      ));
    }
    if (_advanced.price != 'Semua Harga') {
      chips.add((
        'Harga: ${_advanced.price}',
        () => setState(
          () => _advanced = _FilterSelection(
            format: _advanced.format,
            price: 'Semua Harga',
            rating: _advanced.rating,
          ),
        ),
      ));
    }
    if (_advanced.rating != 'Semua Rating') {
      chips.add((
        'Rating: ${_advanced.rating}',
        () => setState(
          () => _advanced = _FilterSelection(
            format: _advanced.format,
            price: _advanced.price,
            rating: 'Semua Rating',
          ),
        ),
      ));
    }
    return chips;
  }

  Widget _activeFilterRow() {
    final chips = _activeFilters();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final chip in chips)
          Container(
            padding: const EdgeInsets.only(left: 11, right: 4, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chip.$1,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 2),
                InkWell(
                  onTap: chip.$2,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.close,
                      size: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        TextButton(
          onPressed: _resetAll,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: const Size(0, 30),
          ),
          child: const Text(
            'Reset Semua',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
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
              Icons.search_off,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tidak ada aset yang cocok',
            style: TextStyle(
              fontFamily: 'Noto Serif',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba kata kunci lain atau longgarkan filter yang aktif.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (_hasQueryOrFilter) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _resetAll,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.restart_alt, size: 17),
              label: const Text(
                'Reset Pencarian & Filter',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Komponen pendukung ─────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.outline.withValues(alpha: 0.22),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.onPrimary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet filter lanjutan: format berkas, rentang harga, dan rating.
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});

  final _FilterSelection initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  static const _formats = [
    'Semua Format',
    'GLB',
    'BLEND',
    'FBX',
    'OBJ',
  ];
  static const _prices = [
    'Semua Harga',
    'Gratis',
    'Di bawah Rp 100.000',
    'Rp 100.000 ke atas',
  ];
  static const _ratings = ['Semua Rating', '4.5 ke atas', '4.8 ke atas'];

  late String _format = widget.initial.format;
  late String _price = widget.initial.price;
  late String _rating = widget.initial.rating;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Saring Katalog',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _group('FORMAT BERKAS', _formats, _format, (v) {
              setState(() => _format = v);
            }),
            const SizedBox(height: 16),
            _group('RENTANG HARGA', _prices, _price, (v) {
              setState(() => _price = v);
            }),
            const SizedBox(height: 16),
            _group('RATING MINIMUM', _ratings, _rating, (v) {
              setState(() => _rating = v);
            }),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _format = 'Semua Format';
                      _price = 'Semua Harga';
                      _rating = 'Semua Rating';
                    }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onSurfaceVariant,
                      minimumSize: const Size(0, 46),
                      side: BorderSide(
                        color: AppColors.outline.withValues(alpha: 0.25),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      _FilterSelection(
                        format: _format,
                        price: _price,
                        rating: _rating,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0,
                      minimumSize: const Size(0, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _group(
    String label,
    List<String> options,
    String selected,
    ValueChanged<String> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              _Pill(
                label: option,
                selected: option == selected,
                onTap: () => onSelected(option),
              ),
          ],
        ),
      ],
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
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
