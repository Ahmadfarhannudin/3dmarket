import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/features/onboarding/presentation/onboarding_screen.dart';
import 'package:_3dmarket/features/auth/presentation/login_screen.dart';
import 'package:_3dmarket/features/auth/domain/auth_session.dart';
import 'package:_3dmarket/features/auth/presentation/register_screen.dart';
import 'package:_3dmarket/features/auth/presentation/forgot_password_screen.dart';
import 'package:_3dmarket/features/main/presentation/main_screen.dart';
import 'package:_3dmarket/features/home/presentation/home_screen.dart';
import 'package:_3dmarket/features/explore/presentation/explore_screen.dart';
import 'package:_3dmarket/features/asset_detail/presentation/asset_detail_screen.dart';
import 'package:_3dmarket/features/my_assets/presentation/my_assets_screen.dart';
import 'package:_3dmarket/features/wishlist/presentation/wishlist_screen.dart';
import 'package:_3dmarket/features/profile/presentation/profile_screen.dart';
import 'package:_3dmarket/features/checkout/presentation/checkout_screen.dart';
import 'package:_3dmarket/features/checkout/presentation/payment_status_screen.dart';
import 'package:_3dmarket/features/notifications/presentation/notifications_screen.dart';
import 'package:_3dmarket/features/profile/presentation/transaction_history_screen.dart';
import 'package:_3dmarket/features/profile/presentation/transaction_detail_screen.dart';
import 'package:_3dmarket/features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import 'package:_3dmarket/features/admin/users/presentation/admin_users_screen.dart';
import 'package:_3dmarket/features/admin/categories/presentation/admin_categories_screen.dart';
import 'package:_3dmarket/features/admin/banners/presentation/admin_banners_screen.dart';
import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/catalog/presentation/upload_asset_screen.dart';

/// ========================================
/// 路由常量（保持与原 AppRouter 一致）
/// ========================================
class AppRouter {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgot = '/forgot';
  static const main = '/main';
  static const home = '/home';
  static const explore = '/explore';
  static const detail = '/detail';
  static const myAssets = '/my-assets';
  static const profile = '/profile';
  static const profileWishlist = '/profile/wishlist';
  static const profileTransactionHistory = '/profile/riwayat-transaksi';
  static const wishlist = profileWishlist;
  static const checkout = '/checkout';
  static const paymentStatus = '/payment-status';
  static const notifications = '/notifications';
  static const transactionHistory = profileTransactionHistory;
  static const transactionDetail = '/transaction-detail';
  static const legacyWishlist = '/wishlist';
  static const legacyTransactionHistory = '/transaction-history';
  static const admin = '/admin';
  static const adminCatalog = '/admin/catalog';
  static const adminUpload = '/admin/catalog/upload';
  static const adminEdit = '/admin/catalog/edit';
  static const adminOrders = '/admin/orders';
  static const adminOrderDetail = '/admin/order-detail';
  static const adminUsers = '/admin/settings/users';
  static const adminBanners = '/admin/settings/banners';
  static const adminCategories = '/admin/settings/categories';
  static const adminSettings = '/admin/settings';

  /// 兼容原 onGenerate，供需要时调用
  static Route<dynamic> onGenerate(RouteSettings settings) {
    final builders = <String, WidgetBuilder>{
      onboarding: (_) => const OnboardingScreen(),
      login: (_) => const LoginScreen(),
      register: (_) => const RegisterScreen(),
      forgot: (_) => const ForgotPasswordScreen(),
      main: (_) => MainScreen(
        initialIndex: settings.arguments is int ? settings.arguments as int : 0,
      ),
      home: (_) => const HomeScreen(),
      explore: (_) => const ExploreScreen(),
      detail: (_) => AssetDetailScreen(
        asset: settings.arguments is CatalogAsset
            ? settings.arguments as CatalogAsset
            : null,
      ),
      myAssets: (_) => const MyAssetsScreen(),
      wishlist: (_) => const WishlistScreen(),
      profile: (_) => const ProfileScreen(),
      checkout: (_) => CheckoutScreen(
        asset: settings.arguments is CatalogAsset
            ? settings.arguments as CatalogAsset
            : null,
      ),
      paymentStatus: (_) => const PaymentStatusScreen(),
      notifications: (_) => const NotificationsScreen(),
      transactionHistory: (_) => const TransactionHistoryScreen(),
      transactionDetail: (_) => TransactionDetailScreen(
        record: PurchaseStore.instance.latest ?? _defaultRecord(),
      ),
      admin: (_) => const AdminDashboardScreen(),
      adminCatalog: (_) => const AdminDashboardScreen(initialTab: 1),
      adminOrders: (_) => const AdminDashboardScreen(initialTab: 2),
      adminSettings: (_) => const AdminDashboardScreen(initialTab: 3),
      adminUpload: (_) => const UploadAssetScreen(),
      adminUsers: (_) => const AdminUsersScreen(),
      adminCategories: (_) => const AdminCategoriesScreen(),
      adminBanners: (_) => const AdminBannersScreen(),
    };
    final builder = builders[settings.name] ?? builders[onboarding]!;
    return MaterialPageRoute(builder: builder, settings: settings);
  }

  static PurchaseRecord _defaultRecord() => PurchaseRecord(
    orderId: 'ORD-20261110-8921',
    licenseKey: 'PLY-COMM-8921-X9',
    title: 'Cybernetic Arm Rigged',
    category: 'Characters',
    format: '.glb',
    sizeLabel: '48 MB',
    creator: 'Studio 3DMarket',
    description: '',
    modelUrl: '',
    itemPrice: 89000,
    serviceFee: 2000,
    total: 91000,
    paymentMethod: 'QRIS Instant',
    purchasedAt: DateTime.now(),
  );
}

