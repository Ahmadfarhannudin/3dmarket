import 'package:flutter/foundation.dart';

import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/features/admin/catalog/data/admin_catalog_repository.dart';
import 'package:_3dmarket/features/admin/orders/data/admin_orders_repository.dart';

/// Sumber data bersama untuk seluruh layar admin.
///
/// Menyimpan tab aktif, katalog aset, dan pesanan agar perubahan di satu tab
/// (mis. publikasi aset atau pelunasan pesanan) langsung tercermin di tab lain.
class AdminStore extends ChangeNotifier {
  AdminStore()
      : assets = [...demoAdminAssets],
        orders = [...demoAdminOrders] {
    PurchaseStore.instance.addListener(_syncPurchasesToOrders);
  }

  @override
  void dispose() {
    PurchaseStore.instance.removeListener(_syncPurchasesToOrders);
    super.dispose();
  }

  void _syncPurchasesToOrders() {
    final purchases = PurchaseStore.instance.items;
    if (purchases.isEmpty) return;

    // Ambil ID pesanan admin yang sudah ada agar tidak menduplikat.
    final existingIds = {for (final o in orders) o.id};
    final fresh = purchases
        .where((p) => !existingIds.contains(p.orderId))
        .toList();
    if (fresh.isEmpty) return;

    for (final p in fresh) {
      orders.add(AdminOrder(
        id: p.orderId,
        time: formatPurchaseDate(p.purchasedAt),
        title: p.title,
        payment: p.paymentMethod,
        amount: p.totalLabel,
        status: AdminOrderStatus.paid,
        note: 'Auto-Sync',
        assetFormat: p.format,
        creator: p.creator,
        sizeLabel: p.sizeLabel,
        description: p.description,
      ));
    }
    notifyListeners();
  }

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
