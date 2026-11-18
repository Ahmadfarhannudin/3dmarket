import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/widgets/buyer_app_bar.dart';
import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/features/auth/domain/auth_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _autoExtract = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const BuyerAppBar(section: 'PROFIL'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _heroCard(context),
          _sectionHeader('Aktivitas & Pembelian', 'Histori Arsip'),
          _activityCard(context),
          _sectionHeader('Preferensi Blender & Workflow', 'Pipeline'),
          _preferencesCard(context),
          _sectionHeader('Dukungan & Ketentuan Legal', 'Kurasi Etis'),
          _legalCard(context),
          _logoutButton(context),
          const SizedBox(height: 16),
          const _VersionNote(),
        ],
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                right: -18,
                bottom: -30,
                child: IgnorePointer(
                  child: Icon(
                    Icons.view_in_ar,
                    size: 130,
                    color: AppColors.onSurface.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        onBackgroundImageError: (_, _) {},
                        backgroundImage: const NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD6s9tr_UnQFCHfDUCjgp6naiOsQn2GLelxdZha-IrK38Z8k_Ofvh9vwDIzNNtx2yWROJKDgBllBQZu-CugGjanVBeMiG1OtaM8iJ6h9sxHCK-NpcoxE71P-6a7YtdUPomXblBdeuYh3WKvcgmDKPo3LDlaA5VDZe5-DS-T8vdxG1LWm2ZAM_4YTfwX6TTaPAdiD1G5D2rdMSLRzcv_g6J6PfKy2WTFERZVGGU9rLM',
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 13,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Flexible(
                              child: Text(
                                'Deva Praditya',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Noto Serif',
                                  fontVariations: [FontVariation('wght', 600)],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryFixed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRO CURATOR',
                                style: TextStyle(
                                  fontFamily: 'Public Sans',
                                  fontVariations: [FontVariation('wght', 700)],
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  height: 1.2,
                                  color: AppColors.onTertiaryFixed,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Blender 3D Environment & Rigging Artist · Anggota '
                          'sejak Mar 2023',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            height: 1.4,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(
                              Icons.mail_outline,
                              size: 14,
                              color: AppColors.secondary,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'deva.praditya@creativecraft.io',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                _Metric('14', 'Aset Koleksi', AppColors.primary),
                _MetricDivider(),
                _Metric('6', 'Transaksi', AppColors.onSurface),
                _MetricDivider(),
                _Metric('Rp 850k', 'Investasi', AppColors.tertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Noto Serif',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            trailing.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 500)],
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _activityCard(BuildContext context) {
    return _card(
      children: [
        _MenuRow(
          icon: Icons.receipt_long,
          title: 'Riwayat Transaksi',
          subtitle: 'Faktur & tanda terima digital',
          trailing: const _Chip('6 Pesanan'),
          onTap: () => context.go(AppRouter.profileTransactionHistory),
        ),
        _MenuRow(
          icon: Icons.update,
          title: 'Notifikasi & Update Model',
          subtitle: 'Pembaruan file mesh .blend',
          highlighted: true,
          trailing: const _Chip('3 Baru', emphasized: true),
          onTap: () => context.push(AppRouter.notifications),
        ),
        _MenuRow(
          icon: Icons.bookmark,
          iconColor: AppColors.tertiary,
          title: 'Koleksi Favorit & Wishlist',
          subtitle: 'Aset 3D siap diakuisisi',
          trailing: const Text(
            '12 Disimpan',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            ),
          ),
          onTap: () => context.go(AppRouter.profileWishlist),
        ),
      ],
    );
  }

  Widget _preferencesCard(BuildContext context) {
    return _card(
      children: [
        _MenuRow(
          icon: Icons.view_in_ar_outlined,
          muted: true,
          title: 'Target Versi Blender',
          subtitle: 'Kompatibilitas geometri & node',
          trailing: const _Chip('Blender 4.2 LTS'),
          showChevron: false,
          onTap: null,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        ),
        _MenuRow(
          icon: Icons.wb_iridescent,
          muted: true,
          title: 'Render Engine Utama',
          subtitle: 'Shader PBR siap render',
          trailing: const _Chip('Cycles GPU & EEVEE Next'),
          showChevron: false,
          onTap: null,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              _IconBox(icon: Icons.folder_zip, muted: true),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ekstrak Otomatis File .ZIP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Simpan langsung ke folder Library',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: _autoExtract,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.surfaceContainerLowest,
                inactiveTrackColor: AppColors.surfaceContainerHighest,
                onChanged: (v) => setState(() => _autoExtract = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legalCard(BuildContext context) {
    void notify(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    return _card(
      children: [
        _MenuRow(
          icon: Icons.gavel,
          muted: true,
          title: 'Panduan Lisensi Standard & Extended',
          trailing: const Icon(
            Icons.arrow_outward,
            size: 16,
            color: AppColors.outline,
          ),
          showChevron: false,
          onTap: () => notify('Membuka panduan lisensi Standard & Extended.'),
        ),
        _MenuRow(
          icon: Icons.forum,
          muted: true,
          title: 'Pusat Bantuan & Komunitas Discord PolyCraft',
          trailing: const Icon(
            Icons.arrow_outward,
            size: 16,
            color: AppColors.outline,
          ),
          showChevron: false,
          onTap: () => notify('Membuka pusat bantuan & Discord PolyCraft.'),
        ),
        _MenuRow(
          icon: Icons.flag,
          muted: true,
          title: 'Laporkan Masalah Topologi Aset (N-Gons / UV)',
          trailing: const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.outline,
          ),
          onTap: () => notify('Form laporan topologi aset dibuka.'),
        ),
      ],
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: SizedBox(
        height: 48,
        child: TextButton.icon(
          onPressed: () {
            AuthSession.instance.signOut();
            context.go(AppRouter.login);
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.errorContainer.withValues(alpha: 0.40),
            foregroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            overlayColor: AppColors.error.withValues(alpha: 0.10),
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text(
            'KELUAR AKUN (LOGOUT)',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 600)],
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */

class _Metric extends StatelessWidget {
  const _Metric(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Noto Serif',
              fontVariations: const [FontVariation('wght', 700)],
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 9.5,
              letterSpacing: 0.8,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.outline.withValues(alpha: 0.20),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    this.color = AppColors.primary,
    this.muted = false,
  });

  final IconData icon;
  final Color color;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 19,
        color: muted ? AppColors.onSurfaceVariant : color,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, {this.emphasized = false});

  final String text;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: emphasized ? AppColors.primary : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Public Sans',
          fontVariations: [FontVariation('wght', emphasized ? 600 : 500)],
          fontSize: emphasized ? 9.5 : 10.5,
          fontWeight: emphasized ? FontWeight.w600 : FontWeight.w500,
          height: 1.3,
          color: emphasized ? AppColors.onPrimary : AppColors.secondary,
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor = AppColors.primary,
    this.muted = false,
    this.highlighted = false,
    this.showChevron = true,
    this.padding = const EdgeInsets.all(14),
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color iconColor;
  final bool muted;
  final bool highlighted;
  final bool showChevron;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? AppColors.surfaceContainerLow : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              _IconBox(icon: icon, color: iconColor, muted: muted),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: AppColors.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.3,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              if (showChevron) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.outline,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionNote extends StatelessWidget {
  const _VersionNote();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'PolyCraft 3D Mobile v1.4.0 (Build 2026.11)',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontStyle: FontStyle.italic,
            fontSize: 11,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'ALEXANDRIA EDITORIAL THEME',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 9.5,
            letterSpacing: 1.6,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}
