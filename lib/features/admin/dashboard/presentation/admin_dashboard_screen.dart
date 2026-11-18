import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/catalog/presentation/admin_catalog_screen.dart';
import 'package:_3dmarket/features/admin/dashboard/presentation/dashboard_tab.dart';
import 'package:_3dmarket/features/admin/orders/presentation/admin_orders_screen.dart';
import 'package:_3dmarket/features/admin/settings/presentation/admin_settings_screen.dart';
import 'package:_3dmarket/features/admin/shared/admin_store.dart';

/// Cangkang panel admin: header, empat tab menu, dan navigasi bawah.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, this.initialTab = 0});

  /// Tab yang dibuka sesuai URL: 0 dashboard, 1 katalog, 2 pesanan,
  /// 3 pengaturan.
  final int initialTab;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminStore _store = AdminStore.instance;

  static const _tabRoutes = [
    AppRouter.admin,
    AppRouter.adminCatalog,
    AppRouter.adminOrders,
    AppRouter.adminSettings,
  ];

  @override
  void initState() {
    super.initState();
    _store.tab = widget.initialTab;
  }

  @override
  void didUpdateWidget(covariant AdminDashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      _store.tab = widget.initialTab;
    }
  }

  void _openTab(int index) {
    _store.tab = index;
    final route = _tabRoutes[index.clamp(0, _tabRoutes.length - 1)];
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) => Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _AdminHeader(tab: _store.tab),
              Expanded(
                child: IndexedStack(
                  index: _store.tab,
                  children: [
                    DashboardTab(store: _store),
                    AdminCatalogScreen(store: _store),
                    AdminOrdersScreen(store: _store),
                    const AdminSettingsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _AdminNav(
          currentIndex: _store.tab,
          onTap: _openTab,
        ),
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({required this.tab});

  final int tab;

  static const _titles = ['Dashboard', 'Katalog', 'Pesanan', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '3DMARKET',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          fontVariations: [FontVariation('wght', 700)],
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'STUDIO ADMIN',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _titles[tab],
                  style: const TextStyle(
                    fontFamily: 'Noto Serif',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    height: 1.2,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRouter.notifications),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none,
                  size: 22,
                  color: AppColors.onSurfaceVariant,
                ),
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 17,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminNav extends StatelessWidget {
  const _AdminNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.dashboard, label: 'Dashboard'),
    (icon: Icons.inventory_2, label: 'Katalog'),
    (icon: Icons.shopping_bag, label: 'Pesanan'),
    (icon: Icons.settings, label: 'Pengaturan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _items[i].icon,
                          size: 22,
                          color: i == currentIndex
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].label,
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontVariations: [
                              FontVariation(
                                'wght',
                                i == currentIndex ? 600 : 400,
                              ),
                            ],
                            fontSize: 10,
                            letterSpacing: -0.1,
                            height: 1.1,
                            fontWeight: i == currentIndex
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: i == currentIndex
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
