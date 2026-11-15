import 'package:flutter/foundation.dart';

/// Model 3D yang baru diunggah dari panel admin dan dipublikasikan ke pembeli.
///
/// Seluruh data hanya hidup di memori selama aplikasi berjalan: begitu project
/// ditutup, daftar ini kosong lagi seperti semula.
class UploadedAsset {
  UploadedAsset({
    required this.id,
    required this.title,
    required this.category,
    required this.format,
    required this.price,
    required this.isFree,
    required this.creator,
    required this.description,
    required this.fileName,
    required this.sizeLabel,
    required this.quads,
    required this.dcc,
    required this.texture,
    required this.tags,
    required this.modelUrl,
  });

  final String id;
  final String title;
  final String category;
  final String format;
  final String price;
  final bool isFree;
  final String creator;
  final String description;
  final String fileName;
  final String sizeLabel;
  final String quads;
  final String dcc;
  final String texture;
  final List<String> tags;

  /// `blob:` URL dari berkas `.glb` yang dipilih saat unggah.
  final String modelUrl;
}

/// Penyimpanan sementara hasil unggah model, dipakai Beranda & Jelajah.
class UploadedAssets extends ChangeNotifier {
  UploadedAssets._();

  static final UploadedAssets instance = UploadedAssets._();

  final List<UploadedAsset> _items = <UploadedAsset>[];

  List<UploadedAsset> get items => List<UploadedAsset>.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Menambah atau mengganti aset dengan judul yang sama (hasil edit).
  void publish(UploadedAsset asset) {
    final index = _items.indexWhere(
      (item) => item.title.toLowerCase() == asset.title.toLowerCase(),
    );
    if (index >= 0) {
      _items[index] = asset;
    } else {
      _items.insert(0, asset);
    }
    notifyListeners();
  }

  void removeByTitle(String title) {
    final before = _items.length;
    _items.removeWhere(
      (item) => item.title.toLowerCase() == title.toLowerCase(),
    );
    if (_items.length != before) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
