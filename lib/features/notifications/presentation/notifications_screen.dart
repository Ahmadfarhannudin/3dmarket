import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/navigation/main_tab.dart';
import 'package:_3dmarket/app/router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'Semua 4';

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.94),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontVariations: [FontVariation('wght', 700)],
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _toast('Tautan notifikasi disalin.'),
            icon: const Icon(Icons.share_outlined, size: 20),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
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
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'ARSIP AKTIVITAS',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _toast('Semua notifikasi ditandai dibaca.'),
                child: const Row(
                  children: [
                    Icon(Icons.done_all, size: 15, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Tandai Semua Dibaca',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _filterChips(),
          const SizedBox(height: 18),
          _sectionHeader('HARI INI', '2 item baru'),
          const SizedBox(height: 12),
          _card1(),
          const SizedBox(height: 12),
          _card2(),
          const SizedBox(height: 20),
          _sectionHeader('KEMARIN & MINGGU INI', 'Arsip kurasi'),
          const SizedBox(height: 12),
          _card3(),
          const SizedBox(height: 12),
          _card4(),
          const SizedBox(height: 20),
          _readNotice(),
        ],
      ),
    );
  }

  Widget _filterChips() {
    final filters = ['Semua 4', 'Pembaruan Aset 2', 'Transaksi 1'];
    return Row(
      children: [
        for (final f in filters)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _filter == f
                      ? AppColors.primary
                      : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 11.5,
                    fontWeight: _filter == f ? FontWeight.w700 : FontWeight.w500,
                    color: _filter == f
                        ? AppColors.onPrimary
                        : AppColors.onSurface,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionHeader(String title, String trailing) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Public Sans',
            fontVariations: [FontVariation('wght', 700)],
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          trailing,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /* ------------------------------- Card 1 ---------------------------------- */

  Widget _card1() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconBox(Icons.published_with_changes, unread: true),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PEMBARUAN VERSI',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Update File: Cybernetic Arm Rigged v2.1',
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '15 mnt lalu',
                style: TextStyle(fontSize: 10.5, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Obsidian X Lab baru saja memperbarui rig IK/FK untuk Blender 4.2 LTS. '
            'Unduh pembaruan sekarang tanpa biaya tambahan.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBb7s7C6IL2oVd0AINCKPk-9nWlxjFfwBTsCP_M-wYj5WPeE_JzaVsiYP79Hd1J5vmAsiLNRT-tNBfM9gJ8j4PADasmWK5Bg2msvpmo2OcMq8dJcjPl2lF5qMVGI6dNRKoGnXIaOv3Du2fj9kjJDFazVVyCRFudnasjpsGtaDvKedUKLp1pvap_3RwjlKA-PaQkKMgj0aZkmXmzSCpG6gCmzMBB1im4s_SS8_o5k28',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cybernetic Arm Rigged',
                        style: TextStyle(
                          fontFamily: 'Noto Serif',
                          fontVariations: [FontVariation('wght', 600)],
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Blend 4.2 â€¢ FBX   â€¢   184 MB',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextButton.icon(
                    onPressed: () => _toast('Mengunduh update v2.1...'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: const Icon(Icons.download_outlined, size: 16),
                    label: const Text(
                      'Unduh Update',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 38,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.detail),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerLow,
                    foregroundColor: AppColors.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Detail Versi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ------------------------------- Card 2 ---------------------------------- */

  Widget _card2() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconBox(Icons.verified_outlined, unread: true),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FAKTUR PEMBELIAN',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pembayaran Berhasil â€” #ORD-202611-8921',
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '2 jam lalu',
                style: TextStyle(fontSize: 10.5, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Lisensi komersial '),
                TextSpan(
                  text: 'Cyberpunk Cybernetic Arm',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const TextSpan(
                  text: ' telah aktif di vault akun Anda. Sertifikat lisensi '
                      'kriptografis tersedia untuk diunduh.',
                ),
              ],
            ),
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Rp 285.000 (Lunas)',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.transactionHistory),
                child: const Row(
                  children: [
                    Text(
                      'Lihat Faktur',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ------------------------------- Card 3 ---------------------------------- */

  Widget _card3() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconBox(Icons.auto_awesome_outlined, bg: AppColors.tertiaryFixed),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EDITORIAL ALEXANDRIA',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.tertiary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Koleksi Baru: Pilihan Kurator Minggu Ini',
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '1 hari lalu',
                style: TextStyle(fontSize: 10.5, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Kumpulan shader procedural arsitektur Cycles telah diterbitkan '
            'dengan diskon pembeli pertama 30%. Teruji untuk visualisasi '
            'arsitektural resolusi ultra.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC9LXGENDfI5y4ruOU7bhLIrfsg5LrKEH7BpxPwLCaQJt1MULYJHniLJCV3v_LdaZmyhJPRMV17DYsQghasGcNLO8RBW480IVG7PZPgVYNjaU1R0G4Ypt6xuYaFhtdFORrFbuh2GLz40Xi-H2O4XnnmEouCXuYLQ52h4CeCT665pjIfrsLeUPoEafXR3A5rf0PsJi-FieOwXaS6e2F8tlWm2o1RdpO4X-syRje6mZE',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'KURASI EDISI NO. 42',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Berakhir dalam 48 jam',
                style: TextStyle(fontSize: 11, color: AppColors.secondary),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => MainTab.open(context, MainTab.explore),
                child: const Row(
                  children: [
                    Text(
                      'Jelajahi Kurasi',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.north_east, size: 13, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ------------------------------- Card 4 ---------------------------------- */

  Widget _card4() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconBox(Icons.local_offer_outlined),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PENURUNAN HARGA',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Aset Wishlist Anda Sedang Diskon!',
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '3 hari lalu',
                style: TextStyle(fontSize: 10.5, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Chronograph Horology Masterpiece '),
                const TextSpan(text: 'sekarang '),
                TextSpan(
                  text: 'Rp 115.000',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const TextSpan(
                  text: ' (Hemat 40% dari harga normal Rp 192.000).',
                ),
              ],
            ),
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC9LXGENDfI5y4ruOU7bhLIrfsg5LrKEH7BpxPwLCaQJt1MULYJHniLJCV3v_LdaZmyhJPRMV17DYsQghasGcNLO8RBW480IVG7PZPgVYNjaU1R0G4Ypt6xuYaFhtdFORrFbuh2GLz40Xi-H2O4XnnmEouCXuYLQ52h4CeCT665pjIfrsLeUPoEafXR3A5rf0PsJi-FieOwXaS6e2F8tlWm2o1RdpO4X-syRje6mZE',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chronograph Horology M...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Noto Serif',
                          fontVariations: [FontVariation('wght', 600)],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Text(
                            'Rp 115.000',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontVariations: [FontVariation('wght', 700)],
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rp 192.000',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 10,
                              color: AppColors.outline,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.checkout),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Beli',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* --------------------------------- Notice -------------------------------- */

  Widget _readNotice() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 19,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Semua Notifikasi Terbaca',
            style: TextStyle(
              fontFamily: 'Noto Serif',
              fontVariations: [FontVariation('wght', 600)],
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kelola preferensi notifikasi push, pembaruan rilis 3D, '
            'dan sinyal kurasi di Pengaturan Profil.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _toast('Preferensi notifikasi dibuka di Pengaturan.'),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune, size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Text(
                  'Atur Preferensi Notifikasi',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon, {bool unread = false, Color? bg}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bg ?? AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: bg != null ? AppColors.onTertiaryFixed : AppColors.primary,
          ),
        ),
        if (unread)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  BoxDecoration _cardBox() => BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
}
