import 'dart:typed_data';

import 'package:_3dmarket/core/constants/buyer_profile.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/core/widgets/pdf_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Generator sertifikat lisensi komersial dalam format PDF.
///
/// Isi dokumen hanya menyangkut lisensi: para pihak, aset yang dilisensikan,
/// ruang lingkup hak, pembatasan, jangka waktu, dan kode lisensi. Rincian
/// transaksi keuangan berada pada faktur.
class LicensePdfGenerator {
  LicensePdfGenerator._();

  static const _brand = '_3D MARKET';
  static const _tagline = 'Premium 3D Asset Marketplace';
  static const _licensorEmail = 'license@3dmarket.id';

  // ─── Public API ───────────────────────────────────────────────────────

  /// Tampilkan preview PDF di dialog. Pengguna bisa menekan tombol unduh
  /// untuk menyimpan file ke perangkat.
  static Future<void> showPreview(
    BuildContext context,
    PurchaseRecord record,
  ) async {
    final pdfBytes = await generate(record);
    if (!context.mounted) return;

    await showPdfPreview(
      context,
      pdfBytes: pdfBytes,
      fileName: 'lisensi_${record.licenseKey}.pdf',
      title: 'Sertifikat Lisensi Komersial',
      onDownload: () {
        Navigator.of(context, rootNavigator: true).pop();
        download(record);
      },
    );
  }

  /// Unduh PDF secara langsung (trigger browser download).
  static Future<void> download(PurchaseRecord record) async {
    final pdfBytes = await generate(record);
    await Printing.layoutPdf(
      name: 'lisensi_${record.licenseKey}',
      onLayout: (_) async => pdfBytes,
    );
  }

  // ─── PDF Generation ───────────────────────────────────────────────────

