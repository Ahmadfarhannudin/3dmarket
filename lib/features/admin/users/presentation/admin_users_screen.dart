import 'package:flutter/material.dart';

import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Ringkasan pengguna & kreator studio admin.
class AdminUsersScreen {
  const AdminUsersScreen._();

  static void showSheet(BuildContext context) {
    showAdminInfoSheet(context, 'Pengguna & Kreator', [
      '1.420 akun aktif',
      '12 permohonan kreator baru',
      'Admin: 3',
    ]);
  }
}
