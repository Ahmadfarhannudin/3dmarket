import 'package:flutter/foundation.dart';

import 'package:_3dmarket/core/data/asset_catalog.dart';

/// Satu transaksi pembelian aset yang tercatat selama aplikasi berjalan.
///
/// Seluruh isinya diturunkan dari metadata model yang benar-benar dibeli
/// (judul, format, ukuran, deskripsi, kreator) sehingga halaman status
/// pembayaran dan "Aset Saya" menampilkan data yang sama.
class PurchaseRecord {
  PurchaseRecord({
    required this.orderId,
    required this.licenseKey,
    required this.title,
    required this.category,
    required this.format,
    required this.sizeLabel,
    required this.creator,
    required this.description,
    required this.modelUrl,
    required this.itemPrice,
    required this.serviceFee,
    required this.total,
    required this.paymentMethod,
    required this.purchasedAt,
  });

  final String orderId;
  final String licenseKey;
  final String title;
  final String category;
  final String format;
  final String sizeLabel;
  final String creator;
  final String description;

  /// Sumber pratinjau 3D (`blob:` untuk unggahan admin, key aset untuk model
  /// bawaan).
  final String modelUrl;

  final int itemPrice;
  final int serviceFee;
  final int total;
  final String paymentMethod;
  final DateTime purchasedAt;

  String get totalLabel => formatRupiah(total);
  String get itemPriceLabel => itemPrice == 0 ? 'Gratis' : formatRupiah(itemPrice);
  String get purchasedAtLabel => formatPurchaseDate(purchasedAt);
}

/// Penyimpanan sementara hasil pembelian pembeli.
///
/// Data hanya hidup di memori: begitu project ditutup atau halaman di-reload,
/// daftar kembali kosong dan "Aset Saya" tampil seperti awal.
class PurchaseStore extends ChangeNotifier {
  PurchaseStore._();

  static final PurchaseStore instance = PurchaseStore._();

  static const int serviceFee = 2000;

  final List<PurchaseRecord> _items = <PurchaseRecord>[];

  List<PurchaseRecord> get items => List<PurchaseRecord>.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  PurchaseRecord? get latest => _items.isEmpty ? null : _items.first;

  /// Mencatat pembelian dari aset yang dipilih di halaman detail.
  PurchaseRecord record({
    required CatalogAsset? asset,
    required String paymentMethod,
    DateTime? purchasedAt,
  }) {
    final now = purchasedAt ?? DateTime.now();
    final stamp = now.microsecondsSinceEpoch;
    final itemPrice = priceValue(asset?.price ?? '');
    final record = PurchaseRecord(
      orderId: 'ORD-${now.year}${_two(now.month)}${_two(now.day)}-${stamp % 100000}',
      licenseKey: _licenseKey(stamp),
      title: asset?.title ?? 'Aset 3D Tanpa Judul',
      category: asset?.category ?? 'Umum',
      format: asset?.format ?? '.glb',
      sizeLabel: asset?.sizeLabel ?? '—',
      creator: asset?.creator ?? 'Studio 3DMarket',
      description: asset?.description ?? '',
      modelUrl: asset?.assetKey ?? '',
      itemPrice: itemPrice,
      serviceFee: itemPrice == 0 ? 0 : serviceFee,
      total: itemPrice == 0 ? 0 : itemPrice + serviceFee,
      paymentMethod: paymentMethod,
      purchasedAt: now,
    );
    _items.insert(0, record);
    notifyListeners();
    return record;
  }

  void remove(String orderId) {
    final before = _items.length;
    _items.removeWhere((item) => item.orderId == orderId);
    if (_items.length != before) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  static String _two(int value) => value.toString().padLeft(2, '0');

  static String _licenseKey(int seed) {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final raw = seed.abs().toString().padLeft(8, '7');
    final buffer = StringBuffer('PLY-COMM-');
    for (var i = 0; i < 4; i++) {
      buffer.write(alphabet[int.parse(raw[i]) % alphabet.length]);
    }
    buffer.write('-');
    buffer.write(raw.substring(4, 8));
    return buffer.toString();
  }
}

/// Mengubah label harga (`Rp 89.000`, `GRATIS`) menjadi nilai rupiah.
int priceValue(String price) {
  final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return 0;
  return int.tryParse(digits) ?? 0;
}

/// Format rupiah tanpa desimal: `Rp 91.000`.
String formatRupiah(int value) {
  final text = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write('.');
    buffer.write(text[i]);
  }
  return 'Rp $buffer';
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Format waktu transaksi gaya Indonesia: `10 Nov 2026, 14:32 WIB`.
String formatPurchaseDate(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '${time.day} ${_months[time.month - 1]} ${time.year}, $hour:$minute WIB';
}
