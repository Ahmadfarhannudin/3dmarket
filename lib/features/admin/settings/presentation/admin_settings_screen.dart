import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';
import 'package:_3dmarket/features/auth/domain/auth_session.dart';

/// Tab pengaturan operasional studio admin.
class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _meshValidation = true;
  bool _autoSync = true;
  bool _maintenance = false;

  @override
  Widget build(BuildContext context) => _settingsBody();
  Widget _settingsBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        adminTabTitle(
          'Pengaturan Studio',
          'Konfigurasi operasional',
          'SETTINGS',
        ),
        const SizedBox(height: 16),
        _settingsSection('Operasional', [
          AdminSettingsRowData(
            icon: Icons.group_outlined,
            title: 'Kelola Pengguna & Kreator',
            subtitle: '1.420 akun â€¢ 12 permohonan baru',
            onTap: () => context.push(AppRouter.adminUsers),
          ),
          AdminSettingsRowData(
            icon: Icons.category_outlined,
            title: 'Kelola Kategori & Taksonomi',
            subtitle: '8 kategori aktif',
            onTap: () => context.push(AppRouter.adminCategories),
          ),
          AdminSettingsRowData(
            icon: Icons.view_carousel_outlined,
            title: 'Kelola Banner & Promosi',
            subtitle: '3 banner aktif',
            onTap: () => context.push(AppRouter.adminBanners),
          ),
        ]),
        _settingsSection('Penyimpanan & Validasi', [
          AdminSettingsRowData(
            icon: Icons.cloud_outlined,
            title: 'Penyimpanan Berkas 3D',
            subtitle: '248,5 GB dari 1 TB',
            onTap: () => showAdminInfoSheet(context, 'Penyimpanan Berkas 3D', [
              'Terpakai: 248,5 GB',
              'Sisa: 775,5 GB',
              'Model: 3.842 file',
            ]),
          ),
          AdminSettingsRowData(
            icon: Icons.verified_user_outlined,
            title: 'Validasi Mesh Otomatis',
            subtitle: 'Cek N-Gons dan non-manifold saat upload',
            trailing: Switch(
              value: _meshValidation,
              activeThumbColor: AppColors.onPrimary,
              activeTrackColor: AppColors.primary,
              onChanged: (v) => setState(() => _meshValidation = v),
            ),
          ),
          AdminSettingsRowData(
            icon: Icons.sync,
            title: 'Auto-Sync Lisensi',
            subtitle: 'Sinkronkan status transaksi real-time',
            trailing: Switch(
              value: _autoSync,
              activeThumbColor: AppColors.onPrimary,
              activeTrackColor: AppColors.primary,
              onChanged: (v) => setState(() => _autoSync = v),
            ),
          ),
          AdminSettingsRowData(
            icon: Icons.construction_outlined,
            title: 'Mode Maintenance',
            subtitle: 'Sembunyikan katalog dari pembeli',
            trailing: Switch(
              value: _maintenance,
              activeThumbColor: AppColors.onPrimary,
              activeTrackColor: AppColors.error,
              onChanged: (v) {
                setState(() => _maintenance = v);
                adminSnack(
                  context,
                  v
                      ? 'Mode maintenance aktif. Katalog disembunyikan.'
                      : 'Mode maintenance dimatikan.',
                );
              },
            ),
          ),
        ]),
        const SizedBox(height: 16),
        SizedBox(
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
            ),
            icon: const Icon(Icons.logout, size: 18),
            label: const Text(
              'KELUAR DARI STUDIO ADMIN',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingsSection(String title, List<AdminSettingsRowData> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: AppColors.secondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: adminCardDecoration(),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                AdminSettingsRow(data: rows[i]),
                if (i != rows.length - 1)
                  Divider(
                    height: 1,
                    color: AppColors.outline.withValues(alpha: 0.12),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AdminSettingsRowData {
  const AdminSettingsRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
}

class AdminSettingsRow extends StatelessWidget {
  const AdminSettingsRow({super.key, required this.data});

  final AdminSettingsRowData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  data.icon,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        fontSize: 10.5,
                        height: 1.3,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (data.trailing != null)
                data.trailing!
              else
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
