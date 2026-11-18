import 'package:flutter/material.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/banners/data/admin_banners_repository.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Pengelola banner & promosi carousel beranda.
///
/// Mendukung pembuatan, penyuntingan, penggandaan, penghapusan, pengaktifan
/// (maksimal tiga slot tayang), pengurutan carousel, dan sinkronisasi.
class AdminBannersScreen extends StatefulWidget {
  const AdminBannersScreen({super.key});

  @override
  State<AdminBannersScreen> createState() => _AdminBannersScreenState();
}

class _AdminBannersScreenState extends State<AdminBannersScreen> {
  static const _maxActive = 3;

  final _banners = AdminBanners.instance;

  int get _activeCount => _banners.activeCount;

  int get _scheduledCount => _banners.scheduledCount;

  int get _totalClicks => _banners.totalClicks;

  @override
  void initState() {
    super.initState();
    _banners.addListener(_rebuild);
  }

  @override
  void dispose() {
    _banners.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return AdminPageScaffold(
      title: 'Kelola Banner',
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.view_carousel_outlined,
                size: 12,
                color: AppColors.onSurfaceVariant,
              ),
              SizedBox(width: 6),
              Text(
                'KATALOG VISUAL BERANDA',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kelola Banner & Promosi',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontVariations: [FontVariation('wght', 700)],
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.15,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Atur urutan carousel visual promosi di Beranda pembeli secara '
          'dinamis.',
          style: TextStyle(
            fontSize: 11.5,
            height: 1.5,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                print('DEBUG: Button clicked');
                _showBannerDialog();
              },
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: AppColors.onPrimary),
                    SizedBox(width: 8),
                    Text(
                      'Buat Banner Baru',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _statsCard(),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Text(
                'URUTAN TAYANG CAROUSEL (TARIK\nHANDLE UNTUK PRIORITAS)',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 9,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _sync,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.sync, size: 14),
              label: const Text(
                'Sinkronkan',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_banners.items.isEmpty)
          const AdminEmptyState(
            icon: Icons.view_carousel_outlined,
            message: 'Belum ada banner. Tekan "Buat Banner Baru" untuk menambah.',
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _banners.items.length,
            onReorder: _banners.reorder,
            itemBuilder: (context, index) {
              final banner = _banners.items[index];
              return Padding(
                key: ValueKey('${banner.title}-$index'),
                padding: const EdgeInsets.only(bottom: 12),
                child: _bannerCard(banner, index),
              );
            },
          ),
        _guideCard(),
      ],
    );
  }

  // ─── Komponen ─────────────────────────────────────────────────────────

  Widget _statsCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _statRow(
            Icons.check_circle_outline,
            const Color(0xFFD9E2FF),
            AppColors.primary,
            'Slot Ditampilkan',
            '$_activeCount Banner Aktif',
          ),
          const SizedBox(height: 8),
          _statRow(
            Icons.schedule_outlined,
            const Color(0xFFF9E37A),
            AppColors.tertiary,
            'Pipeline Siap Tayang',
            '$_scheduledCount Terjadwal',
          ),
          const SizedBox(height: 8),
          _statRow(
            Icons.insights_outlined,
            AppColors.surfaceContainerHigh,
            AppColors.onSurfaceVariant,
            'Performa Promosi',
            '${_compact(_totalClicks)} Klik Bulan Ini',
          ),
        ],
      ),
    );
  }

  Widget _statRow(
    IconData icon,
    Color background,
    Color foreground,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: foreground),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

  Widget _bannerCard(AdminBanner banner, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: adminCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* 
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 6, 6, 6),
                  child: Icon(
                    Icons.drag_indicator,
                    size: 18,
                    color: AppColors.outline,
                  ),
                ),
              ),
              */
              _thumbnail(banner, index),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _statusPill(banner),
                        const Spacer(),
                        AdminToggleSwitch(
                          value: banner.active,
                          onChanged: (value) => _toggle(banner, value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      banner.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.link,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            banner.target,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.secondary,
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
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                Icon(
                  banner.scheduled
                      ? Icons.schedule
                      : Icons.calendar_today_outlined,
                  size: 13,
                  color: favoriteGold(banner),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    banner.scheduled && banner.note.isNotEmpty
                        ? '${banner.dateRange} (${banner.note})'
                        : banner.dateRange,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                if (banner.clicks > 0) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.insights,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_compact(banner.impressions)} Impr • '
                    '${_compact(banner.clicks)} Klik '
                    '(CTR ${banner.ctr.toStringAsFixed(1)}%)',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _iconAction(
                Icons.edit_outlined,
                'Sunting banner',
                () => _showBannerDialog(existing: banner),
              ),
              _iconAction(
                Icons.copy_outlined,
                'Gandakan banner',
                () => _duplicate(banner),
              ),
              _iconAction(
                Icons.delete_outline,
                'Hapus banner',
                () => _delete(banner),
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color favoriteGold(AdminBanner banner) =>
      banner.scheduled ? const Color(0xFFC7A64B) : AppColors.secondary;

  Widget _thumbnail(AdminBanner banner, int index) {
    return SizedBox(
      width: 64,
      height: 48,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 64,
              height: 48,
              color: AppColors.surfaceContainerHigh,
              child: banner.imageUrl == null
                  ? const Icon(
                      Icons.image_outlined,
                      size: 20,
                      color: AppColors.outline,
                    )
                  : Image.network(
                      banner.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: AppColors.outline,
                      ),
                    ),
            ),
          ),
          Positioned(
            top: 3,
            left: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: index == 0
                    ? AppColors.primary
                    : AppColors.onSurface.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '#${index + 1}',
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(AdminBanner banner) {
    if (banner.active) {
      return const AdminBadge(
        label: 'Aktif',
        background: AppColors.primaryContainer,
        foreground: AppColors.primary,
        icon: Icons.circle,
      );
    }
    if (banner.scheduled) {
      return const AdminBadge(
        label: 'Terjadwal',
        background: Color(0xFFF9E37A),
        foreground: AppColors.onTertiaryFixed,
        icon: Icons.schedule,
      );
    }
    return const AdminBadge(
      label: 'Draft',
      background: AppColors.surfaceContainerHigh,
      foreground: AppColors.onSurfaceVariant,
    );
  }

  Widget _iconAction(
    IconData icon,
    String tooltip,
    VoidCallback onTap, {
    Color color = AppColors.onSurfaceVariant,
  }) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 16, color: color),
    );
  }

  Widget _guideCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 17,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panduan Rekomendasi Format Banner',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Gunakan rasio gambar tepat 16:9 (1280 × 720 px) dengan '
                  'ukuran file maksimal 2MB (format WebP atau PNG). Pastikan '
                  'area teks memiliki kontras rasio minimal 4.5:1 terhadap '
                  'latar visual agar mudah dibaca di layar retina ponsel.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Aksi ─────────────────────────────────────────────────────────────

  void _toggle(AdminBanner banner, bool value) {
    if (value && !banner.active && _activeCount >= _maxActive) {
      adminSnack(
        context,
        'Slot tayang penuh (maks. $_maxActive banner). '
        'Nonaktifkan satu banner terlebih dahulu.',
      );
      return;
    }
    banner.active = value;
    if (value) banner.scheduled = false;
    _banners.notifyChanged();
    adminSnack(
      context,
      value
          ? '${banner.title} tayang di carousel beranda.'
          : '${banner.title} disembunyikan dari carousel.',
    );
  }

  void _sync() {
    _banners.notifyChanged();
    adminSnack(
      context,
      'Carousel beranda disinkronkan • $_activeCount banner tayang.',
    );
  }

  void _duplicate(AdminBanner banner) {
    final index = _banners.items.indexOf(banner);
    _banners.insertAt(
      index + 1,
      AdminBanner(
        title: '${banner.title} (Salinan)',
        target: banner.target,
        dateRange: banner.dateRange,
        imageUrl: banner.imageUrl,
        active: false,
        scheduled: false,
        impressions: 0,
        clicks: 0,
      ),
    );
    adminSnack(context, 'Banner digandakan sebagai draft.');
  }

  Future<void> _delete(AdminBanner banner) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus banner?'),
        content: Text('${banner.title} akan dihapus dari carousel beranda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    _banners.remove(banner);
    adminSnack(context, '${banner.title} dihapus.');
  }

  Future<void> _showBannerDialog({AdminBanner? existing}) async {
    print('DEBUG: _showBannerDialog called');
    final titleController = TextEditingController(text: existing?.title ?? '');
    final targetController = TextEditingController(text: existing?.target ?? '');
    final periodController = TextEditingController(
      text: existing?.dateRange ?? '',
    );
    final formKey = GlobalKey<FormState>();
    var active = existing?.active ?? false;
    String? imageUrl = existing?.imageUrl;

    final images = [
      for (final banner in demoAdminBanners)
        if (banner.imageUrl != null) banner.imageUrl!,
    ];

    final saved = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'BannerDialog',
      pageBuilder: (dialogContext, anim1, anim2) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Buat Banner Baru' : 'Sunting Banner'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Judul banner',
                        hintText: 'mis. Rilis Koleksi Karakter 2026',
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Judul banner wajib diisi.'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: targetController,
                      decoration: const InputDecoration(
                        labelText: 'Target tautan',
                        hintText: '/kategori/karakter-rigging',
                      ),
                      validator: (value) {
                        final target = value?.trim() ?? '';
                        if (target.isEmpty) return 'Target tautan wajib diisi.';
                        if (target.contains(' ')) {
                          return 'Target tautan tidak boleh berisi spasi.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: periodController,
                      decoration: const InputDecoration(
                        labelText: 'Periode tayang',
                        hintText: '01 Nov – 30 Nov 2026',
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Periode tayang wajib diisi.'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gambar banner',
                      style: TextStyle(fontSize: 11, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 52,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _imageChoice(
                            null,
                            imageUrl == null,
                            (value) => setDialogState(() => imageUrl = value),
                          ),
                          const SizedBox(width: 6),
                          for (final image in images) ...[
                            _imageChoice(
                              image,
                              imageUrl == image,
                              (value) => setDialogState(() => imageUrl = value),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Langsung tayangkan',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Switch(
                          value: active,
                          activeThumbColor: AppColors.onPrimary,
                          activeTrackColor: AppColors.primary,
                          onChanged: (value) =>
                              setDialogState(() => active = value),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() != true) return;
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(existing == null ? 'Buat' : 'Simpan'),
            ),
          ],
        ),
      ),
    );

    final title = titleController.text.trim();
    var target = targetController.text.trim();
    final period = periodController.text.trim();
    titleController.dispose();
    targetController.dispose();
    periodController.dispose();
    if (saved != true || !mounted || title.isEmpty) return;

    if (target.isEmpty) target = '/';
    if (!target.startsWith('/')) target = '/$target';

    if (active && _activeCount >= _maxActive && existing?.active != true) {
      adminSnack(
        context,
        'Slot tayang penuh (maks. $_maxActive banner). '
        'Banner disimpan sebagai draft.',
      );
      active = false;
    }

    if (existing == null) {
      _banners.insertAt(
        0,
        AdminBanner(
          title: title,
          target: target,
          dateRange: period.isEmpty ? 'Belum dijadwalkan' : period,
          imageUrl: imageUrl,
          active: active,
        ),
      );
    } else {
      existing
        ..title = title
        ..target = target
        ..dateRange = period.isEmpty ? existing.dateRange : period
        ..imageUrl = imageUrl
        ..active = active
        ..scheduled = active ? false : existing.scheduled;
      _banners.notifyChanged();
    }
    adminSnack(
      context,
      existing == null ? '$title dibuat.' : '$title diperbarui.',
    );
  }

  Widget _imageChoice(
    String? image,
    bool selected,
    ValueChanged<String?> onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(image),
      child: Container(
        width: 78,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.2),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: image == null
            ? const ColoredBox(
                color: AppColors.surfaceContainerHigh,
                child: Center(
                  child: Icon(
                    Icons.block,
                    size: 17,
                    color: AppColors.outline,
                  ),
                ),
              )
            : Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.surfaceContainerHigh,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 17,
                      color: AppColors.outline,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  static String _compact(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1).replaceAll('.', ',')} Jt';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1).replaceAll('.0', '').replaceAll('.', ',')} Rb';
    }
    return '$value';
  }
}
