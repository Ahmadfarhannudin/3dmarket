import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Implementasi web: berkas tetap di memori browser lewat `blob:` URL.
String? createBlobUrlImpl(Uint8List bytes, String mimeType) {
  try {
    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: mimeType),
    );
    return web.URL.createObjectURL(blob);
  } catch (_) {
    return null;
  }
}

void revokeBlobUrlImpl(String url) {
  try {
    web.URL.revokeObjectURL(url);
  } catch (_) {
    // URL sudah tidak valid; tidak ada yang perlu dibersihkan.
  }
}
