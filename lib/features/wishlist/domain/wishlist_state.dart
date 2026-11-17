import 'package:flutter/foundation.dart';

import 'package:_3dmarket/core/data/asset_catalog.dart';

/// Daftar aset favorit yang tersimpan selama aplikasi berjalan.
///
/// Seperti data pembelian, isinya hanya hidup di memori: reload halaman
/// mengembalikan wishlist ke kondisi kosong.
class WishlistStore extends ChangeNotifier {
  WishlistStore._();

  static final WishlistStore instance = WishlistStore._();

  /// Dipakai `LinkedHashMap` agar urutan simpan (terbaru di akhir) terjaga.
  final Map<String, CatalogAsset> _items = <String, CatalogAsset>{};

  /// Aset tersimpan, terbaru lebih dulu.
  List<CatalogAsset> get items => _items.values.toList().reversed.toList();

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool contains(CatalogAsset asset) => _items.containsKey(asset.assetKey);

  /// Menambah bila belum ada, menghapus bila sudah tersimpan.
  ///
  /// Mengembalikan `true` bila aset baru saja ditambahkan.
  bool toggle(CatalogAsset asset) {
    final existed = _items.remove(asset.assetKey) != null;
    if (!existed) _items[asset.assetKey] = asset;
    notifyListeners();
    return !existed;
  }

  void remove(CatalogAsset asset) {
    if (_items.remove(asset.assetKey) != null) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
