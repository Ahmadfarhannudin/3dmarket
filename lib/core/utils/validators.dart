class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
    if (!value.contains('@')) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 8) return 'Minimal 8 karakter';
    return null;
  }

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label wajib diisi';
    return null;
  }
}
