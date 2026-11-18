import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/features/wishlist/domain/wishlist_state.dart';

/// Tombol hati untuk menyimpan aset ke wishlist.
///
/// Menekan tombol tidak memindahkan halaman: aset hanya masuk (atau keluar
/// dari) wishlist, lalu muncul konfirmasi singkat. Ini mencegah pengguna
/// kehilangan posisi saat sedang menjelajah katalog.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.asset,
    this.size = 32,
    this.background = Colors.white,
  });

  final CatalogAsset asset;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: WishlistStore.instance,
      builder: (context, _) {
        final saved = WishlistStore.instance.contains(asset);
        return Material(
          color: background.withValues(alpha: 0.92),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              final messenger = ScaffoldMessenger.of(context);
              final added = WishlistStore.instance.toggle(asset);
              messenger
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    // Aksi "Lihat" ditempatkan di dalam konten, bukan memakai
                    // SnackBarAction. SnackBar dengan action tidak auto-close
                    // saat accessible navigation aktif, sehingga popup bisa
                    // menempel sampai tombolnya ditekan.
                    content: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: added
                          ? () {
                              messenger.removeCurrentSnackBar();
                              if (context.mounted) {
                                context.go(AppRouter.wishlist);
                              }
                            }
                          : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              added
                                  ? '${asset.title} ditambahkan ke wishlist.'
                                  : '${asset.title} dihapus dari wishlist.',
                            ),
                          ),
                          if (added) ...[
                            const SizedBox(width: 8),
                            const Text(
                              'Lihat',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    duration: Duration(seconds: added ? 5 : 2),
                  ),
                );
            },
            child: SizedBox(
              width: size,
              height: size,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(saved),
                  size: size * 0.56,
                  color: saved
                      ? const Color(0xFFD93A4A)
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
