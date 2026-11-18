import 'package:flutter/material.dart';

/// Satu simpul kategori pada taksonomi katalog admin.
class AdminCategory {
  AdminCategory({
    required this.name,
    required this.slug,
    required this.icon,
    required this.modelCount,
    required this.tags,
    this.active = true,
  });

  String name;
  String slug;
  IconData icon;
  int modelCount;
  List<String> tags;
  bool active;

  /// Kategori nonaktif disembunyikan dari beranda pembeli.
  bool get draft => !active;
}

/// Data awal kategori (selaras dengan layar Stitch).
final demoAdminCategories = <AdminCategory>[
  AdminCategory(
    name: 'Karakter & Rigging',
    slug: '/kategori/karakter-rig',
    icon: Icons.accessibility_new,
    modelCount: 842,
    tags: ['#humanoid', '#rigged', '#facial-rig', '#game-ready'],
  ),
  AdminCategory(
    name: 'Sci-Fi & Cyberpunk',
    slug: '/kategori/scifi-cyber',
    icon: Icons.smart_toy_outlined,
    modelCount: 620,
    tags: ['#hard-surface', '#neon', '#mecha'],
  ),
  AdminCategory(
    name: 'Arsitektur & Interior',
    slug: '/kategori/archviz',
    icon: Icons.apartment_outlined,
    modelCount: 915,
    tags: ['#archviz', '#interior', '#pbr'],
  ),
  AdminCategory(
    name: 'Senjata & Properti Game',
    slug: '/kategori/props-weapons',
    icon: Icons.sports_martial_arts,
    modelCount: 530,
    tags: ['#weapon', '#prop', '#lowpoly'],
  ),
  AdminCategory(
    name: 'Kendaraan & Transportasi',
    slug: '/kategori/vehicles',
    icon: Icons.directions_car_outlined,
    modelCount: 380,
    tags: ['#vehicle', '#hard-surface'],
  ),
  AdminCategory(
    name: 'Shader, Material & Nodes',
    slug: '/kategori/shaders',
    icon: Icons.blur_on,
    modelCount: 410,
    tags: ['#shader', '#procedural', '#nodes'],
  ),
  AdminCategory(
    name: 'Eksperimental & Low-Poly',
    slug: '/kategori/lowpoly',
    icon: Icons.category_outlined,
    modelCount: 145,
    tags: ['#lowpoly', '#stylized'],
    active: false,
  ),
];

/// Penyimpanan bersama kategori admin — singleton agar semua layar admin
/// dan pembeli melihat data yang sama secara real-time.
class AdminCategories extends ChangeNotifier {
  AdminCategories._() : _items = [...demoAdminCategories];

  static final AdminCategories instance = AdminCategories._();

  final List<AdminCategory> _items;

  List<AdminCategory> get items => List<AdminCategory>.unmodifiable(_items);

  List<AdminCategory> get active =>
      _items.where((c) => c.active).toList(growable: false);

  int get activeCount => active.length;

  void add(AdminCategory category) {
    _items.add(category);
    notifyListeners();
  }

  void insertAt(int index, AdminCategory category) {
    final i = index.clamp(0, _items.length);
    _items.insert(i, category);
    notifyListeners();
  }

  bool remove(AdminCategory category) {
    final removed = _items.remove(category);
    if (removed) notifyListeners();
    return removed;
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
  }

  void notifyChanged() => notifyListeners();
}
