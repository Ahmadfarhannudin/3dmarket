import 'package:flutter/material.dart';

/// Banner promosi carousel pada beranda pembeli.
class AdminBanner {
  AdminBanner({
    required this.title,
    required this.target,
    required this.dateRange,
    this.imageUrl,
    this.active = true,
    this.scheduled = false,
    this.impressions = 0,
    this.clicks = 0,
    this.note = '',
  });

  String title;
  String target;
  String dateRange;
  String? imageUrl;
  bool active;
  bool scheduled;
  int impressions;
  int clicks;
  String note;

  /// Rasio klik terhadap tayangan dalam persen.
  double get ctr => impressions == 0 ? 0 : clicks / impressions * 100;
}

/// Data awal banner (selaras dengan layar Stitch).
final demoAdminBanners = <AdminBanner>[
  AdminBanner(
    title: 'Rilis Koleksi Karakter 2026',
    target: '/kategori/karakter-rigging',
    dateRange: '01 Nov – 30 Nov 2026',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAdKzz4hvHqXbUeli_VZXfGaipda17fKnZaVBiVMHHFRkT-qH5aWeCCZgn6Kcijy8aBDjzpL-YDiZgGEHp0Ys9Xh68uV93HZvbFUlFr9bOe0UIKjB43DAd81zZPN23I4xT1g8uwjanGudBBat9JAex34z0s1M1gO_uT4jZIuMpeSrU9GLR_31KpPM5oLbuHlXzou_jHJpp8lg8xFGy2F_9GEhmHSQ1X59nWnvdYWlc',
    impressions: 6840,
    clicks: 820,
  ),
  AdminBanner(
    title: 'Promo Sambutan Hellas Relic',
    target: '/asset/hellenic-relic',
    dateRange: '10 Nov – 10 Des 2026',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCC261f-PtBKJC6Q-na4kdQhAEUS8JekaakeWujg6OZDaQQKmi2ys9qK2pyrRXa0mdR4VmAK8igvNNEWdkvCYHapgJK6viiPKK71_L-dY5Oit_T3ZyaZ4n-CMaUqwRNTYCrxOpWzPa-OvQOueXdy54PP17UlaWf9wx7Wu6lnBCF8x4Ee6WohVTSNNhm-VAYNIN7RkSWJSNkt-wS71cW3pmp84IZJpKmKCfjoQMUhKo',
    impressions: 4120,
    clicks: 610,
  ),
  AdminBanner(
    title: 'Flash Sale Studio Hardware',
    target: '/explore?filter=discount',
    dateRange: 'Sedang Berjalan',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDU6ZwzB6WeYdBuYdaZyNvUE2oEbQv12sRKceStcCBBdTU2G193-XKykGm8DzDBHoFs_e9sML5MExBLkpjDwbb3ewrDNg5AhRjnf1vPO9QwY4meKZ6n0Lovzjtw7Ti4MFAP1sQYye0meq2WZjeZGUPElnJDtjb2uN6kIKDwhKrNYtUcjhcSdYOktt2MsWbekFq3ygTIPIOsfwbrVNGRQykyVPYYL8qH8wrCBgPqtoI',
    impressions: 3240,
    clicks: 390,
  ),
  AdminBanner(
    title: 'Kampanye Akhir Tahun Archviz',
    target: '/kategori/archviz',
    dateRange: 'Mulai 15 Des 2026',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA9nIgGC-e35q0VMIDrQWeBFEajEyLGL8qP4t0Vv1dRvrwT17AToivjik2yc-xy4sxuZjdKDgSYVS48u5ZFTeQU4Y6xgDgaNtN6qaMlUywR3ahH7QgWDW8X1ioGEvwHj9njMGfgANC1jzw7DyzDBlR53plUtKqTB4OkoqOfSGqaPQ9EHkul9wYGNF7kYeacWPeBzOOaPTECRbr5YaJ2LyKnzwbqEj_L6WPbCi_pq-k',
    active: false,
    scheduled: true,
    note: 'Otomatis tayang',
  ),
];

/// Penyimpanan bersama banner admin — singleton agar perubahan di panel admin
/// langsung tercermin di carousel beranda pembeli.
class AdminBanners extends ChangeNotifier {
  AdminBanners._() : _items = [...demoAdminBanners];

  static final AdminBanners instance = AdminBanners._();

  final List<AdminBanner> _items;

  List<AdminBanner> get items => List<AdminBanner>.unmodifiable(_items);

  List<AdminBanner> get active =>
      _items.where((b) => b.active).toList(growable: false);

  int get activeCount => active.length;

  int get scheduledCount =>
      _items.where((b) => !b.active && b.scheduled).length;

  int get totalClicks => _items.fold(0, (sum, b) => sum + b.clicks);

  void insertAt(int index, AdminBanner banner) {
    final i = index.clamp(0, _items.length);
    _items.insert(i, banner);
    notifyListeners();
  }

  bool remove(AdminBanner banner) {
    final removed = _items.remove(banner);
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
