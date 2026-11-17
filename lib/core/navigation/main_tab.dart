import 'package:flutter/material.dart';

/// Penanda tab aktif pada kerangka utama (Beranda, Jelajah, Aset Saya, Profil).
///
/// Layar yang ditumpuk di atas kerangka — misalnya wishlist atau detail aset —
/// bisa memakai [open] untuk kembali ke kerangka utama sambil membuka tab
/// tertentu, sehingga bottom navigation tidak ikut hilang.
class MainTab {
  MainTab._();

  static const int home = 0;
  static const int explore = 1;
  static const int myAssets = 2;
  static const int profile = 3;

  static final ValueNotifier<int> index = ValueNotifier<int>(home);

  /// Tutup semua layar bertumpuk lalu tampilkan tab [tab] pada MainScreen.
  static void open(BuildContext context, int tab) {
    index.value = tab;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
