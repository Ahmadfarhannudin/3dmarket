import 'dart:typed_data';

import 'blob_url_stub.dart' if (dart.library.js_interop) 'blob_url_web.dart';

/// Membuat URL sementara untuk berkas yang baru dipilih pengguna.
///
/// Di web URL berbentuk `blob:` sehingga bisa langsung dibaca `model-viewer`
/// tanpa menyentuh server. Di platform lain (atau bila gagal) hasilnya `null`
/// dan pemanggil harus menyediakan fallback.
String? createLocalBlobUrl(Uint8List bytes, String mimeType) {
  return createBlobUrlImpl(bytes, mimeType);
}

/// Melepas URL sementara agar memori browser tidak menumpuk.
void revokeLocalBlobUrl(String url) {
  revokeBlobUrlImpl(url);
}
