import 'package:flutter/material.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/features/admin/orders/data/admin_orders_repository.dart';
import 'package:_3dmarket/features/admin/orders/presentation/admin_order_detail_screen.dart';
import 'package:_3dmarket/features/admin/shared/admin_store.dart';
import 'package:_3dmarket/features/admin/shared/admin_widgets.dart';

/// Tab pesanan: daftar transaksi lisensi dan status pelunasannya.
class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key, required this.store});

  final AdminStore store;

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _orderQuery = '';
  String _orderFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => _body(),
    );
  }

  Widget _body() {
    final filtered = widget.store.orders.where((o) {
      final matchesQuery =
          o.title.toLowerCase().contains(_orderQuery.toLowerCase()) ||
          o.id.toLowerCase().contains(_orderQuery.toLowerCase());
      final matchesFilter = switch (_orderFilter) {
        'Lunas' => o.status == AdminOrderStatus.paid,
        'Pending' => o.status == AdminOrderStatus.pending,
        _ => true,
      };
      return matchesQuery && matchesFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        adminTabTitle('Kelola Pesanan', 'Distribusi lisensi', 'ORDER MANAGER'),
        const SizedBox(height: 12),
        AdminSearchField(
          hint: 'Cari ID atau nama aset...',
          onChanged: (v) => setState(() => _orderQuery = v),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final f in ['Semua', 'Lunas', 'Pending'])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AdminFilterChip(
                  label: f,
                  selected: _orderFilter == f,
                  onTap: () => setState(() => _orderFilter = f),
                ),
              ),
            const Spacer(),
            Text(
              '${filtered.length} transaksi',
              style: const TextStyle(fontSize: 10.5, color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const AdminEmptyState(
            icon: Icons.receipt_long,
            message: 'Belum ada pesanan pada filter ini.',
          ),
        for (final order in filtered) ...[
          AdminOrderRow(
            order: order,
            onTap: () => showAdminOrderSheet(
              context,
              order,
              onMarkPaid: () => widget.store.markOrderPaid(order),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class AdminOrderRow extends StatelessWidget {
  const AdminOrderRow({super.key, required this.order, this.onTap});

  final AdminOrder order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final paid = order.status == AdminOrderStatus.paid;

    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap?.call(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: paid
                      ? AppColors.primaryFixed
                      : AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  paid ? Icons.receipt_long : Icons.hourglass_empty,
                  size: 18,
                  color: paid ? AppColors.primary : AppColors.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            order.id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          order.time,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Noto Serif',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: paid
                                ? AppColors.primary.withValues(alpha: 0.10)
                                : AppColors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            paid ? 'Lunas' : 'Pending',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: paid
                                  ? AppColors.primary
                                  : AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            order.payment,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (paid) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryFixed.withValues(
                                alpha: 0.25,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              order.assetFormat,
                              style: const TextStyle(
                                fontFamily: 'Public Sans',
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: AppColors.tertiary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_right_rounded,
                            size: 12,
                            color: AppColors.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.creator,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 8.5,
                              color: AppColors.outline,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            order.sizeLabel,
                            style: const TextStyle(
                              fontSize: 8.5,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.amount,
                    style: const TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.note,
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      color: paid ? AppColors.tertiary : AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




}

