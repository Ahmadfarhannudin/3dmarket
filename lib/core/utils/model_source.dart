import 'package:flutter/foundation.dart';

/// Resolves a pubspec asset key into a URL that `model_viewer_plus` can fetch.
///
/// On web the Flutter engine serves assets under `assets/`, so an asset key of
/// `assets/models/x.glb` is reachable at `assets/assets/models/x.glb`. On other
/// platforms `model_viewer_plus` reads the key through the asset server, so the
/// key must be passed unchanged.
String modelSource(String assetKey) {
  if (!kIsWeb) return assetKey;
  return Uri.base.resolve('assets/$assetKey').toString();
}

/// Sama seperti [modelSource], tetapi membiarkan URL absolut apa adanya.
///
/// Model hasil unggahan admin memakai `blob:` URL yang sudah siap dipakai,
/// sedangkan aset bawaan masih berupa key `assets/models/...`.
String resolveModelSource(String source) {
  if (source.startsWith('http://') ||
      source.startsWith('https://') ||
      source.startsWith('blob:') ||
      source.startsWith('data:')) {
    return source;
  }
  return modelSource(source);
}
