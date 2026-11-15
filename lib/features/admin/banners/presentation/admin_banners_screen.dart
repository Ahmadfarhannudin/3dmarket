import 'package:flutter/material.dart';

import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Ringkasan banner promosi yang tayang di katalog.
class AdminBannersScreen {
  const AdminBannersScreen._();

  static const banners = [
    'Diskon Rilis 40%',
    'Spotlight Kurator',
    'Bundle Sci-Fi',
  ];

  static void showSheet(BuildContext context) {
    showAdminInfoSheet(context, 'Banner & Promosi', banners);
  }
}
