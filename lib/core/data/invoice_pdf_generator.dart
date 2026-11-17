import 'dart:typed_data';

import 'package:_3dmarket/core/constants/buyer_profile.dart';
import 'package:_3dmarket/core/data/purchase_store.dart';
import 'package:_3dmarket/core/widgets/pdf_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Generator faktur (invoice) pembelian aset 3D dalam format PDF.
///
/// Dokumen ini murni bukti transaksi komersial: identitas penjual dan pembeli,
/// nomor & tanggal faktur, rincian barang, perhitungan nilai, serta status
/// pembayaran. Urusan hak pakai aset sengaja dipisah ke sertifikat lisensi.
class InvoicePdfGenerator {
  InvoicePdfGenerator._();

  // Identitas penjual (penerbit faktur).
  static const _sellerName = '_3D MARKET';
  static const _sellerTagline = 'Premium 3D Asset Marketplace';
  static const _sellerAddress = 'Jl. Digital Kreatif No. 21, Bandung 40115, Indonesia';
  static const _sellerEmail = 'billing@3dmarket.id';
  static const _sellerPhone = '+62 22 8730 1122';
  static const _sellerTaxId = 'NPWP 01.234.567.8-405.000';

  // ─── Public API ───────────────────────────────────────────────────────

  /// Tampilkan preview faktur di dialog. Tombol unduh pada dialog akan
  /// menyimpan PDF ke perangkat.
  static Future<void> showPreview(
    BuildContext context,
    PurchaseRecord record,
  ) async {
    final pdfBytes = await generate(record);
    if (!context.mounted) return;

    await showPdfPreview(
      context,
      pdfBytes: pdfBytes,
      fileName: '${fileNameFor(record.orderId)}.pdf',
      title: 'Faktur Pembelian',
      onDownload: () {
        Navigator.of(context, rootNavigator: true).pop();
        download(record);
      },
    );
  }

  /// Unduh faktur langsung tanpa preview.
  static Future<void> download(PurchaseRecord record) async {
    final pdfBytes = await generate(record);
    await Printing.layoutPdf(
      name: fileNameFor(record.orderId),
      onLayout: (_) async => pdfBytes,
    );
  }

  /// Nomor faktur: `ORD-20261117-12345` menjadi `INV-20261117-12345`.
  static String invoiceNumber(String orderId) {
    final trimmed = orderId.replaceFirst(RegExp(r'^#'), '');
    final stripped =
        trimmed.replaceFirst(RegExp(r'^ORD-', caseSensitive: false), '');
    return 'INV-$stripped';
  }

  static String fileNameFor(String orderId) => 'faktur_${invoiceNumber(orderId)}';

  // ─── PDF Generation ───────────────────────────────────────────────────

