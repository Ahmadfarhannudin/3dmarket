import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/features/auth/domain/auth_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('URL admin pengguna, kategori, banner', (tester) async {
    AuthSession.instance.signIn(
      role: UserRole.admin,
      email: 'admin@demo.com',
    );
    addTearDown(AuthSession.instance.signOut);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    for (final path in [
      '/admin/settings/users',
      '/admin/settings/categories',
      '/admin/settings/banners',
    ]) {
      router.go(path);
      await tester.pump(const Duration(milliseconds: 300));
      expect(router.routeInformationProvider.value.uri.path, path);
    }
  });
}
