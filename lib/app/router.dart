import 'package:flutter/material.dart';
import 'package:_3dmarket/core/data/asset_catalog.dart';
import 'package:_3dmarket/features/onboarding/presentation/onboarding_screen.dart';
import 'package:_3dmarket/features/auth/presentation/login_screen.dart';
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
  static const wishlist = '/wishlist';
  static const profile = '/profile';
  static const checkout = '/checkout';
  static const paymentStatus = '/payment-status';
  static const notifications = '/notifications';
  static const transactionHistory = '/transaction-history';
  static const transactionDetail = '/transaction-detail';
  static const admin = '/admin';
  static const adminCatalog = '/admin/catalog';
  static const adminUpload = '/admin/upload';
  static const adminEdit = '/admin/edit';
  static const adminOrders = '/admin/orders';
  static const adminOrderDetail = '/admin/order-detail';
  static const adminUsers = '/admin/users';
  static const adminBanners = '/admin/banners';
  static const adminCategories = '/admin/categories';

  static Route<dynamic> onGenerate(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
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
      transactionDetail: (_) => const TransactionDetailScreen(
        invoice: 'INV-2026-0142',
        title: 'Cybernetic Arm Rigged',
        total: 'Rp 149.000',
        status: 'Lunas',
      ),
      admin: (_) => const AdminDashboardScreen(),
    };
    final builder = routes[settings.name] ?? routes[onboarding]!;
    return MaterialPageRoute(builder: builder, settings: settings);
  }
}