  static Future<Uint8List> generate(PurchaseRecord record) async {
    final pdf = pw.Document();
    final primary = PdfColor.fromInt(0xFF094CB2);
    final dark = PdfColor.fromInt(0xFF1B1C1D);
    final muted = PdfColors.grey600;

    final invoiceNo = invoiceNumber(record.orderId);
    final tax = 0;
    final subtotal = record.itemPrice;
    final serviceFee = record.serviceFee;
    final total = record.total;

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
              // ── Kop: identitas penjual + judul dokumen ────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          _sellerName,
                          style: pw.TextStyle(
                            fontSize: 19,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 3,
                            color: primary,
                          ),
                        ),
                        pw.Text(
                          _sellerTagline,
                          style: pw.TextStyle(
                            fontSize: 8,
                            letterSpacing: 1.8,
                            color: muted,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          _sellerAddress,
                          style: pw.TextStyle(fontSize: 8, color: muted),
                        ),
                        pw.Text(
                          'Email: $_sellerEmail · Telp: $_sellerPhone',
                          style: pw.TextStyle(fontSize: 8, color: muted),
                        ),
                        pw.Text(
                          '$_sellerTaxId · Terdaftar sebagai PKP',
                          style: pw.TextStyle(fontSize: 8, color: muted),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'FAKTUR',
                        style: pw.TextStyle(
                          fontSize: 26,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 4,
                          color: dark,
                        ),
                      ),
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 9,
                          letterSpacing: 3,
                          color: muted,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      _statusBadge('LUNAS'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: primary, thickness: 2),
              pw.SizedBox(height: 12),

              // ── Blok informasi faktur ─────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: _infoBlock(
                      'DITAGIHKAN KEPADA',
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
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    flex: 4,
                    child: _infoBlock(
                      'INFORMASI FAKTUR',
                      [
                        (invoiceNo, true),
                        ('Tanggal Terbit: ${_dateOnly(record.purchasedAt)}', false),
                        ('Tanggal Lunas: ${_dateOnly(record.purchasedAt)}', false),
                        ('Ref. Pesanan: ${record.orderId}', false),
                      ],
                      primary,
                      muted,
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    flex: 4,
                    child: _infoBlock(
                      'PEMBAYARAN',
                      [
                        (record.paymentMethod, true),
                        ('Status: LUNAS', false),
                        ('Dibayar: ${_dateOnly(record.purchasedAt)}', false),
                      ],
                      primary,
                      muted,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // ── Tabel rincian barang ──────────────────────────────────
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: pw.BoxDecoration(
                        color: primary,
                        borderRadius: const pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(3),
                          topRight: pw.Radius.circular(3),
                        ),
                      ),
                      child: pw.Row(
                        children: [
                          pw.SizedBox(
                            width: 22,
                            child: _th('NO'),
                          ),
                          pw.Expanded(
                            flex: 5,
                            child: _th('DESKRIPSI BARANG'),
                          ),
                          pw.SizedBox(
                            width: 34,
                            child: _th('QTY', align: pw.TextAlign.center),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: _th('HARGA SATUAN', align: pw.TextAlign.right),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: _th('JUMLAH', align: pw.TextAlign.right),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 22,
                            child: pw.Text(
                              '1',
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Expanded(
                            flex: 5,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  record.title,
                                  style: pw.TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: pw.FontWeight.bold,
                                    color: dark,
                                  ),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  'Aset 3D digital · ${record.category}',
                                  style: pw.TextStyle(fontSize: 8.5, color: muted),
                                ),
                                pw.Text(
                                  'Format ${record.format.toUpperCase()} · '
                                  '${record.sizeLabel} · Lisensi komersial',
                                  style: pw.TextStyle(fontSize: 8.5, color: muted),
                                ),
                                pw.Text(
                                  'Kreator: ${record.creator}',
                                  style: pw.TextStyle(fontSize: 8.5, color: muted),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            width: 34,
                            child: pw.Text(
                              '1',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              formatRupiah(record.itemPrice),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              formatRupiah(record.itemPrice),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // ── Perhitungan nilai ─────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFF5F7FB),
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'TERBILANG',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1,
                              color: primary,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            _capitalize(terbilangRupiah(total)),
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontStyle: pw.FontStyle.italic,
                              color: dark,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'CATATAN',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1,
                              color: primary,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Pembayaran telah diterima penuh. Faktur ini '
                            'merupakan bukti transaksi komersial yang sah dan '
                            'diterbitkan secara elektronik tanpa tanda tangan '
                            'basah.',
                            style: pw.TextStyle(fontSize: 8.5, color: muted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      children: [
                        _amountRow('Subtotal', formatRupiah(subtotal), muted),
                        _amountRow(
                          'Biaya Layanan',
                          serviceFee == 0 ? 'Gratis' : formatRupiah(serviceFee),
                          muted,
                        ),
                        _amountRow(
                          'PPN (0%)',
                          tax == 0 ? 'Tidak dipungut' : formatRupiah(tax),
                          muted,
                        ),
                        pw.Divider(color: PdfColors.grey400),
                        _amountRow(
                          'TOTAL DIBAYAR',
                          formatRupiah(total),
                          primary,
                          bold: true,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // ── Tanda tangan & footer ─────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'Faktur ini diterbitkan oleh sistem $_sellerName dan '
                      'sah tanpa tanda tangan basah. Pertanyaan penagihan: '
                      '$_sellerEmail.',
                      style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Bandung, ${_dateOnly(record.purchasedAt)}',
                        style: pw.TextStyle(fontSize: 8.5, color: muted),
                      ),
                      pw.SizedBox(height: 28),
                      pw.Container(
                        width: 120,
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: PdfColors.grey500),
                          ),
                        ),
                        padding: const pw.EdgeInsets.only(top: 3),
                        child: pw.Text(
                          'Bagian Keuangan $_sellerName',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 8, color: muted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Dokumen dibuat otomatis · $invoiceNo',
                    style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey500),
                  ),
                  pw.Text(
                    'Halaman 1 dari 1',
                    style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey500),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  static pw.Widget _statusBadge(String label) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFE8F5E9),
        border: pw.Border.all(color: PdfColor.fromInt(0xFF9CCC9F)),
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 1.5,
          color: PdfColor.fromInt(0xFF1B5E20),
        ),
      ),
    );
  }

  static pw.Widget _infoBlock(
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

  static pw.Widget _th(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(
        fontSize: 7.5,
        fontWeight: pw.FontWeight.bold,
        letterSpacing: 0.5,
        color: PdfColors.white,
      ),
    );
  }

  static pw.Widget _amountRow(
    String label,
    String value,
    PdfColor labelColor, {
    bool bold = false,
    double fontSize = 9.5,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: fontSize,
              color: labelColor,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: bold ? labelColor : PdfColors.black,
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

  static String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

// ─── Terbilang ─────────────────────────────────────────────────────────

const _satuan = [
  '',
  'satu',
  'dua',
  'tiga',
  'empat',
  'lima',
  'enam',
  'tujuh',
  'delapan',
  'sembilan',
  'sepuluh',
  'sebelas',
];

/// Menyebut angka dalam bahasa Indonesia, mis. 91000 -> "sembilan puluh satu
/// ribu rupiah".
String terbilangRupiah(int value) {
  if (value == 0) return 'nol rupiah';
  return '${_terbilang(value.abs()).trim()} rupiah';
}

String _terbilang(int n) {
  if (n < 12) return _satuan[n];
  if (n < 20) return '${_satuan[n - 10]} belas';
  if (n < 100) {
    final sisa = n % 10;
    return '${_satuan[n ~/ 10]} puluh${sisa == 0 ? '' : ' ${_satuan[sisa]}'}';
  }
  if (n < 200) return 'seratus${_suffix(n % 100)}';
  if (n < 1000) {
    return '${_satuan[n ~/ 100]} ratus${_suffix(n % 100)}';
  }
  if (n < 2000) return 'seribu${_suffix(n % 1000)}';
  if (n < 1000000) {
    return '${_terbilang(n ~/ 1000)} ribu${_suffix(n % 1000)}';
  }
  if (n < 1000000000) {
    return '${_terbilang(n ~/ 1000000)} juta${_suffix(n % 1000000)}';
  }
  return '${_terbilang(n ~/ 1000000000)} miliar${_suffix(n % 1000000000)}';
}

String _suffix(int remainder) =>
    remainder == 0 ? '' : ' ${_terbilang(remainder)}';
