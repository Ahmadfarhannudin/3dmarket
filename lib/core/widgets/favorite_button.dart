import 'package:flutter/material.dart';

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
              final added = WishlistStore.instance.toggle(asset);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      added
                          ? '${asset.title} ditambahkan ke wishlist.'
                          : '${asset.title} dihapus dari wishlist.',
                    ),
                    duration: Duration(milliseconds: added ? 3000 : 1600),
                    action: added
                        ? SnackBarAction(
                            label: 'Lihat Wishlist',
                            onPressed: () {
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.wishlist,
                                );
                              }
                            },
                          )
                        : null,
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
