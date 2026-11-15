import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String invoice;
  final String title;
  final String total;
  final String status;

  const TransactionDetailScreen({
    super.key,
    required this.invoice,
    required this.title,
    required this.total,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Faktur Lisensi',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 28),
                const _Row('Lisensi', 'Standard Commercial'),
                const _Row('Format', '.blend • Blender 4.2'),
                const _Row('Metode', 'QRIS'),
                _Row('Total', total),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lisensi perpetual berlaku untuk proyek komersial tanpa royalti tambahan. Redistribusi file mentah dilarang.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
