import 'package:flutter/services.dart' show AssetManifest, rootBundle;

import 'package:_3dmarket/core/data/uploaded_assets.dart';

/// Satu entri model 3D yang dibaca langsung dari isi folder
/// `assets/models/**` (via AssetManifest), bukan daftar hardcode.
class CatalogAsset {
  const CatalogAsset({
    required this.assetKey,
    required this.fileName,
    required this.title,
    required this.category,
    required this.format,
    required this.isFree,
    required this.price,
    required this.rating,
    required this.downloads,
    this.creator = 'Obsidian X Lab',
    this.description = '',
    this.sizeLabel = '—',
    this.isUploaded = false,
  });

  /// Key asset Flutter, mis. `assets/models/characters/grumman_f-14_tomcat_fighter_jet.glb`.
  ///
  /// Untuk model hasil unggahan admin, nilainya berupa `blob:` URL sementara.
  final String assetKey;

  /// Nama file tanpa path, mis. `grumman_f-14_tomcat_fighter_jet.glb`.
  final String fileName;

  /// Judul hasil humanisasi nama file, mis. `Grumman F 14 Tomcat Fighter Jet`.
  final String title;

  /// Kategori dari nama subfolder (characters -> Karakter, dst).
  final String category;

  /// Ekstensi file termasuk titik, mis. `.glb`.
  final String format;

  final bool isFree;
  final String price;
  final String rating;
  final String downloads;

  /// Nama studio/kreator yang tampil di halaman detail pembeli.
  final String creator;

  /// Deskripsi editorial dari formulir unggah admin (boleh kosong).
  final String description;

  /// Ukuran berkas hasil unggah, mis. `32.4 MB`. Aset bawaan memakai `—`
  /// karena ukurannya tidak dibaca dari manifest.
  final String sizeLabel;

  /// True bila entri berasal dari unggahan admin pada sesi ini.
  final bool isUploaded;

  String get subtitle => '$category • ${format.replaceAll('.', '').toUpperCase()}';

  /// Preview 3D hanya tersedia untuk berkas `.glb`.
  bool get hasModelPreview =>
      isUploaded || fileName.toLowerCase().endsWith('.glb');
}

/// Membaca seluruh file model 3D di bawah `assets/models/` dari manifest
/// asset Flutter, lalu menambahkan model hasil unggahan admin di sesi ini.
class AssetCatalog {
  AssetCatalog._();

  static const _supportedExtensions = ['.glb', '.gltf', '.obj', '.fbx'];
  static const _basePrefix = 'assets/models/';

  static List<CatalogAsset>? _baseCache;

  static Future<List<CatalogAsset>> load() async {
    final base = await _loadBase();
    final uploaded = UploadedAssets.instance.items.map(_fromUploaded).toList();
    return <CatalogAsset>[...uploaded, ...base];
  }

  static Future<List<CatalogAsset>> _loadBase() async {
    final cached = _baseCache;
    if (cached != null) return cached;

    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final keys = manifest
          .listAssets()
          .where((key) =>
              key.startsWith(_basePrefix) &&
              _supportedExtensions.any(
                (ext) => key.toLowerCase().endsWith(ext),
              ))
          .toList()
        ..sort();
      _baseCache = keys.map(_fromAssetKey).toList(growable: false);
    } catch (_) {
      // Manifest tidak bisa dibaca (mis. saat test) -> katalog kosong.
      _baseCache = const [];
    }
    return _baseCache!;
  }

  static CatalogAsset _fromUploaded(UploadedAsset asset) {
    return CatalogAsset(
      assetKey: asset.modelUrl,
      fileName: asset.fileName,
      title: asset.title,
      category: asset.category,
      format: asset.format,
      isFree: asset.isFree,
      price: asset.price,
      rating: 'Baru',
      downloads: '0',
      creator: asset.creator,
      description: asset.description,
      sizeLabel: asset.sizeLabel,
      isUploaded: true,
    );
  }

  static CatalogAsset _fromAssetKey(String assetKey) {
    final segments = assetKey.split('/');
    final fileName = segments.last;
    final dot = fileName.lastIndexOf('.');
    final baseName = dot > 0 ? fileName.substring(0, dot) : fileName;
    final format = dot > 0 ? fileName.substring(dot).toLowerCase() : '';
    final folder = segments.length >= 3 ? segments[segments.length - 2] : '';

    final hash = baseName.hashCode.abs();
    final isFree = baseName.toLowerCase().contains('free') || hash % 4 == 0;
    final priceInThousand = 45 + (hash % 9) * 20;

    return CatalogAsset(
      assetKey: assetKey,
      fileName: fileName,
      title: _humanize(baseName),
      category: _categoryFromFolder(folder),
      format: format,
      isFree: isFree,
      price: isFree ? 'GRATIS' : 'Rp $priceInThousand.000',
      rating: (4.5 + (hash % 5) / 10).toStringAsFixed(1),
      downloads: '${((hash % 90) + 10) * 10}',
    );
  }

  static String _humanize(String baseName) {
    final words = baseName
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    return words.map((word) {
      if (word.length <= 3 && word == word.toUpperCase()) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  static String _categoryFromFolder(String folder) {
    switch (folder.toLowerCase()) {
      case 'characters':
        return 'Karakter';
      case 'environments':
        return 'Lingkungan';
      case 'vehicles':
        return 'Kendaraan';
      case 'props':
        return 'Props';
      case '':
        return 'Umum';
      default:
        return folder[0].toUpperCase() + folder.substring(1);
    }
  }
}
