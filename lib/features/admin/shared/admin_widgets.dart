import 'package:flutter/material.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';

/// Menampilkan pesan singkat dengan mengganti snackbar yang sedang tampil.
void adminSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Dekorasi kartu standar panel admin.
BoxDecoration adminCardDecoration() {
  return BoxDecoration(
    color: AppColors.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.onSurface.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

/// Judul halaman tab admin (overline + judul serif + subjudul).
Widget adminTabTitle(String title, String subtitle, String overline) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        overline,
        style: const TextStyle(
          fontFamily: 'Public Sans',
          fontVariations: [FontVariation('wght', 700)],
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          color: AppColors.tertiary,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Noto Serif',
          fontVariations: [FontVariation('wght', 600)],
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: AppColors.onSurface,
        ),
      ),
      Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.secondary),
      ),
    ],
  );
}

class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle({
    super.key,
    required this.overline,
    required this.title,
    this.trailing,
    this.onTrailing,
    this.badge,
  });

  final String overline;
  final String title;
  final String? trailing;
  final VoidCallback? onTrailing;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overline.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontVariations: [FontVariation('wght', 700)],
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontVariations: [FontVariation('wght', 600)],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: onTrailing,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  trailing!,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  size: 13,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge!,
              style: const TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
            ),
          ),
      ],
    );
  }
}

class AdminSearchField extends StatelessWidget {
  const AdminSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 12.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: AppColors.secondary),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppColors.secondary,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class AdminFilterChip extends StatelessWidget {
  const AdminFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontVariations: [FontVariation('wght', selected ? 600 : 500)],
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.onPrimary : AppColors.secondary,
          ),
        ),
      ),
    );
  }
}

/// Baris label-nilai di dalam bottom sheet admin.
Widget adminSheetRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.secondary),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    ),
  );
}

class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.footer,
    this.suffix,
  });

  final String label;
  final String value;
  final String? suffix;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    height: 1.3,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value),
                if (suffix != null)
                  TextSpan(
                    text: ' $suffix',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  ),
              ],
            ),
            style: const TextStyle(
              fontFamily: 'Noto Serif',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              height: 1.1,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          footer,
        ],
      ),
    );
  }
}
class AdminBar extends StatelessWidget {
  const AdminBar({super.key, required this.fill, required this.emphasize});

  final double fill;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final trackColor = emphasize
        ? AppColors.primaryFixed
        : AppColors.surfaceContainerHigh;

    return Container(
      height: emphasize ? 92 : 74,
      width: double.infinity,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: fill,
          child: Container(
            decoration: BoxDecoration(
              gradient: emphasize
                  ? const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.primary, Color(0xFF3366CC)],
                    )
                  : null,
              color: emphasize ? null : AppColors.primary.withValues(alpha: 0.80),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: emphasize ? 5 : 0),
            child: emphasize
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.onPrimary,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
class AdminAssetThumb extends StatelessWidget {
  const AdminAssetThumb({
    super.key,
    required this.imageUrl,
    this.rank,
    this.rankHighlight = false,
  });

  final String? imageUrl;
  final int? rank;
  final bool rankHighlight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 52,
              height: 52,
              color: AppColors.surfaceContainer,
              child: imageUrl == null
                  ? const Icon(
                      Icons.view_in_ar,
                      size: 22,
                      color: AppColors.outline,
                    )
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.view_in_ar,
                        size: 22,
                        color: AppColors.outline,
                      ),
                    ),
            ),
          ),
          if (rank != null)
            Positioned(
              top: 3,
              left: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: rankHighlight
                      ? AppColors.primary
                      : AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: rankHighlight
                        ? AppColors.onPrimary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
class AdminPill extends StatelessWidget {
  const AdminPill({super.key, required this.label, this.dot = false});

  final String label;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            const AdminPulseDot(),
            const SizedBox(width: 5),
          ],
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
class AdminPulseDot extends StatefulWidget {
  const AdminPulseDot({super.key});

  @override
  State<AdminPulseDot> createState() => _AdminPulseDotState();
}

class _AdminPulseDotState extends State<AdminPulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.35,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.tertiary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.outline),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                    Data                                    */
/* -------------------------------------------------------------------------- */
class AdminToggleSwitch extends StatelessWidget {
  const AdminToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 40,
        height: 22,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(11),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet informasi ringkas untuk sub-menu pengaturan studio.
void showAdminInfoSheet(
  BuildContext context,
  String title,
  List<String> items,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Noto Serif',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}


