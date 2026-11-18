import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/core/utils/model_source.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.asset});

  /// Aset yang sedang dibeli. Bila null (mis. dibuka langsung), kartu pesanan
  /// memakai data contoh.
  final CatalogAsset? asset;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _method = 'qris';
  bool _processing = false;

  bool get _isFree => priceValue(widget.asset?.price ?? '') == 0;

  String get _methodLabel => switch (_method) {
    'qris' => 'QRIS Instan (Bebas Biaya)',
    'va' => 'Virtual Account Bank',
    'ewallet' => 'E-Wallet Terhubung',
    _ => 'Kartu Kredit / Debit Online',
  };

  String get _totalLabel {
    final itemPrice = priceValue(widget.asset?.price ?? '');
    if (itemPrice == 0) return 'Gratis';
    return formatRupiah(itemPrice + PurchaseStore.serviceFee);
  }

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _processing = false);

    PurchaseStore.instance.record(
      asset: widget.asset,
      paymentMethod: _methodLabel,
    );
    context.push(AppRouter.paymentStatus);
  }

  Future<void> _downloadFree() async {
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _processing = false);

    PurchaseStore.instance.record(
      asset: widget.asset,
      paymentMethod: 'Unduhan Gratis',
    );
    context.push(AppRouter.paymentStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.92),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurface,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _isFree ? 'Unduh Instan' : 'Checkout Lisensi',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        actions: const [
          Icon(Icons.share, color: AppColors.onSurfaceVariant, size: 22),
          SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: _PayBar(
        processing: _processing,
        onPay: _isFree ? _downloadFree : _pay,
        totalLabel: _totalLabel,
        isFree: _isFree,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _StepRow(),
          const SizedBox(height: 16),
          _OrderCard(asset: widget.asset),
          if (!_isFree) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                Icon(Icons.bolt, size: 14, color: AppColors.primary),
                const SizedBox(width: 2),
                Text(
                  'Verifikasi Otomatis',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MethodCard(
              value: 'qris',
              group: _method,
              title: 'Instan QRIS',
              badge: 'REKOMENDASI',
              trailing: 'Bebas Admin',
              body: 'Pindai barcode langsung via GoPay, OVO, Dana, ShopeePay, atau BCA Mobile.',
              chips: const ['QRIS 2.0', 'GoPay', 'Dana', '+3 Lainnya'],
              onChanged: (v) => setState(() => _method = v),
            ),
            _MethodCard(
              value: 'va',
              group: _method,
              title: 'Virtual Account Bank',
              icon: Icons.account_balance_outlined,
              body: 'Transfer instan dengan kode pembayaran unik verifikasi tanpa jeda.',
              chips: const ['BCA', 'Mandiri', 'BNI', 'BRI'],
              onChanged: (v) => setState(() => _method = v),
            ),
            _MethodCard(
              value: 'ewallet',
              group: _method,
              title: 'E-Wallet Terhubung',
              icon: Icons.account_balance_wallet_outlined,
              body: 'Otentikasi cepat dalam 1 klik ke aplikasi dompet digital terpasang.',
              chips: const ['GoPay Direct', 'ShopeePay'],
              onChanged: (v) => setState(() => _method = v),
            ),
            _MethodCard(
              value: 'cc',
              group: _method,
              title: 'Kartu Kredit / Debit Online',
              icon: Icons.credit_card,
              body: 'Visa, Mastercard, JCB berteknologi 3D Secure OTP.',
              chips: const [],
              onChanged: (v) => setState(() => _method = v),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download_for_offline_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Garansi Unduhan Instan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Unduh instan setelah pembayaran terkonfirmasi. Link file tersimpan selamanya pada menu Aset Saya untuk diunduh kembali kapan saja.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget step(
      String n,
      String label, {
      bool active = false,
      bool dim = false,
    }) {
      return Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dim
                  ? AppColors.surfaceContainerHighest
                  : AppColors.primary,
              shape: BoxShape.circle,
              border: active
                  ? Border.all(color: AppColors.primaryFixed, width: 3)
                  : null,
            ),
            child: Text(
              n,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: dim ? AppColors.onSurfaceVariant : AppColors.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: dim ? FontWeight.w500 : FontWeight.w600,
              color: dim
                  ? AppColors.onSurfaceVariant
                  : (active ? AppColors.onSurface : AppColors.primary),
            ),
          ),
        ],
      );
    }

    Widget line({bool filled = false}) => Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );

    return Row(
      children: [
        step('1', 'Pesanan'),
        line(filled: true),
        step('2', 'Pembayaran', active: true),
        line(),
        Opacity(opacity: 0.5, child: step('3', 'Download', dim: true)),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({this.asset});

  final CatalogAsset? asset;

  @override
  Widget build(BuildContext context) {
    final itemPrice = priceValue(asset?.price ?? '');
    final fee = itemPrice == 0 ? 0 : PurchaseStore.serviceFee;
    final total = itemPrice + fee;
    final format = asset?.format ?? '.glb';
    final hasModel = asset != null && asset!.hasModelPreview;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: hasModel
                      ? IgnorePointer(
                          child: ModelViewer(
                            src: resolveModelSource(asset!.assetKey),
                            backgroundColor: AppColors.surfaceContainerHigh,
                            autoRotate: true,
                            cameraControls: false,
                            disableZoom: true,
                            disablePan: true,
                            loading: Loading.eager,
                            debugLogging: false,
                            relatedCss:
                                'model-viewer{--poster-color:transparent;}',
                          ),
                        )
                      : Container(
                          color: AppColors.surfaceContainerHigh,
                          child: const Icon(
                            Icons.view_in_ar,
                            color: AppColors.outline,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 14,
                          color: AppColors.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          asset?.category ?? 'Curated Asset',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset?.title ?? 'Cyberpunk Cybernetic Arm Rigged',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Chip(format),
                        if (asset?.sizeLabel != null) _Chip(asset!.sizeLabel),
                        _Chip('${asset?.creator ?? 'Studio 3DMarket'}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Standard Commercial License',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Hak komersial penuh untuk 1 proyek utama & turunannya selamanya.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _PriceLine(
            'Subtotal Item',
            itemPrice == 0 ? 'Gratis' : formatRupiah(itemPrice),
          ),
          const SizedBox(height: 6),
          _PriceLine(
            'Biaya Layanan & Verifikasi',
            fee == 0 ? 'Gratis' : formatRupiah(fee),
          ),
          const Divider(height: 20, color: AppColors.surfaceContainerHigh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                formatRupiah(total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.value,
    required this.group,
    required this.title,
    required this.body,
    required this.chips,
    required this.onChanged,
    this.badge,
    this.trailing,
    this.icon,
  });

  final String value;
  final String group;
  final String title;
  final String body;
  final List<String> chips;
  final ValueChanged<String> onChanged;
  final String? badge;
  final String? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final selected = value == group;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChanged(value),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.transparent,
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio<String>(
                  value: value,
                  groupValue: group,
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onChanged: (v) {
                    if (v != null) onChanged(v);
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryFixed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge!,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onTertiaryFixed,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (trailing != null)
                            Text(
                              trailing!,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            )
                          else if (icon != null)
                            Icon(icon, size: 16, color: AppColors.outline),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      if (chips.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: chips.map(_Chip.new).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PayBar extends StatelessWidget {
  const _PayBar({
    required this.processing,
    required this.onPay,
    required this.totalLabel,
    this.isFree = false,
  });
  final bool processing;
  final VoidCallback onPay;
  final String totalLabel;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface.withValues(alpha: 0.95),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFree) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'TOTAL TAGIHAN',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 2),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              totalLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF2259BF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton.icon(
              onPressed: processing ? null : onPay,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: processing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : Icon(
                      isFree
                          ? Icons.cloud_download_outlined
                          : Icons.lock_outline,
                      size: 16,
                    ),
              label: Text(
                processing
                    ? 'Memproses...'
                    : isFree
                    ? 'Unduh Sekarang'
                    : 'Bayar Sekarang',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (!isFree) ...[
            const SizedBox(height: 6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, size: 13, color: AppColors.tertiary),
                SizedBox(width: 4),
                Text(
                  'Enkripsi SSL 256-Bit • Terverifikasi Aman',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
