import 'package:flutter/foundation.dart';

import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/orders/data/admin_orders_repository.dart';

/// Sumber data bersama untuk seluruh layar admin.
///
/// Menyimpan tab aktif, katalog aset, dan pesanan agar perubahan di satu tab
/// (mis. publikasi aset atau pelunasan pesanan) langsung tercermin di tab lain.
class AdminStore extends ChangeNotifier {
  AdminStore()
      : assets = [...demoAdminAssets],
        orders = [...demoAdminOrders];

  final List<AdminAsset> assets;
  final List<AdminOrder> orders;

  int _tab = 0;

  int get tab => _tab;

  set tab(int value) {
    if (_tab == value) return;
    _tab = value;
    notifyListeners();
  }

  void addAsset(AdminAsset asset) {
    assets.insert(0, asset);
    notifyListeners();
  }

  void replaceAsset(AdminAsset previous, AdminAsset next) {
    final index = assets.indexOf(previous);
    if (index < 0) return;
    assets[index] = next;
    notifyListeners();
  }

  void removeAsset(AdminAsset asset) {
    assets.remove(asset);
    notifyListeners();
  }

  /// Dipakai saat properti aset diubah langsung (mis. toggle publikasi).
  void notifyAssetsChanged() => notifyListeners();

  void markOrderPaid(AdminOrder order) {
    order.status = AdminOrderStatus.paid;
    order.note = 'Auto-Sync';
    notifyListeners();
  }
}