/// ========================================
/// GoRouter 实例（平铺式，不使用 ShellRoute）
/// 原因：MainTab.open() 依赖 popUntil(isFirst) 回到 /main，
///       ShellRoute 会让 isFirst 变成 shell 本身而非主屏，导致行为不一致。
/// ========================================
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: AppRouter.onboarding,
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  redirect: (context, state) {
    final location = state.matchedLocation;
    final session = AuthSession.instance;
    final isAdminArea =
        location == AppRouter.admin ||
        location.startsWith('${AppRouter.admin}/');

    // Halaman admin hanya boleh dibuka oleh sesi admin yang lolos login.
    if (isAdminArea) {
      if (!session.isLoggedIn) return AppRouter.login;
      if (!session.isAdmin) return AppRouter.main;
    }

    // Sudah punya sesi: jangan kembali ke layar onboarding/login.
    if (location == AppRouter.login && session.isAdmin) {
      return AppRouter.admin;
    }
    if (location == AppRouter.onboarding && session.isLoggedIn) {
      return session.isAdmin ? AppRouter.admin : AppRouter.main;
    }

    return null;
  },
  routes: [
    // ── 认证流程 ──────────────────────────────────────────────
    GoRoute(
      path: AppRouter.onboarding,
      name: AppRouter.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRouter.login,
      name: AppRouter.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRouter.register,
      name: AppRouter.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRouter.forgot,
      name: AppRouter.forgot,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // ── ShellRoute for Bottom Navigation sync with URL ──
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // Map current location back to index for MainScreen
        int index = 0;
        final loc = state.matchedLocation;
        if (loc == AppRouter.explore) index = 1;
        if (loc == AppRouter.myAssets) index = 2;
        if (loc == AppRouter.profile ||
            loc.startsWith('${AppRouter.profile}/')) {
          index = 3;
        }

        return MainScreen(initialIndex: index, child: child);
      },
      routes: [
        GoRoute(
          path: AppRouter.main,
          name: AppRouter.main,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRouter.explore,
          name: AppRouter.explore,
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: AppRouter.myAssets,
          name: AppRouter.myAssets,
          builder: (context, state) => const MyAssetsScreen(),
        ),
        GoRoute(
          path: AppRouter.profile,
          name: AppRouter.profile,
          builder: (context, state) => const ProfileScreen(),
          routes: [
            // Child route: push dari shell tidak mengubah URL browser.
            // go() ke child inilah yang menulis /profile/wishlist dan
            // /profile/riwayat-transaksi di address bar.
            GoRoute(
              path: 'wishlist',
              name: AppRouter.profileWishlist,
              builder: (context, state) => const WishlistScreen(),
            ),
            GoRoute(
              path: 'riwayat-transaksi',
              name: AppRouter.profileTransactionHistory,
              builder: (context, state) => const TransactionHistoryScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Detail & Other Pages ──
    GoRoute(
      path: AppRouter.legacyWishlist,
      redirect: (context, state) => AppRouter.wishlist,
    ),
    GoRoute(
      path: AppRouter.legacyTransactionHistory,
      redirect: (context, state) => AppRouter.transactionHistory,
    ),
    GoRoute(
      path: AppRouter.detail,
      name: AppRouter.detail,
      builder: (context, state) {
        final asset = state.extra as CatalogAsset?;
        return AssetDetailScreen(asset: asset);
      },
    ),
    GoRoute(
      path: AppRouter.checkout,
      name: AppRouter.checkout,
      builder: (context, state) {
        final asset = state.extra as CatalogAsset?;
        return CheckoutScreen(asset: asset);
      },
    ),
    GoRoute(
      path: AppRouter.paymentStatus,
      name: AppRouter.paymentStatus,
      builder: (context, state) => const PaymentStatusScreen(),
    ),
    GoRoute(
      path: AppRouter.notifications,
      name: AppRouter.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRouter.transactionDetail,
      name: AppRouter.transactionDetail,
      builder: (context, state) {
        final record = state.extra as PurchaseRecord?;
        return TransactionDetailScreen(
          record: record ?? AppRouter._defaultRecord(),
        );
      },
    ),

    // ── Halaman admin dengan URL masing-masing ──
    GoRoute(
      path: AppRouter.admin,
      name: AppRouter.admin,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: AppRouter.adminCatalog,
      name: AppRouter.adminCatalog,
      builder: (context, state) => const AdminDashboardScreen(initialTab: 1),
    ),
    GoRoute(
      path: AppRouter.adminOrders,
      name: AppRouter.adminOrders,
      builder: (context, state) => const AdminDashboardScreen(initialTab: 2),
    ),
    GoRoute(
      path: AppRouter.adminSettings,
      name: AppRouter.adminSettings,
      builder: (context, state) => const AdminDashboardScreen(initialTab: 3),
    ),
    GoRoute(
      path: AppRouter.adminUsers,
      name: AppRouter.adminUsers,
      builder: (context, state) => const AdminUsersScreen(),
    ),
    GoRoute(
      path: AppRouter.adminCategories,
      name: AppRouter.adminCategories,
      builder: (context, state) => const AdminCategoriesScreen(),
    ),
    GoRoute(
      path: AppRouter.adminBanners,
      name: AppRouter.adminBanners,
      builder: (context, state) => const AdminBannersScreen(),
    ),
    GoRoute(
      path: AppRouter.adminUpload,
      name: AppRouter.adminUpload,
      builder: (context, state) => const UploadAssetScreen(),
    ),
    GoRoute(
      path: AppRouter.adminEdit,
      name: AppRouter.adminEdit,
      builder: (context, state) {
        final asset = state.extra as AdminAsset?;
        return UploadAssetScreen(asset: asset);
      },
    ),
  ],
);
