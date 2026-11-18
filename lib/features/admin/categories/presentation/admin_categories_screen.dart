import 'package:flutter/material.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/categories/data/admin_categories_repository.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Taksonomi kategori katalog studio admin.
///
/// Mendukung pencarian, penambahan, penyuntingan, penghapusan, pengurutan
/// hierarki beranda (drag), serta penyembunyian kategori dari pembeli.
class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  static const _iconChoices = [
    Icons.category_outlined,
    Icons.accessibility_new,
    Icons.smart_toy_outlined,
    Icons.apartment_outlined,
    Icons.sports_martial_arts,
    Icons.directions_car_outlined,
    Icons.blur_on,
    Icons.brush_outlined,
    Icons.forest_outlined,
    Icons.view_in_ar_outlined,
  ];

  final _categories = AdminCategories.instance;
  final _search = TextEditingController();

  int get _totalModels =>
      _categories.items.fold(0, (sum, category) => sum + category.modelCount);

  int get _subCategories =>
      _categories.items.fold(0, (sum, category) => sum + category.tags.length);

  List<AdminCategory> get _visible {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return _categories.items;
    return _categories.items.where((category) {
      return '${category.name} ${category.slug} ${category.tags.join(' ')}'
          .toLowerCase()
          .contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _categories.addListener(_rebuild);
  }

  @override
  void dispose() {
    _categories.removeListener(_rebuild);
    _search.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final searching = _search.text.trim().isNotEmpty;

    return AdminPageScaffold(
      title: 'Kelola Kategori',
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
              _TinyDot(),
              SizedBox(width: 6),
              Text(
                'TAKSONOMI ASET 3D',
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
          'Kelola Kategori & Taksonomi',
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
          'Struktur katalog hierarki aset 3D untuk memudahkan navigasi '
          'kuratorial dan pencarian pembeli.',
          style: TextStyle(
            fontSize: 11.5,
            height: 1.5,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 14),
        _statBar(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AdminSearchField(
                hint: 'Cari nama atau slug...',
                controller: _search,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () => _showCategoryDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text(
                  'Tambah',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Text(
                'HIERARKI BERANDA (TARIK UNTUK ATUR)',
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
            AdminBadge(
              label: '${_categories.activeCount} Ditampilkan',
              background: const Color(0xFFF9E37A),
              foreground: AppColors.onTertiaryFixed,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (visible.isEmpty)
          const AdminEmptyState(
            icon: Icons.category_outlined,
            message: 'Kategori tidak ditemukan. Coba kata kunci lain.',
          )
        else if (searching)
          for (final category in visible) ...[
            _categoryCard(category, _categories.items.indexOf(category)),
            const SizedBox(height: 10),
          ]
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: _categories.items.length,
            onReorder: _categories.reorder,
            proxyDecorator: (child, index, animation) => Material(
              color: Colors.transparent,
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
            itemBuilder: (context, index) {
              final category = _categories.items[index];
              return Padding(
                key: ValueKey('${category.slug}-$index'),
                padding: const EdgeInsets.only(bottom: 10),
                child: _categoryCard(category, index, reorderIndex: index),
              );
            },
          ),
      ],
    );
  }

  // ─── Komponen ─────────────────────────────────────────────────────────

  Widget _statBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: adminCardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: _statValue('KATEGORI INDUK', '${_categories.items.length}'),
          ),
          _statDivider(),
          Expanded(
            child: _statValue('SUB-KATEGORI', '$_subCategories'),
          ),
          _statDivider(),
          Expanded(
            child: _statValue(
              'TOTAL MODEL',
              _formatThousands(_totalModels),
              highlight: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statValue(String label, String value, {bool highlight = false}) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: highlight ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _statDivider() => Container(
        width: 1,
        height: 30,
        color: AppColors.outline.withValues(alpha: 0.15),
      );

  Widget _categoryCard(
    AdminCategory category,
    int index, {
    int? reorderIndex,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
      decoration: adminCardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reorderIndex != null)
            ReorderableDragStartListener(
              index: reorderIndex,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(2, 14, 6, 20),
                child: Icon(
                  Icons.drag_indicator,
                  size: 18,
                  color: AppColors.outline,
                ),
              ),
            ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: category.active
                  ? AppColors.primaryContainer
                  : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              category.icon,
              size: 21,
              color: category.active
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontFamily: 'Noto Serif',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          if (category.draft)
                            const AdminBadge(
                              label: 'Draft',
                              background: AppColors.surfaceContainerHigh,
                              foreground: AppColors.onSurfaceVariant,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    AdminToggleSwitch(
                      value: category.active,
                      onChanged: (value) => _toggleActive(category, value),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: category.slug),
                      TextSpan(
                        text: category.active
                            ? '  •  Urutan #${index + 1}'
                            : '  •  Disembunyikan',
                        style: TextStyle(
                          fontStyle: category.active
                              ? FontStyle.normal
                              : FontStyle.italic,
                          color: category.active
                              ? AppColors.secondary
                              : AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final tag in category.tags)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_formatThousands(category.modelCount)} Model '
                          '${category.active ? 'Aktif' : 'Terdata'}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    _iconAction(
                      Icons.account_tree_outlined,
                      'Lihat hierarki',
                      () => showAdminInfoSheet(context, category.name, [
                        'Slug: ${category.slug}',
                        '${category.modelCount} model terdaftar',
                        'Tag: ${category.tags.join(', ')}',
                      ]),
                    ),
                    _iconAction(
                      Icons.edit_outlined,
                      'Sunting kategori',
                      () => _showCategoryDialog(existing: category),
                    ),
                    _iconAction(
                      Icons.delete_outline,
                      'Hapus kategori',
                      () => _deleteCategory(category),
                      color: AppColors.error,
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

  // ─── Aksi ─────────────────────────────────────────────────────────────

  void _toggleActive(AdminCategory category, bool value) {
    category.active = value;
    _categories.notifyChanged();
    adminSnack(
      context,
      value
          ? '${category.name} ditampilkan di beranda.'
          : '${category.name} disembunyikan dari beranda.',
    );
  }

  Future<void> _deleteCategory(AdminCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus kategori?'),
        content: Text(
          category.modelCount == 0
              ? '${category.name} akan dihapus dari taksonomi.'
              : '${category.name} memiliki ${category.modelCount} model. '
                  'Semua aset akan dipindahkan ke kategori "Umum".',
        ),
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
    _categories.remove(category);
    adminSnack(context, '${category.name} dihapus.');
  }

  Future<void> _showCategoryDialog({AdminCategory? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final slugController = TextEditingController(text: existing?.slug ?? '');
    final tagController = TextEditingController(
      text: existing?.tags.map((tag) => tag.replaceFirst('#', '')).join(', ') ??
          '',
    );
    var active = existing?.active ?? true;
    var icon = existing?.icon ?? _iconChoices.first;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Tambah Kategori' : 'Sunting Kategori'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nama kategori',
                    hintText: 'mis. Kendaraan & Transportasi',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: slugController,
                  decoration: const InputDecoration(
                    labelText: 'Slug',
                    hintText: '/kategori/vehicles',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tagController,
                  decoration: const InputDecoration(
                    labelText: 'Tag',
                    hintText: 'vehicle, hard-surface',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ikon kategori',
                  style: TextStyle(fontSize: 11, color: AppColors.secondary),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final choice in _iconChoices)
                      GestureDetector(
                        onTap: () => setDialogState(() => icon = choice),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: icon == choice
                                ? AppColors.primaryContainer
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: icon == choice
                                  ? AppColors.primary
                                  : AppColors.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(
                            choice,
                            size: 17,
                            color: icon == choice
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tampilkan di beranda',
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(dialogContext, true);
              },
              child: Text(existing == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        ),
      ),
    );

    final name = nameController.text.trim();
    var slug = slugController.text.trim();
    final tags = tagController.text
        .split(',')
        .map((tag) => tag.trim().replaceFirst('#', ''))
        .where((tag) => tag.isNotEmpty)
        .map((tag) => '#$tag')
        .toList();
    nameController.dispose();
    slugController.dispose();
    tagController.dispose();
    if (saved != true || !mounted || name.isEmpty) return;

    if (slug.isEmpty) {
      slug = '/kategori/${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}';
    } else if (!slug.startsWith('/')) {
      slug = '/kategori/$slug';
    }

    if (existing == null) {
      _categories.add(
        AdminCategory(
          name: name,
          slug: slug,
          icon: icon,
          modelCount: 0,
          tags: tags.isEmpty ? ['#baru'] : tags,
          active: active,
        ),
      );
    } else {
      existing
        ..name = name
        ..slug = slug
        ..icon = icon
        ..tags = tags.isEmpty ? existing.tags : tags
        ..active = active;
      _categories.notifyChanged();
    }
    adminSnack(
      context,
      existing == null ? '$name ditambahkan.' : '$name diperbarui.',
    );
  }

  static String _formatThousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
