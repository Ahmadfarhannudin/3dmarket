import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/invoice_pdf_generator.dart';
import 'package:_3dmarket/core/data/license_pdf_generator.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _query = '';
  String _filter = 'Semua Status';

  @override
  void initState() {
    super.initState();
    PurchaseStore.instance.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    PurchaseStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  /// Pembelian baru muncul paling atas, diikuti transaksi contoh.
  List<_Transaction> get _all => [
    for (final record in PurchaseStore.instance.items)
      _Transaction.fromRecord(record),
    ..._demoItems,
  ];

  static const _demoItems = <_Transaction>[
    _Transaction(
      id: '#ORD-202611-8921',
      date: '10 Nov 2026, 14:32',
      title: 'Cyberpunk Cybernetic Arm Rigged',
      subtitle: '1 Aset 3D (.blend, .glb)',
      payment: 'QRIS Instant',
      amount: 'Rp 91.000',
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBb7s7C6IL2oVd0AINCKPk-9nWlxjFfwBTsCP_M-wYj5WPeE_JzaVsiYP79Hd1J5vmAsiLNRT-tNBfM9gJ8j4PADasmWK5Bg2msvpmo2OcMq8dJcjPl2lF5qMVGI6dNRKoGnXIaOv3Du2fj9kjJDFazVVyCRFudnasjpsGtaDvKedUKLp1pvap_3RwjlKA-PaQkKMgj0aZkmXmzSCpG6gCmzMBB1im4s_SS8_o5k28',
      status: 'Berhasil',
      format: '.blend, .glb',
      category: 'Characters',
      sizeLabel: '48 MB',
      creator: 'Studio 3DMarket',
    ),
    _Transaction(
      id: '#ORD-202610-7412',
      date: '28 Okt 2026, 09:15',
      title: 'Chronograph Horology',
      subtitle: 'Kompatibel Unreal & Unity',
      payment: 'BCA Virtual Account',
      amount: 'Rp 115.000',
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyuOJgHGhC_Qnec62DPOCd437Es9tIno52Ur_c_3L8nJ1DHT57NjiPz8G_F5zJoySGD58ZpLnpAFAIxJpkLRxCFtxFreCo20BDik0qZPOcweaydYsclrdYf_S3vqxMW3iTJw3NtHv0GoYwGCloSqvjj71MjIQCCNs2BTZmSAbz_FHItPjpBmRl_NzCBHzE2Gf7bZ91Ip8FfKN9okhjd34hQIMFC-QHlNKYzPHH4Bo',
      status: 'Berhasil',
      format: '.fbx, .glb',
      category: 'Props',
      sizeLabel: '26 MB',
      creator: 'Horology Lab',
    ),
    _Transaction(
      id: '#ORD-202610-6190',
      date: '14 Okt 2026, 18:20',
      title: 'Medieval Fortress Gate',
      subtitle: 'PBR 4K Textures Included',
      payment: 'GoPay Direct',
      amount: 'Rp 85.000',
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm2g3QOPA2tJKWcqMPqpLNPQFj1hVi-ZfAEiYmt7P4QiiH4Ik8urUO9N9ja4jgAjRvQ1bSCKsTgqfy8wZVgIs-cqZ5HhNjFCR8KiRt2QazJhrYBT6hrjNT--F_8tH8wVmgHjEzn5tTWF2Wozdke1Xf0QaY_YvVFkQ4UynoNZFAV1cGvWaSNdCRRZQypBsa0lb8AiYy0JWBfAp6Vcm1pDWWsC3O3hI7DK23DXtdro',
      status: 'Berhasil',
      format: '.glb, .obj',
      category: 'Environment',
      sizeLabel: '64 MB',
      creator: 'Ars Medievalis',
    ),
    _Transaction(
      id: '#ORD-202609-3104',
      date: '02 Sep 2026, 11:04',
      title: 'Futuristic Racing Drone',
      subtitle: 'Batas waktu: 45 menit lagi',
      payment: 'Briva / Mandiri VA',
      amount: 'Rp 65.000',
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAfzQ2SHA60z2IwK1GmuiI1JjoH1lRqTnuJj52e1uUfUFTta2Vn8DMKWN9-sU4_kZvbE32skWtoLjMng7q44LJWA0ZMK092BO-FuwZMLYH9PZw9RMBkNJmLd97KpIg2hXdYB_d5x4jW9Dr5o4nBIJGiZSkTFZDzlis4Hnf4E5NiKGZM6EofLi5KbKUgf-ntaGEYPmrLtEtrdYYKvP5iSQjlzt_5IzsuIyP41LoK18A',
      status: 'Menunggu Pembayaran',
      format: '.glb',
      category: 'Vehicles',
      sizeLabel: '18 MB',
      creator: 'Drone Works',
    ),
  ];

  List<_Transaction> get _filtered => _all.where((item) {
    final q = _query.toLowerCase();
    final matchesQuery =
        item.title.toLowerCase().contains(q) ||
        item.id.toLowerCase().contains(q);
    final matchesFilter =
        _filter == 'Semua Status' ||
        (_filter == 'Berhasil' && item.status == 'Berhasil') ||
        (_filter == 'Menunggu' && item.status != 'Berhasil');
    return matchesQuery && matchesFilter;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.94),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.profile);
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontVariations: [FontVariation('wght', 700)],
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _snack('Tautan riwayat transaksi disalin.'),
            icon: const Icon(Icons.share_outlined),
          ),
          Container(
            margin: const EdgeInsets.only(right: 14),
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 17, color: AppColors.primary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Cari ID pesanan, nama aset 3D...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                    prefixIcon: const Icon(Icons.search, size: 21),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLowest,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _filterButton(),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _statusChip('Semua Status', '${_all.length}'),
                _statusChip(
                  'Berhasil',
                  '${_all.where((item) => item.status == 'Berhasil').length}',
                ),
                _statusChip(
                  'Menunggu',
                  '${_all.where((item) => item.status != 'Berhasil').length}',
                ),
                _statusChip('Dibatalkan', '0'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_filtered.isEmpty)
            const _EmptyTransactions()
          else
            for (final item in _filtered) ...[
              _transactionCard(item),
              const SizedBox(height: 16),
            ],
          const SizedBox(height: 14),
          _vaultNotice(),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return SizedBox(
      width: 52,
      height: 52,
      child: TextButton(
        onPressed: () => _snack('Filter lanjutan siap digunakan.'),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.surfaceContainerLowest,
          foregroundColor: AppColors.onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Icon(Icons.tune, size: 22),
      ),
    );
  }

  Widget _statusChip(String label, String count) {
    final selected = _filter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: GestureDetector(
        onTap: () => setState(() => _filter = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.onPrimary : AppColors.onSurface,
              ),
              children: [
                if (label != 'Semua Status')
                  TextSpan(
                    text: '  $count',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.tertiaryFixed
                          : AppColors.tertiary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _transactionCard(_Transaction item) {
    final pending = item.status != 'Berhasil';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.id,
                      style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(item.status),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _thumbnail(item.image),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          pending ? Icons.timer_outlined : Icons.qr_code_2,
                          size: 15,
                          color: pending
                              ? AppColors.error
                              : AppColors.secondary,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            item.payment,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: pending
                                  ? AppColors.error
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 10,
                      letterSpacing: 1,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.amount,
                    style: const TextStyle(
                      fontFamily: 'Noto Serif',
                      fontVariations: [FontVariation('wght', 700)],
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 8,
            children: [
              TextButton.icon(
                onPressed: () => _openDetail(item),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLow,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text(
                  'Detail',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
              if (!pending)
                OutlinedButton.icon(
                  onPressed: () =>
                      InvoicePdfGenerator.showPreview(context, item.toRecord()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  label: const Text(
                    'Unduh Faktur',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: () => context.push(AppRouter.checkout),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text(
                    'Lanjutkan Pembayaran',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumbnail(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 84,
        height: 84,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image.isEmpty)
              Container(
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.view_in_ar, color: AppColors.outline),
              )
            else
              Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.surfaceContainerHigh,
                  child: const Icon(Icons.view_in_ar, color: AppColors.outline),
                ),
              ),
            Positioned(
              right: 5,
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                color: Colors.black.withValues(alpha: 0.58),
                child: const Text(
                  '3D',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final pending = status != 'Berhasil';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: pending ? const Color(0xFFFFF7E1) : const Color(0xFFE8FAF1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: pending
                  ? const Color(0xFFD17A00)
                  : const Color(0xFF009B68),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: pending
                  ? const Color(0xFF8A5300)
                  : const Color(0xFF006C4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vaultNotice() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.tertiary,
              size: 21,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Semua transaksi dilindungi enkripsi SSL 256-Bit dan\ndiverifikasi otomatis.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'POLYCRAFT DIGITAL VAULT â€¢ 2026',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 10.5,
              letterSpacing: 1.2,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.onSurface.withValues(alpha: 0.045),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  void _openDetail(_Transaction item) {
    context.push(AppRouter.transactionDetail, extra: item.toRecord());
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Transaction {
  const _Transaction({
    required this.id,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.payment,
    required this.amount,
    required this.image,
    required this.status,
    this.format = '.glb',
    this.category = 'Umum',
    this.sizeLabel = 'â€”',
    this.creator = 'Studio 3DMarket',
    this.record,
  });

  /// Membentuk baris riwayat dari pembelian yang benar-benar terjadi.
  factory _Transaction.fromRecord(PurchaseRecord record) {
    return _Transaction(
      id: '#${record.orderId}',
      date: record.purchasedAtLabel,
      title: record.title,
      subtitle: '1 Aset 3D (${record.format}) Â· ${record.sizeLabel}',
      payment: record.paymentMethod,
      amount: record.totalLabel,
      image: '',
      status: 'Berhasil',
      format: record.format,
      category: record.category,
      sizeLabel: record.sizeLabel,
      creator: record.creator,
      record: record,
    );
  }

  final String id;
  final String date;
  final String title;
  final String subtitle;
  final String payment;
  final String amount;
  final String image;
  final String status;
  final String format;
  final String category;
  final String sizeLabel;
  final String creator;

  /// Transaksi asli dari [PurchaseStore]; `null` untuk data contoh.
  final PurchaseRecord? record;

  /// Data faktur untuk baris ini. Isinya selalu mengikuti metadata aset yang
  /// tercantum pada kartu, sehingga dokumen dan tampilan tidak berbeda.
  PurchaseRecord toRecord() {
    final existing = record;
    if (existing != null) return existing;

    final total = priceValue(amount);
    final fee = total == 0 ? 0 : PurchaseStore.serviceFee;
    return PurchaseRecord(
      orderId: id.replaceFirst('#', ''),
      licenseKey: extractLicenseKey(id),
      title: title,
      category: category,
      format: format,
      sizeLabel: sizeLabel,
      creator: creator,
      description: subtitle,
      modelUrl: '',
      itemPrice: total > fee ? total - fee : total,
      serviceFee: total > fee ? fee : 0,
      total: total,
      paymentMethod: payment,
      purchasedAt: _parseDate(date),
    );
  }

  static DateTime _parseDate(String label) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'Mei': 5,
      'Jun': 6,
      'Jul': 7,
      'Agu': 8,
      'Sep': 9,
      'Okt': 10,
      'Nov': 11,
      'Des': 12,
    };
    final match = RegExp(r'(\d{1,2}) (\w{3}) (\d{4}), (\d{2}):(\d{2})')
        .firstMatch(label);
    if (match == null) return DateTime.now();
    return DateTime(
      int.parse(match.group(3)!),
      months[match.group(2)!] ?? 1,
      int.parse(match.group(1)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, size: 32, color: AppColors.outline),
          SizedBox(height: 8),
          Text(
            'Transaksi tidak ditemukan.',
            style: TextStyle(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
