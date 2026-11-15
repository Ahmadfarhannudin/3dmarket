import 'package:flutter/material.dart';

import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Ringkasan kategori & taksonomi katalog studio admin.
class AdminCategoriesScreen {
  const AdminCategoriesScreen._();

  static const categories = [
    'Karakter',
    'Arsitektur',
    'Kendaraan',
    'Sci-Fi',
    'Props',
    'Lingkungan',
    'Weapon',
    'Material',
  ];

  static void showSheet(BuildContext context) {
    showAdminInfoSheet(context, 'Kategori & Taksonomi', categories);
  }
}
