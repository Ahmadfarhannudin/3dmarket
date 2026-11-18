import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/uploaded_assets.dart';
import 'package:_3dmarket/core/utils/blob_url.dart';
import 'package:_3dmarket/core/utils/model_source.dart';
import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/shared/admin_store.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Membuka formulir unggah/ubah aset lalu menyimpan hasilnya ke [store].
Future<void> openUploadAssetScreen(
  BuildContext context,
  AdminStore store, {
  AdminAsset? asset,
}) async {
  final target = asset == null ? AppRouter.adminUpload : AppRouter.adminEdit;
  final result = await context.push<UploadResult>(target, extra: asset);
  if (result == null || !context.mounted) return;

  if (result.deleted) {
    if (asset != null) {
      store.removeAsset(asset);
      UploadedAssets.instance.removeByTitle(asset.title);
      adminSnack(context, '${asset.title} dihapus dari katalog.');
    }
    store.tab = 1;
    adminSnack(context, 'Katalog diperbarui.');
    context.go(AppRouter.adminCatalog);
    return;
  }

  final updated = result.asset!;
  if (asset == null) {
    store.addAsset(updated);
  } else {
    store.replaceAsset(asset, updated);
  }
  if (result.uploaded != null) {
    UploadedAssets.instance.publish(result.uploaded!);
  } else if (!updated.active) {
    UploadedAssets.instance.removeByTitle(updated.title);
  }
  store.tab = 1;
  adminSnack(
    context,
    asset == null
        ? '${updated.title} ditambahkan ke katalog.'
        : '${updated.title} diperbarui.',
  );
  context.go(AppRouter.adminCatalog);
}

/// Halaman formulir unggah/edit model 3D pada panel admin.
class UploadAssetScreen extends StatefulWidget {
  const UploadAssetScreen({super.key, this.asset});

  final AdminAsset? asset;

  @override
  State<UploadAssetScreen> createState() => _UploadAssetScreenState();
}

class UploadResult {
  const UploadResult.saved(this.asset, {this.uploaded}) : deleted = false;
  const UploadResult.deleted() : asset = null, uploaded = null, deleted = true;

  final AdminAsset? asset;

  /// Model yang siap tayang di Beranda/Jelajah pembeli (bila dipublikasikan).
  final UploadedAsset? uploaded;

  final bool deleted;
}

class _UploadAssetScreenState extends State<UploadAssetScreen> {
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

  String? _modelName;
  int? _modelSize;
  String? _modelUrl;

  late bool _publish;
  String _format = '.glb';
  String _category = 'Karakter & Siber';
  String _dcc = 'Blender 4.2 LTS';
  String _texture = '4K PBR UDIM';

  bool get _isEdit => widget.asset != null;
  String get _modelPreview => _modelUrl ?? widget.asset?.modelPath ?? f14Model;

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
        ? adminAssetCategories.first
        : (adminAssetCategories.firstWhere(
            (c) => asset.meta.startsWith(c),
            orElse: () => adminAssetCategories.first,
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickModel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['glb'],
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) return;

    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      _snack('Berkas .glb tidak dapat dibaca. Coba pilih ulang.');
      return;
    }

    final url = createLocalBlobUrl(bytes, 'model/gltf-binary');
    if (url == null) {
      _snack('Preview 3D hanya tersedia pada versi web.');
      return;
    }

    final previous = _modelUrl;
    if (previous != null) revokeLocalBlobUrl(previous);

    setState(() {
      _modelUrl = url;
      _modelName = file.name;
      _modelSize = file.size;
      _format = '.glb';
    });
    _snack('${file.name} siap dipublikasikan.');
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

  AdminAsset _buildAsset({required bool publish}) {
    return AdminAsset(
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

  /// Membentuk entri katalog pembeli dari data formulir. Hanya dibuat bila
  /// model dipublikasikan dan berkas `.glb` benar-benar sudah dipilih.
  UploadedAsset? _buildUploaded(AdminAsset asset, {required bool publish}) {
    final url = _modelUrl;
    if (!publish || url == null) return null;

    return UploadedAsset(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      title: asset.title,
      category: _category,
      format: '.glb',
      price: asset.price,
      isFree: asset.free,
      creator: 'Studio 3DMarket',
      description: _descCtrl.text.trim(),
      fileName: _modelName ?? '${asset.title}.glb',
      sizeLabel: _sizeLabel,
      quads: _quadsCtrl.text.trim(),
      dcc: _dcc,
      texture: _texture,
      tags: List<String>.of(_tags),
      modelUrl: url,
    );
  }

  void _save({required bool publish}) {
    if (_titleCtrl.text.trim().isEmpty) {
      _snack('Judul model wajib diisi.');
      return;
    }
    if (_modelUrl == null && widget.asset == null) {
      _snack('Pilih berkas .glb terlebih dahulu.');
      return;
    }
    final asset = _buildAsset(publish: publish);
    Navigator.pop(
      context,
      UploadResult.saved(
        asset,
        uploaded: _buildUploaded(asset, publish: publish),
      ),
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
              Navigator.pop(context, const UploadResult.deleted());
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.error),
            ),
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
              '2. Metadata & Deskripsi Editorial',
              'Taksonomi dan dokumentasi teknis untuk pembeli.',
              Icons.edit_note_outlined,
            ),
            const SizedBox(height: 10),
            _metadataCard(),
            const SizedBox(height: 22),
            _sectionHead(
              '3. Parameter Teknis Geometri',
              'Audit topologi otomatis untuk kesiapan produksi.',
              Icons.tune,
            ),
            const SizedBox(height: 10),
            _technicalCard(),
            const SizedBox(height: 22),
            _sectionHead(
              '4. Monetisasi & Lisensi Komersial',
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
          AdminToggleSwitch(
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
                  'BERKAS MODEL 3D (.glb)',
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
                key: ValueKey(_modelPreview),
                src: resolveModelSource(_modelPreview),
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
            items: adminAssetCategories
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
              for (final f in const ['.glb'])
                _CheckPill(label: f, checked: true, onTap: () {}),
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
                      items: const ['.glb']
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
            color: selected
                ? AppColors.surfaceContainerLowest
                : Colors.transparent,
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
