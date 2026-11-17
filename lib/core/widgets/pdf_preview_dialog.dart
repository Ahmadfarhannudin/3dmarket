import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:printing/printing.dart';

/// Menampilkan preview PDF di dialog dengan aksi unduh.
///
/// Dipakai bersama oleh sertifikat lisensi dan faktur agar tampilan serta
/// perilaku unduhan konsisten di seluruh aplikasi.
Future<void> showPdfPreview(
  BuildContext context, {
  required Uint8List pdfBytes,
  required String fileName,
  required String title,
  required VoidCallback onDownload,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => _PdfPreviewDialog(
      pdfBytes: pdfBytes,
      fileName: fileName,
      title: title,
      onDownload: onDownload,
    ),
  );
}

class _PdfPreviewDialog extends StatelessWidget {
  const _PdfPreviewDialog({
    required this.pdfBytes,
    required this.fileName,
    required this.title,
    required this.onDownload,
  });

  final Uint8List pdfBytes;
  final String fileName;
  final String title;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 760,
          maxHeight: size.height * 0.9,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined,
                      size: 20, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Noto Serif',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: 'Tutup',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Container(
                color: const Color(0xFFEEF1F6),
                padding: const EdgeInsets.all(12),
                child: PdfPreview(
                  build: (_) async => pdfBytes,
                  allowPrinting: false,
                  allowSharing: false,
                  useActions: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  pdfFileName: fileName,
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        foregroundColor: AppColors.onSurfaceVariant,
                        side: BorderSide(
                          color: AppColors.outline.withValues(alpha: 0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onDownload,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.download_outlined, size: 18),
                      label: const Text(
                        'Unduh PDF',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
