/// Peran pengguna yang sedang masuk pada sesi aplikasi.
enum UserRole { buyer, admin }

/// Sesi autentikasi sederhana yang hidup selama aplikasi berjalan.
///
/// Dipakai oleh router untuk menolak akses langsung ke URL admin tanpa
/// melewati halaman login terlebih dahulu.
class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  UserRole? _role;
  String? _email;

  UserRole? get role => _role;

  String? get email => _email;

  bool get isLoggedIn => _role != null;

  bool get isAdmin => _role == UserRole.admin;

  bool get isBuyer => _role == UserRole.buyer;

  void signIn({required UserRole role, required String email}) {
    _role = role;
    _email = email;
  }

  void signOut() {
    _role = null;
    _email = null;
  }
}
