import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/core/utils/model_source.dart';

class AssetDetailScreen extends StatefulWidget {
  const AssetDetailScreen({super.key, this.asset});

  /// Aset yang dipilih dari Beranda/Jelajah. Bila null, dipakai entri pertama
  /// katalog sebagai fallback.
  final CatalogAsset? asset;

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  final ScrollController _similarScrollController = ScrollController();
  CatalogAsset? _asset;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAsset();
  }

  Future<void> _loadAsset() async {
    final items = await AssetCatalog.load();
    if (mounted) {
      setState(() {
        _asset = widget.asset ?? (items.isNotEmpty ? items.first : null);
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _similarScrollController.dispose();
    super.dispose();
  }

  bool _saved = false;

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1600),
        ),
      );
  }

  void _buy() => Navigator.pushNamed(
    context,
    AppRouter.checkout,
    arguments: _asset,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.90),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.view_in_ar,
                size: 16,
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(width: 6),
            const Flexible(
              child: Text(
                'Detail Aset 3D',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Noto Serif',
                  fontVariations: [FontVariation('wght', 600)],
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _toast('Tautan aset disalin ke papan klip.'),
            icon: const Icon(
              Icons.share_outlined,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: const Icon(
              Icons.person,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _viewerStage(),
          _editorialHeader(),
          _priceCard(),
          _description(),
          _visualGallery(),
          _specs(),
          _creatorCard(),
          _similarAssets(),
        ],
      ),
      bottomNavigationBar: _purchaseBar(),
    );
  }

  /* --------------------------------- Viewer -------------------------------- */

  Widget _viewerStage() {
    final asset = _asset;
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        color: AppColors.surfaceContainerHighest,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (asset != null)
              ModelViewer(
                src: resolveModelSource(asset.assetKey),
                backgroundColor: AppColors.surfaceContainerHighest,
                autoRotate: true,
                autoRotateDelay: 0,
                cameraControls: true,
                loading: Loading.eager,
                debugLogging: false,
                relatedCss: 'model-viewer{--poster-color:transparent;}',
              )
            else
              const Center(
                child: Icon(
                  Icons.view_in_ar,
                  size: 48,
                  color: AppColors.outline,
                ),
              ),
            Positioned(
              top: 14,
              left: 14,
              child: _glassChip(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      asset?.format.toUpperCase() ?? 'GLB',
                      style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onSurface.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.view_in_ar_outlined,
                      size: 13,
                      color: AppColors.onPrimary,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '3D Interactive (.glb)',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                children: [
                  _glassChip(
                    const Text(
                      'Geser putar Â· cubit zoom',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _openFullscreen,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest.withValues(
                          alpha: 0.92,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fullscreen, size: 15),
                          SizedBox(width: 4),
                          Text(
                            '3D Canvas',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontVariations: [FontVariation('wght', 600)],
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassChip(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: child,
    );
  }

  void _openFullscreen() {
    final asset = _asset;
    if (asset == null) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            ModelViewer(
              src: resolveModelSource(asset.assetKey),
              backgroundColor: Colors.black,
              autoRotate: true,
              autoRotateDelay: 0,
              cameraControls: true,
              loading: Loading.eager,
              debugLogging: false,
              relatedCss: 'model-viewer{--poster-color:transparent;}',
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(dialogContext),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Text(
                asset.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ----------------------------- Editorial copy ---------------------------- */

  Widget _editorialHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 12,
                      color: AppColors.onTertiaryFixed,
                    ),
                    SizedBox(width: 3),
                    Text(
                      'Verified ${_asset?.format ?? '.glb'}',
                      style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onTertiaryFixed,
                      ),
                    ),
                  ],
                ),
              ),
              _badge('Blender 4.0+', AppColors.secondaryContainer,
                  AppColors.onSecondaryContainer),
              _badge('Rigify IK/FK', AppColors.surfaceContainerHigh,
                  AppColors.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _asset?.title ?? 'Aset 3D',
            style: const TextStyle(
              fontFamily: 'Noto Serif',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.6,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: AppColors.tertiary),
              const SizedBox(width: 2),
              Text(
                _asset?.rating ?? '-',
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.tertiary,
                ),
              ),
              _dot(),
              GestureDetector(
                onTap: () => _toast('86 ulasan kurator ditampilkan.'),
                child: const Text(
                  '86 review',
                  style: TextStyle(
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              _dot(),
              Text(
                '${_asset?.downloads ?? '-'} unduhan',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.workspace_premium_outlined,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 3),
              const Text(
                'Royalty-Free',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 600)],
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dot() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Text(
      'Ã¢â‚¬Â¢',
      style: TextStyle(
        fontSize: 10,
        color: AppColors.outline.withValues(alpha: 0.6),
      ),
    ),
  );

  Widget _badge(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Public Sans',
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        color: fg,
      ),
    ),
  );

  Widget _priceCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 4),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LISENSI KOMERSIAL STANDAR',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _asset?.price ?? '-',
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Hemat 49%',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontVariations: [FontVariation('wght', 700)],
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimaryFixed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kurasi Desain & Karakteristik', style: _sectionTitle),
          const SizedBox(height: 8),
          Text(
            (_asset?.description.trim().isNotEmpty ?? false)
                ? _asset!.description.trim()
                : 'Dirancang dengan presisi mekanis tingkat tinggi, aset cybernetic '
                    'prostetik ini menggabungkan struktur anatomi lengan manusia dengan '
                    'sambungan hidrolik industri sci-fi. Topologi model sepenuhnya '
                    'terdiri atas quad bersih tanpa n-gon, optimal untuk deformasi '
                    'ekstrem saat animasi gerak tinggi.',
            style: _bodyMuted,
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Sistem kontrol rig telah disesuaikan dengan arsitektur ',
                ),
                TextSpan(
                  text: 'Blender Rigify',
                  style: _bodyMuted.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: ' terintegrasi; lengkap dengan switch IK/FK instan pada '
                      'siku dan jemari, master driver untuk pergerakan lempeng '
                      'karpal, serta atribut shader procedural yang memungkinkan '
                      'penyesuaian intensitas aus cat dan saturasi emisi neon.',
                ),
              ],
            ),
            style: _bodyMuted,
          ),
        ],
      ),
    );
  }

  Widget _visualGallery() {
    final asset = _asset;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _visualCard(
              preview: asset == null
                  ? null
                  : IgnorePointer(
                      child: ModelViewer(
                        src: resolveModelSource(asset.assetKey),
                        backgroundColor: AppColors.surfaceContainer,
                        autoRotate: true,
                        cameraControls: false,
                        disableZoom: true,
                        disablePan: true,
                        loading: Loading.eager,
                        debugLogging: false,
                        relatedCss:
                            'model-viewer{--poster-color:transparent;}',
                      ),
                    ),
              title: asset?.fileName ?? 'File Model',
              subtitle: asset?.subtitle ?? 'Preview model 3D',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _visualCard(
              preview: Container(
                color: AppColors.surfaceContainer,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.view_in_ar,
                  size: 22,
                  color: AppColors.outline,
                ),
              ),
              title: 'Format ${asset?.format ?? '-'}',
              subtitle: 'Kategori ${asset?.category ?? '-'}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _visualCard({
    required Widget? preview,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: preview ??
                  Container(
                    color: AppColors.surfaceContainer,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 22,
                      color: AppColors.outline,
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Noto Serif',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 1, 2, 2),
            child: Text(
              subtitle,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 9.5,
                height: 1.35,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specs() {
    const rows = <(String, String)>[
      ('Format File', '.blend (native), .glb, .fbx, .obj'),
      ('Geometri', '24,500 Quads / 0 N-Gons'),
      ('Resolusi Tekstur', '4096 Ãƒâ€” 4096 px (UDIM 2 Tiles)'),
      ('Armature Rig', 'Rigify Compatible (IK/FK & Constraints)'),
      ('Versi Blender', '3.6 LTS, 4.0, 4.1'),
      ('Ukuran Arsip', '48.6 MB (.zip dengan maps)'),
      ('Lisensi', 'Komersial & Pribadi Bebas Royalti'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Spesifikasi Teknis', style: _sectionTitle)),
              GestureDetector(
                onTap: () => _toast('Inspeksi file dibuka di tab baru.'),
                child: const Row(
                  children: [
                    Icon(Icons.tune, size: 13, color: AppColors.primary),
                    SizedBox(width: 3),
                    Text(
                      'Inspeksi File',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 500)],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: _card(),
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: i.isEven
                          ? AppColors.surfaceContainerLow.withValues(alpha: 0.6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 108,
                          child: Text(
                            rows[i].$1,
                            style: const TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            rows[i].$2,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              color: AppColors.onSurface,
                            ),
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
    );
  }

  Widget _creatorCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'OX',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
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
                          _asset?.creator ?? 'Obsidian X Lab',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Noto Serif',
                            fontVariations: [FontVariation('wght', 700)],
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.verified, size: 12, color: AppColors.primary),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Senior Hard-surface Artist Ã¢â‚¬Â¢ 120+ Aset',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 10,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            TextButton(
              onPressed: () => _toast('Portofolio Obsidian X Lab dibuka.'),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerLowest,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                'Portofolio',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _similarAssets() {
    const items = <(String, String, String, String)>[
      ('Tactical Exo Helmet', '18.2k Quads â€¢ PBR', 'Rp 75.000', '4.8'),
      ('Prosthetic Cyber Leg', '32.0k Quads â€¢ Rigged', 'Rp 99.000', '5.0'),
      ('Modular Power Core', '12.4k Quads â€¢ Animated', 'Rp 65.000', '4.7'),
    ];

    double pointerStart = 0;
    double scrollStart = 0;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aset Serupa', style: _sectionTitle),
                      const SizedBox(height: 1),
                      const Text(
                        'Koleksi Sci-Fi Mecha & Sibernetika',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 10.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRouter.explore),
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontVariations: [FontVariation('wght', 600)],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Listener(
              onPointerDown: (event) {
                if (event.kind == PointerDeviceKind.mouse &&
                    event.buttons == kPrimaryButton) {
                  pointerStart = event.position.dx;
                  scrollStart = _similarScrollController.offset;
                }
              },
              onPointerMove: (event) {
                if (event.kind == PointerDeviceKind.mouse &&
                    event.buttons == kPrimaryButton) {
                  final max = _similarScrollController.position.maxScrollExtent;
                  _similarScrollController.jumpTo(
                    (scrollStart - (event.position.dx - pointerStart))
                        .clamp(0.0, max),
                  );
                }
              },
              child: SizedBox(
                height: 220,
                child: ListView.separated(
                  controller: _similarScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, i) => _HoverCard(
                    child: _similarCard(items[i], i),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _similarCard((String, String, String, String) item, int index) {
    return SizedBox(
      width: 165,
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _toast('Membuka ${item.$1}...'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _asset == null
                        ? Container(
                            color: AppColors.surfaceContainer,
                            child: const Icon(
                              Icons.view_in_ar,
                              size: 22,
                              color: AppColors.outline,
                            ),
                          )
                        : IgnorePointer(
                            child: ModelViewer(
                              src: resolveModelSource(_asset!.assetKey),
                              backgroundColor: AppColors.surfaceContainer,
                              autoRotate: true,
                              cameraControls: false,
                              disableZoom: true,
                              disablePan: true,
                              loading: Loading.eager,
                              debugLogging: false,
                              relatedCss:
                                  'model-viewer{--poster-color:transparent;}',
                            ),
                          ),
                    Positioned(
                      top: 7,
                      left: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withValues(
                            alpha: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          '.blend',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontVariations: [FontVariation('wght', 700)],
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
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
                    const SizedBox(height: 1),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 9.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow.withValues(
                          alpha: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.$3,
                              style: const TextStyle(
                                fontFamily: 'Noto Serif',
                                fontVariations: [FontVariation('wght', 700)],
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            size: 10,
                            color: AppColors.tertiary,
                          ),
                          const SizedBox(width: 1),
                          Text(
                            item.$4,
                            style: const TextStyle(
                              fontFamily: 'Public Sans',
                              fontVariations: [FontVariation('wght', 700)],
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tertiary,
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
        ),
      ),
    );
  }

  /* ------------------------------- Bottom bar ------------------------------ */

  Widget _purchaseBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.94),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TOTAL INVESTASI',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontVariations: [FontVariation('wght', 600)],
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _asset?.price ?? '-',
                    style: const TextStyle(
                      fontFamily: 'Noto Serif',
                      fontVariations: [FontVariation('wght', 700)],
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() => _saved = !_saved);
                  _toast(
                    _saved
                        ? 'Aset ditambahkan ke wishlist.'
                        : 'Aset dihapus dari wishlist.',
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _saved ? Icons.favorite : Icons.favorite_border,
                    size: 19,
                    color: _saved
                        ? AppColors.error
                        : AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF3A6FD8)],
                      ),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: _buy,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                size: 17,
                                color: AppColors.onPrimary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _asset?.isFree == true
                                    ? 'Unduh Gratis'
                                    : 'Beli Sekarang (${_asset?.price ?? '-'})',
                                style: const TextStyle(
                                  fontFamily: 'Public Sans',
                                  fontVariations: [FontVariation('wght', 700)],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  /* --------------------------------- Styles -------------------------------- */

  static const _sectionTitle = TextStyle(
    fontFamily: 'Noto Serif',
    fontVariations: [FontVariation('wght', 700)],
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.onSurface,
  );

  static const _bodyMuted = TextStyle(
    fontSize: 12.5,
    height: 1.55,
    color: AppColors.onSurfaceVariant,
  );

  BoxDecoration _card() => BoxDecoration(
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



