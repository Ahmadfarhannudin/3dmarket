import 'dart:typed_data';

import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Generator sertifikat lisensi komersial dalam format PDF.
///
/// Menyediakan dua cara akses:
/// - [showPreview]: tampilkan preview PDF di dialog Flutter.
/// - [download]: unduh file PDF ke perangkat.
class LicensePdfGenerator {
  LicensePdfGenerator._();

  static const _brand = '_3D MARKET';
  static const _tagline = 'Premium 3D Asset Marketplace';

  // ─── Public API ───────────────────────────────────────────────────────

  /// Tampilkan preview PDF di dialog. Pengguna bisa menekan tombol unduh
  /// untuk menyimpan file ke perangkat.
  static Future<void> showPreview(BuildContext context, PurchaseRecord record) async {
    final pdfBytes = await generate(record);
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => _LicensePreviewDialog(pdfBytes: pdfBytes, record: record),
    );
  }

  /// Unduh PDF secara langsung (trigger browser download).
  static Future<void> download(PurchaseRecord record) async {
    final pdfBytes = await generate(record);
    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
  }

  // ─── PDF Generation ───────────────────────────────────────────────────

  /// Menghasilkan byte PDF dari [record].
  static Future<Uint8List> generate(PurchaseRecord record) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _header(),
              pw.SizedBox(height: 16),

              // Seal placeholder (circle badge)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 56,
                    height: 56,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      border: pw.Border.all(color: PdfColor.fromInt(0xFF1A6FBF), width: 2),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        'VERIFIED\nLICENSE',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 7,
                          color: PdfColor.fromInt(0xFF1A6FBF),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Title
              pw.Text(
                'SERTIFIKAT LISENSI KOMERSIAL',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 2,
                  color: PdfColor.fromInt(0xFF1A1A2E),
                ),
              ),
              pw.SizedBox(height: 12),

              // Section: Detail Aset
              _sectionLabel('DETAIL ASET'),
              _row('Judul Aset', record.title),
              _row('Kategori', record.category),
              _row('Format File', record.format.toUpperCase()),
              _row('Ukuran Berkas', record.sizeLabel),
              pw.SizedBox(height: 8),

              // Section: Informasi Transaksi
              _sectionLabel('INFORMASI TRANSAKSI'),
              _row('ID Pesanan', record.orderId),
              _row('Waktu Transaksi', record.purchasedAtLabel),
              _row('Metode Pembayaran', record.paymentMethod),
              _row('Total Dibayar', record.totalLabel),
              pw.SizedBox(height: 8),

              // License code box
              _licenseBox(record.licenseKey),
              pw.SizedBox(height: 8),

              // Description
              if (record.description.isNotEmpty) ...[
                _sectionLabel('DESKRIPSI ASET'),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    record.description,
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                ),
                pw.SizedBox(height: 8),
              ],

              pw.Spacer(),

              // Footer
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 6),
              pw.Text(
                'Sertifikat ini diterbitkan secara otomatis oleh sistem $_brand. '
                'Lisensi berlaku seumur hidup untuk satu proyek komersial utama. '
                'Simpan dokumen ini sebagai bukti kepemilikan.',
                style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Kode Lisensi: ${record.licenseKey} | Pesanan: ${record.orderId}',
                style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  static pw.Widget _header() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(
          _brand,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 4,
            color: PdfColor.fromInt(0xFF1A6FBF),
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.Text(
          _tagline,
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500, letterSpacing: 2),
          textAlign: pw.TextAlign.center,
        ),
        pw.Divider(color: PdfColor.fromInt(0xFF1A6FBF), thickness: 2),
      ],
    );
  }

  static pw.Widget _sectionLabel(String label) {
    return pw.Row(
      children: [
        pw.Container(width: 3, height: 12, color: PdfColor.fromInt(0xFF1A6FBF)),
        pw.SizedBox(width: 6),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(0xFF1A6FBF),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  static pw.Widget _row(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600)),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  static pw.Widget _licenseBox(String key) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 8),
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromInt(0xFF1A6FBF), width: 2),
        borderRadius: pw.BorderRadius.circular(6),
        color: PdfColor.fromInt(0xFFF0F5FF),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            key,
            style: pw.TextStyle(
              fontSize: 17,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFF1A6FBF),
              letterSpacing: 1.5,
            ),
          ),
          pw.Text(
            'PERPETUAL COMMERCIAL LICENSE KEY',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

// ─── Preview Dialog ────────────────────────────────────────────────────

class _LicensePreviewDialog extends StatelessWidget {
  const _LicensePreviewDialog({required this.pdfBytes, required this.record});

  final Uint8List pdfBytes;
  final PurchaseRecord record;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Sertifikat Lisensi Komersial',
        style: TextStyle(fontFamily: 'Noto Serif', fontWeight: FontWeight.w700),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: [
            Expanded(
              child: PdfPreview(
                build: (_) async => pdfBytes,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Tutup'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await LicensePdfGenerator.download(record);
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text('Unduh PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A6FBF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: const [],
    );
  }
}

// ─── License Key Utility ────────────────────────────────────────────────

/// Mengekstrak atau menghasilkan kode lisensi berdasarkan ID pesanan.
/// Format: ORD-YYYYMMDD-XXXX -> PLY-COMM-YYYY-XXXX
String extractLicenseKey(String orderId) {
  final match = RegExp(r'ORD-(\d{8})-(\d+)').firstMatch(orderId);
  if (match != null) {
    return 'PLY-COMM-${match.group(1)!}-${match.group(2)!}';
  }
  return 'PLY-COMM-00000000-0000';
}