  static Future<Uint8List> generate(PurchaseRecord record) async {
    final pdf = pw.Document();
    final primary = PdfColor.fromInt(0xFF094CB2);
    final dark = PdfColor.fromInt(0xFF1B1C1D);
    final muted = PdfColors.grey600;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.symmetric(
          vertical: 16 * PdfPageFormat.mm,
          horizontal: 16 * PdfPageFormat.mm,
        ),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Kop ──────────────────────────────────────────────────
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text(
                    _brand,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 4,
                      color: primary,
                    ),
                  ),
                  pw.Text(
                    _tagline,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 8.5,
                      letterSpacing: 2,
                      color: muted,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Divider(color: primary, thickness: 2),
                ],
              ),
              pw.SizedBox(height: 14),

              // ── Judul ────────────────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'SERTIFIKAT LISENSI KOMERSIAL',
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 1.6,
                            color: dark,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Commercial License Certificate · Perpetual, Non-Exclusive',
                          style: pw.TextStyle(fontSize: 8.5, color: muted),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  _seal(primary),
                ],
              ),
              pw.SizedBox(height: 12),

              // ── Kode lisensi ─────────────────────────────────────────
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: primary, width: 1.5),
                  borderRadius: pw.BorderRadius.circular(6),
                  color: PdfColor.fromInt(0xFFF3F6FD),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      record.licenseKey,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2.5,
                        color: primary,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'KODE LISENSI RESMI · PERPETUAL COMMERCIAL USE',
                      style: pw.TextStyle(
                        fontSize: 7.5,
                        letterSpacing: 1,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),

              // ── Para pihak ───────────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _partyBlock(
                      'LISENSOR (PEMBERI LISENSI)',
                      [
                        ('Kreator: ${record.creator}', true),
                        ('Diterbitkan oleh $_brand', false),
                        (_licensorEmail, false),
                        ('Pemegang hak cipta aset 3D', false),
                      ],
                      primary,
                      muted,
                    ),
                  ),
                  pw.SizedBox(width: 14),
                  pw.Expanded(
                    child: _partyBlock(
                      'PENERIMA LISENSI (LICENSEE)',
                      [
                        (BuyerProfile.name, true),
                        (BuyerProfile.email, false),
                        (BuyerProfile.address, false),
                        (BuyerProfile.taxId, false),
                      ],
                      primary,
                      muted,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 14),

              // ── Aset yang dilisensikan ───────────────────────────────
              _sectionLabel('ASET YANG DILISENSIKAN', primary),
              pw.SizedBox(height: 5),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  children: [
                    _kvRow('Judul Aset', record.title, muted),
                    _kvRow('Kategori', record.category, muted),
                    _kvRow('Format Berkas', record.format.toUpperCase(), muted),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // ── Ketentuan lisensi ────────────────────────────────────
              _sectionLabel('KETENTUAN LISENSI', primary),
              pw.SizedBox(height: 5),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  children: [
                    _kvRow('Jenis Lisensi', 'Komersial (Commercial)', muted),
                    _kvRow(
                      'Sifat Lisensi',
                      'Non-eksklusif, tidak dapat dipindahtangankan',
                      muted,
                    ),
                    _kvRow('Wilayah', 'Seluruh dunia (worldwide)', muted),
                    _kvRow('Jangka Waktu', 'Perpetual (seumur hidup)', muted),
                    _kvRow('Royalti', 'Tanpa royalti tambahan', muted),
                    _kvRow(
                      'Referensi Penerbitan',
                      record.orderId,
                      muted,
                    ),
                    _kvRow(
                      'Tanggal Terbit',
                      _dateOnly(record.purchasedAt),
                      muted,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // ── Hak & pembatasan ─────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('HAK YANG DIBERIKAN', primary),
                        pw.SizedBox(height: 5),
                        for (final item in _permittedUses)
                          _bullet(item, primary, muted),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 14),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('PEMBATASAN', primary),
                        pw.SizedBox(height: 5),
                        for (final item in _restrictions)
                          _bullet(item, PdfColor.fromInt(0xFFB3261E), muted),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // ── Pengesahan ───────────────────────────────────────────
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'Sertifikat ini merupakan bukti sah pemberian lisensi dan '
                      'diterbitkan secara elektronik. Hak cipta atas aset tetap '
                      'berada pada lisensor; transaksi ini tidak mengalihkan '
                      'kepemilikan hak cipta.',
                      style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Diterbitkan ${_dateOnly(record.purchasedAt)}',
                        style: pw.TextStyle(fontSize: 8.5, color: muted),
                      ),
                      pw.SizedBox(height: 26),
                      pw.Container(
                        width: 130,
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: PdfColors.grey500),
                          ),
                        ),
                        padding: const pw.EdgeInsets.only(top: 3),
                        child: pw.Column(
                          children: [
                            pw.Text(
                              record.creator,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 8.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'Lisensor · $_brand',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(fontSize: 7.5, color: muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 4),
              pw.Text(
                'Verifikasi keaslian: ${record.licenseKey} · $_licensorEmail',
                style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey500),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ─── Konten lisensi ───────────────────────────────────────────────────

  static const _permittedUses = [
    'Menggunakan aset untuk proyek komersial milik penerima lisensi.',
    'Memodifikasi, menganimasikan, dan mengintegrasikan aset ke karya turunan.',
    'Menampilkan hasil karya pada media promosi, game, film, dan produk digital.',
    'Menyimpan salinan arsip untuk kebutuhan cadangan proyek.',
  ];

  static const _restrictions = [
    'Menjual, membagikan ulang, atau mendistribusikan berkas aset mentah.',
    'Memberikan lisensi ulang (sublicense) kepada pihak ketiga.',
    'Mengklaim hak cipta atau mendaftarkan aset sebagai merek dagang.',
    'Mengunggah aset ke platform berbagi berkas atau bundel gratis.',
  ];

  // ─── Helpers ──────────────────────────────────────────────────────────

  static pw.Widget _seal(PdfColor primary) {
    return pw.Container(
      width: 58,
      height: 58,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        border: pw.Border.all(color: primary, width: 2),
      ),
      child: pw.Center(
        child: pw.Text(
          'VERIFIED\nLICENSE',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 7,
            color: primary,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static pw.Widget _partyBlock(
    String label,
    List<(String, bool)> lines,
    PdfColor primary,
    PdfColor muted,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 7.5,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1,
            color: primary,
          ),
        ),
        pw.SizedBox(height: 4),
        for (final (text, bold) in lines)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 1.5),
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: bold ? 9.5 : 8.5,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: bold ? PdfColors.black : muted,
              ),
            ),
          ),
      ],
    );
  }

  static pw.Widget _sectionLabel(String label, PdfColor primary) {
    return pw.Row(
      children: [
        pw.Container(width: 3, height: 11, color: primary),
        pw.SizedBox(width: 6),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8.5,
            fontWeight: pw.FontWeight.bold,
            color: primary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  static pw.Widget _kvRow(String label, String value, PdfColor muted) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 130,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 9, color: muted),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _bullet(String text, PdfColor color, PdfColor muted) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '•',
            style: pw.TextStyle(fontSize: 9, color: color),
          ),
          pw.SizedBox(width: 5),
          pw.Expanded(
            child: pw.Text(
              text,
              style: pw.TextStyle(fontSize: 8.5, color: muted, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  static String _dateOnly(DateTime time) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${time.day} ${months[time.month - 1]} ${time.year}';
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
