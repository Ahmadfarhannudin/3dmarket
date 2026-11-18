import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';
import 'package:_3dmarket/features/admin/users/data/admin_users_repository.dart';

/// Direktori pengguna & kreator studio admin.
///
/// Mendukung pencarian, penyaringan per jenis akun, persetujuan calon kreator,
/// pemblokiran akun, pengaturan hak akses, pengiriman pesan, dan ekspor log
/// audit ke clipboard sebagai CSV.
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  static const _filters = [
    'Semua',
    'Kreator Terverifikasi',
    'Pembeli',
    'Calon Kreator',
    'Suspended',
  ];

  final _users = [...demoAdminUsers];
  final _search = TextEditingController();
  String _filter = 'Semua';
  String _sort = 'Nama A–Z';

  int get _applicants =>
      _users.where((u) => u.kind == AdminUserKind.applicant).length;

  List<AdminUser> get _visible {
    final query = _search.text.trim().toLowerCase();
    final items = _users.where((user) {
      final matchesFilter = switch (_filter) {
        'Kreator Terverifikasi' => user.kind == AdminUserKind.creator,
        'Pembeli' => user.kind == AdminUserKind.buyer,
        'Calon Kreator' => user.kind == AdminUserKind.applicant,
        'Suspended' => user.kind == AdminUserKind.suspended,
        _ => true,
      };
      if (!matchesFilter) return false;
      if (query.isEmpty) return true;
      return '${user.name} ${user.email} ${user.studio}'
          .toLowerCase()
          .contains(query);
    }).toList();

    switch (_sort) {
      case 'Nama Z–A':
        items.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Kreator Dulu':
        items.sort(
          (a, b) =>
              _kindWeight(a.kind).compareTo(_kindWeight(b.kind)),
        );
        break;
      case 'Terbaru':
        break;
      default:
        items.sort((a, b) => a.name.compareTo(b.name));
    }
    return items;
  }

  static int _kindWeight(AdminUserKind kind) => switch (kind) {
        AdminUserKind.creator => 0,
        AdminUserKind.admin => 1,
        AdminUserKind.applicant => 2,
        AdminUserKind.buyer => 3,
        AdminUserKind.suspended => 4,
      };

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return AdminPageScaffold(
      title: 'Kelola Pengguna',
      children: [
        const Row(
          children: [
            Icon(Icons.shield_outlined, size: 14, color: AppColors.tertiary),
            SizedBox(width: 6),
            Text(
              'DIREKTORI KURATORIAL',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontVariations: [FontVariation('wght', 700)],
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                color: AppColors.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Kelola Pengguna & Kreator',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontVariations: [FontVariation('wght', 700)],
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.15,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '1.420 akun terdaftar • '),
              TextSpan(
                text: '$_applicants permohonan baru',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          style: const TextStyle(fontSize: 11.5, color: AppColors.secondary),
        ),
        if (_applicants > 0) ...[
          const SizedBox(height: 14),
          _applicantBanner(),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AdminSearchField(
                hint: 'Cari nama kreator, email, atau ID studio...',
                controller: _search,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            _sortButton(),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final filter in _filters) ...[
                AdminFilterChip(
                  label: filter == 'Semua'
                      ? 'Semua ${_users.length}'
                      : filter == 'Kreator Terverifikasi'
                          ? 'Kreator Terverifikasi '
                              '${_users.where((u) => u.kind == AdminUserKind.creator).length}'
                          : filter == 'Pembeli'
                              ? 'Pembeli '
                                  '${_users.where((u) => u.kind == AdminUserKind.buyer).length}'
                              : filter == 'Calon Kreator'
                                  ? 'Calon Kreator $_applicants'
                                  : 'Suspended '
                                      '${_users.where((u) => u.kind == AdminUserKind.suspended).length}',
                  selected: _filter == filter,
                  onTap: () => setState(() => _filter = filter),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (items.isEmpty)
          const AdminEmptyState(
            icon: Icons.person_search_outlined,
            message: 'Tidak ada pengguna yang cocok dengan pencarian.',
          )
        else
          for (final user in items) ...[
            _userCard(user),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 6),
        _auditButton(),
      ],
    );
  }

  // ─── Bagian atas ──────────────────────────────────────────────────────

  Widget _applicantBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7DB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9D98A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E39B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  size: 21,
                  color: AppColors.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Pengajuan Kreator 3D',
                            style: TextStyle(
                              fontFamily: 'Noto Serif',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        AdminBadge(
                          label: '$_applicants Tertunda',
                          background: AppColors.tertiary,
                          foreground: AppColors.onTertiary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Menunggu verifikasi keabsahan portofolio & '
                      'mesh polycount.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.45,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: () => setState(() => _filter = 'Calon Kreator'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                foregroundColor: AppColors.onTertiary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Review Antrean',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortButton() {
    return PopupMenuButton<String>(
      initialValue: _sort,
      onSelected: (value) => setState(() => _sort = value),
      offset: const Offset(0, 44),
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => [
        for (final option in const [
          'Nama A–Z',
          'Nama Z–A',
          'Kreator Dulu',
          'Terbaru',
        ])
          PopupMenuItem(
            value: option,
            child: Text(
              option,
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
      ],
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.outline.withValues(alpha: 0.16),
          ),
        ),
        child: const Icon(
          Icons.tune,
          size: 18,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _auditButton() {
    return Material(
      color: AppColors.onSurface,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: _exportAudit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              const Icon(
                Icons.download_outlined,
                size: 17,
                color: AppColors.onPrimary,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Unduh Log Audit Pengguna (CSV)',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
              Text(
                '• ${_users.length} Records',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 10,
                  color: AppColors.onPrimary.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Kartu pengguna ───────────────────────────────────────────────────

  Widget _userCard(AdminUser user) {
    return switch (user.kind) {
      AdminUserKind.creator => _creatorCard(user),
      AdminUserKind.admin => _adminCard(user),
      AdminUserKind.buyer => _buyerCard(user),
      AdminUserKind.applicant => _applicantCard(user),
      AdminUserKind.suspended => _suspendedCard(user),
    };
  }

  Widget _cardShell({
    required Widget child,
    Color? border,
    Color background = AppColors.surfaceContainerLowest,
    double borderWidth = 1,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: border == null
            ? null
            : Border.all(color: border, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _avatar(AdminUser user, {double size = 46}) {
    final initials = user.name
        .replaceAll(RegExp(r'[^A-Za-z ]'), '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.15),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: user.avatarUrl.isEmpty
                ? Center(
                    child: Text(
                      initials.isEmpty ? '?' : initials,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  )
                : Image.network(
                    user.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Center(
                      child: Text(
                        initials.isEmpty ? '?' : initials,
                        style: const TextStyle(
                          fontFamily: 'Noto Serif',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
          ),
          if (user.kind == AdminUserKind.creator ||
              user.kind == AdminUserKind.admin)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: user.kind == AdminUserKind.admin
                      ? AppColors.tertiary
                      : AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surfaceContainerLowest,
                    width: 2,
                  ),
                ),
                child: Icon(
                  user.kind == AdminUserKind.admin
                      ? Icons.shield
                      : Icons.check,
                  size: 9,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          if (user.kind == AdminUserKind.suspended)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surfaceContainerLowest,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.block,
                  size: 9,
                  color: AppColors.onError,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _menu(AdminUser user) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        size: 18,
        color: AppColors.onSurfaceVariant,
      ),
      padding: EdgeInsets.zero,
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            _showProfile(user);
            break;
          case 'copy':
            Clipboard.setData(ClipboardData(text: user.email));
            adminSnack(context, 'Email ${user.email} disalin.');
            break;
          case 'block':
            _blokir(user);
            break;
          case 'unblock':
            _bukaBlokir(user);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'profile', child: Text('Lihat Profil')),
        const PopupMenuItem(value: 'copy', child: Text('Salin Email')),
        if (user.kind == AdminUserKind.suspended)
          const PopupMenuItem(value: 'unblock', child: Text('Buka Blokir'))
        else
          const PopupMenuItem(value: 'block', child: Text('Blokir Akun')),
      ],
    );
  }

  Widget _userIdentity(AdminUser user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _avatar(user),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: 'Noto Serif',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: user.kind == AdminUserKind.suspended
                          ? AppColors.onSurfaceVariant
                          : AppColors.onSurface,
                    ),
                  ),
                  if (user.role.isNotEmpty)
                    AdminBadge(
                      label: user.role,
                      background: _roleBackground(user.kind),
                      foreground: _roleForeground(user.kind),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
        _menu(user),
      ],
    );
  }

  Widget _creatorCard(AdminUser user) {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userIdentity(user),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _stat('MODEL DIUNGGAH', '${user.assets} Aset'),
                const SizedBox(width: 8),
                _stat('TOTAL OMZET', user.revenue, highlight: true),
                const SizedBox(width: 8),
                _stat('REPUTASI', '★ ${user.rating.toStringAsFixed(1)}'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Kreator Terverifikasi',
                  style: TextStyle(fontSize: 10.5, color: AppColors.secondary),
                ),
              ),
              TextButton(
                onPressed: () => _kelolaHak(user),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Kelola Hak',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () => _blokir(user),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Blokir',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _adminCard(AdminUser user) {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userIdentity(user),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.link,
                  size: 13,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    user.permission,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  user.lastActive,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buyerCard(AdminUser user) {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userIdentity(user),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${user.transactions} Transaksi Lisensi',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  user.joined,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _detailTransaksi(user),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceVariant,
                  backgroundColor: AppColors.surfaceContainerLow,
                  side: BorderSide(
                    color: AppColors.outline.withValues(alpha: 0.18),
                  ),
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                icon: const Icon(Icons.receipt_long_outlined, size: 13),
                label: const Text(
                  'Detail Transaksi',
                  style: TextStyle(fontSize: 10.5),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _kirimPesan(user),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  side: BorderSide(
                    color: AppColors.outline.withValues(alpha: 0.18),
                  ),
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                icon: const Icon(Icons.mail_outline, size: 13),
                label: const Text(
                  'Kirim Pesan',
                  style: TextStyle(fontSize: 10.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _applicantCard(AdminUser user) {
    return _cardShell(
      border: const Color(0xFFC7A64B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userIdentity(user),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KELAYAKAN PORTOFOLIO',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.verified_outlined,
                      size: 13,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.platform,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.view_in_ar_outlined,
                      size: 13,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.sample,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _setujui(user),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 15),
                  label: const Text(
                    'Setujui Kreator',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _tolak(user),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.onSurfaceVariant,
                    backgroundColor: AppColors.surfaceContainer,
                    side: BorderSide.none,
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Tolak',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _suspendedCard(AdminUser user) {
    return _cardShell(
      background: AppColors.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userIdentity(user),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 15,
                  color: AppColors.error,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    user.reason,
                    style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.45,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Dibekukan sejak ${user.blockedAt}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _bukaBlokir(user),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLowest,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  'Buka Blokir',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 8,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Noto Serif',
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: highlight ? AppColors.primary : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Color _roleBackground(AdminUserKind kind) => switch (kind) {
        AdminUserKind.creator => AppColors.surfaceContainerHigh,
        AdminUserKind.admin => AppColors.primaryContainer,
        AdminUserKind.applicant => const Color(0xFFF9E37A),
        AdminUserKind.suspended => AppColors.errorContainer,
        AdminUserKind.buyer => AppColors.surfaceContainerHigh,
      };

  Color _roleForeground(AdminUserKind kind) => switch (kind) {
        AdminUserKind.creator => AppColors.onSurfaceVariant,
        AdminUserKind.admin => AppColors.primary,
        AdminUserKind.applicant => AppColors.onTertiaryFixed,
        AdminUserKind.suspended => AppColors.onErrorContainer,
        AdminUserKind.buyer => AppColors.onSurfaceVariant,
      };

  // ─── Aksi ─────────────────────────────────────────────────────────────

  Future<void> _blokir(AdminUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Blokir akun?'),
        content: Text(
          '${user.name} tidak akan bisa mengunggah aset atau membeli lisensi '
          'sampai blokir dibuka kembali.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Blokir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      user.kind = AdminUserKind.suspended;
      user.role = 'Suspended';
      user.reason = 'Diblokir manual oleh kurator studio.';
      user.blockedAt = _today();
    });
    adminSnack(context, 'Akun ${user.name} diblokir.');
  }

  Future<void> _bukaBlokir(AdminUser user) async {
    setState(() {
      user.kind = AdminUserKind.buyer;
      user.role = 'Pembeli';
      user.reason = '';
      user.blockedAt = '';
    });
    adminSnack(context, 'Blokir ${user.name} dibuka.');
  }

  Future<void> _setujui(AdminUser user) async {
    setState(() {
      user.kind = AdminUserKind.creator;
      user.role = 'Kreator Terverifikasi';
      user.assets = 0;
      user.revenue = 'Rp 0';
      user.rating = 0;
    });
    adminSnack(context, '${user.name} kini kreator terverifikasi.');
  }

  Future<void> _tolak(AdminUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tolak pengajuan?'),
        content: Text(
          '${user.name} akan tetap menjadi pembeli dan menerima notifikasi '
          'penolakan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      user.kind = AdminUserKind.buyer;
      user.role = 'Pembeli';
    });
    adminSnack(context, 'Pengajuan ${user.name} ditolak.');
  }

  Future<void> _kelolaHak(AdminUser user) async {
    var upload = true;
    var publish = true;
    var withdraw = true;
    var reply = false;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelola Hak — ${user.name}',
                  style: const TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _permissionTile(
                  'Unggah Aset 3D',
                  upload,
                  (v) => setSheetState(() => upload = v),
                ),
                _permissionTile(
                  'Terbitkan ke Katalog',
                  publish,
                  (v) => setSheetState(() => publish = v),
                ),
                _permissionTile(
                  'Tarik Pendapatan',
                  withdraw,
                  (v) => setSheetState(() => withdraw = v),
                ),
                _permissionTile(
                  'Balas Pesan Pembeli',
                  reply,
                  (v) => setSheetState(() => reply = v),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Simpan Hak Akses',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (saved == true && mounted) {
      adminSnack(context, 'Hak akses ${user.name} diperbarui.');
    }
  }

  Widget _permissionTile(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: AppColors.onPrimary,
          activeTrackColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _detailTransaksi(AdminUser user) async {
    final orders = [
      ('Cyberpunk Arm (Standard)', '10 Nov 2026', 'Rp 91.000'),
      ('Tactical Exo Helmet', '04 Nov 2026', 'Rp 75.000'),
      ('Mech Vanguard-X', '28 Okt 2026', 'Rp 149.000'),
    ];
    await showModalBottomSheet<void>(
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
                'Transaksi — ${user.name}',
                style: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${user.transactions} transaksi lisensi tercatat.',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 12),
              for (final order in orders)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.$1,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              order.$2,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        order.$3,
                        style: const TextStyle(
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
        ),
      ),
    );
  }

  Future<void> _kirimPesan(AdminUser user) async {
    final controller = TextEditingController();
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Kirim pesan ke ${user.name}'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tulis pesan untuk pengguna...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
    final message = controller.text.trim();
    controller.dispose();
    if (sent != true || !mounted) return;
    adminSnack(
      context,
      message.isEmpty
          ? 'Pesan kosong dibatalkan.'
          : 'Pesan terkirim ke ${user.email}.',
    );
  }

  Future<void> _showProfile(AdminUser user) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _avatar(user, size: 52),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontFamily: 'Noto Serif',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AdminBadge(
                    label: user.role.isEmpty ? 'Pengguna' : user.role,
                    background: _roleBackground(user.kind),
                    foreground: _roleForeground(user.kind),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              adminSheetRow('Studio', user.studio.isEmpty ? '—' : user.studio),
              adminSheetRow('Bergabung', user.joined.isEmpty ? '—' : user.joined),
              adminSheetRow('Status', user.kind.name),
              if (user.kind == AdminUserKind.creator) ...[
                adminSheetRow('Aset', '${user.assets} model'),
                adminSheetRow('Omzet', user.revenue),
                adminSheetRow('Rating', '★ ${user.rating}'),
              ],
              if (user.kind == AdminUserKind.admin)
                adminSheetRow('Izin', user.permission),
              if (user.kind == AdminUserKind.suspended)
                adminSheetRow('Alasan', user.reason),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportAudit() async {
    final buffer = StringBuffer('nama,email,peran,status\n');
    for (final user in _users) {
      buffer.writeln(
        '"${user.name}","${user.email}","${user.role}","${user.kind.name}"',
      );
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!mounted) return;
    adminSnack(
      context,
      'Log audit ${_users.length} pengguna disalin ke clipboard (CSV).',
    );
  }

  String _today() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final now = DateTime.now();
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
