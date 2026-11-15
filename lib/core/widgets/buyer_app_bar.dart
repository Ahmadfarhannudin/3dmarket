import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/app/router.dart';

/// Header konsisten untuk seluruh halaman pembeli (Beranda, Jelajah,
/// Aset Saya, Profil).
///
/// Menampilkan:
/// - Logo bundar `3DMARKET` + nama halaman aktif
/// - Tombol notifikasi (membuka halaman notifikasi)
/// - Avatar pengguna (membuka tab Profil)
///
/// [section] menentukan sub-judul kecil di bawah logo, mis. `BERANDA`.
class BuyerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BuyerAppBar({
    super.key,
    required this.section,
    this.showBackButton = false,
  });

  /// Nama halaman aktif, mis. `BERANDA`, `JELAJAH`, `ASET SAYA`, `PROFIL`.
  final String section;

  /// Tampilkan tombol kembali (untuk halaman turunan dari tab pembeli).
  final bool showBackButton;

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDy0oFGuznKCUhf-qa5wXD6d6pmOCOBZW_L2D4NTWDu4Uwq80-S1RVzKxqRqbUhXZMnUdF1fBBgZRSk0Som9Ppq_SwIBXLXob8nmaUhXmI-R26akQcPWkO-9FCdHMSQagPXp6Wo_v1kp737N95HfHHJYVIZQuC9DV9n2kvXB2M3NguO3UOAOVzaDmPGse93uW39kGR145FfnNXHd19iW6qLrySYMWXFbO0qCzznqoY';

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface.withValues(alpha: 0.94),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 19),
              color: AppColors.onSurface,
            )
          : null,
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: const Icon(
                Icons.view_in_ar,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '3DMARKET',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    section,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColors.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Notifikasi',
          onPressed: () => Navigator.pushNamed(context, AppRouter.notifications),
          icon: const Icon(
            Icons.notifications_none,
            size: 22,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRouter.profile),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryFixed,
              onBackgroundImageError: (_, _) {},
              backgroundImage: const NetworkImage(_avatarUrl),
            ),
          ),
        ),
      ],
    );
  }
}
