import 'dart:typed_data';

/// Platform tanpa `dart:js_interop` tidak punya URL sementara.
String? createBlobUrlImpl(Uint8List bytes, String mimeType) => null;

void revokeBlobUrlImpl(String url) {}
