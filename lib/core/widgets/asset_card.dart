import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/utils/model_source.dart';

class AssetCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String rating;
  final String downloads;
  final String format;
  final bool isFree;
  final VoidCallback? onTap;
  final bool isLocalImage;
  final bool isGlbModel;

  /// Jika diisi, kartu menampilkan preview 3D interaktif (file .glb)
  /// dari asset lokal, bukan gambar statis.
  final String? modelPath;

  /// Label kategori yang ditampilkan di bawah judul (opsional).
  final String? category;

  const AssetCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.downloads,
    this.format = '.blend',
    this.isFree = false,
    this.onTap,
    this.isLocalImage = false,
    this.isGlbModel = false,
    this.modelPath,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildPreview(),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [
                    _buildBadge(format, AppColors.primary, Colors.white),
                    if (isFree) ...[
                      const SizedBox(width: 4),
                      _buildBadge(
                        'GRATIS',
                        AppColors.tertiaryFixed,
                        AppColors.onTertiaryFixed,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.tertiary,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$downloads downloads',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                if (category != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    category!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HARGA LISENSI',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isFree
                                  ? AppColors.tertiary
                                  : AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFree
                              ? AppColors.surfaceContainerHighest
                              : AppColors.primary,
                          foregroundColor: isFree
                              ? AppColors.primary
                              : AppColors.onPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          isFree ? 'Unduh' : 'Beli',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildPreview() {
    // Prioritas tertinggi: preview 3D interaktif dari file GLB.
    if (modelPath != null && modelPath!.isNotEmpty) {
      return SizedBox(
        height: 160,
        width: double.infinity,
        child: IgnorePointer(
          // Agar scroll halaman tidak terganggu oleh WebView di dalam kartu.
          child: ModelViewer(
            src: resolveModelSource(modelPath!),
            backgroundColor: AppColors.surfaceContainerLow,
            autoRotate: true,
            cameraControls: false,
            disableZoom: true,
            disablePan: true,
            loading: Loading.eager,
            debugLogging: false,
            relatedCss: 'model-viewer{--poster-color:transparent;}',
          ),
        ),
      );
    }

    // Fallback lama: gambar statis / placeholder.
    return Image.asset(
      'assets/images/onboarding_hero.png',
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _AssetImageFallback(),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AssetImageFallback extends StatelessWidget {
  const _AssetImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerLow,
      alignment: Alignment.center,
      child: const Icon(
        Icons.view_in_ar,
        size: 34,
        color: AppColors.outline,
      ),
    );
  }
}


