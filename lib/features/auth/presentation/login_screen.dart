import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/app/router.dart';
import 'package:_3dmarket/features/auth/domain/auth_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Akun demo yang sengaja dibuat sederhana supaya mudah dipakai saat
  // pengujian/presentasi. Akun lama tetap diterima sebagai alias.
  static const String demoBuyerEmail = 'pembeli@demo.com';
  static const String demoBuyerPassword = 'pembeli123';
  static const String demoAdminEmail = 'admin@demo.com';
  static const String demoAdminPassword = 'admin123';

  static const Map<String, String> _buyerAccounts = {
    demoBuyerEmail: demoBuyerPassword,
    'deva.praditya@studio3d.id': 'kreator3d',
  };

  static const Map<String, String> _adminAccounts = {
    demoAdminEmail: demoAdminPassword,
    'admin@gmail.com': 'admin123',
  };

  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _remember = true;
  bool _loadingBuyer = false;
  bool _loadingAdmin = false;

  // Validasi realtime: pesan baru muncul setelah kolom disentuh/di-submit,
  // lalu ikut berubah setiap kali pengguna mengetik.
  bool _emailTouched = false;
  bool _passwordTouched = false;
  String? _authError;

  bool get _busy => _loadingBuyer || _loadingAdmin;

  bool get _emailIsValid => _emailPattern.hasMatch(_email.text.trim());

  bool get _passwordIsValid => _password.text.length >= 8;

  bool get _formIsValid => _emailIsValid && _passwordIsValid;

  String? get _emailError {
    if (!_emailTouched) return null;
    final value = _email.text.trim();
    if (value.isEmpty) return 'Email wajib diisi';
    if (!_emailPattern.hasMatch(value)) {
      return 'Format email belum valid (contoh: nama@domain.com)';
    }
    return null;
  }

  String? get _passwordError {
    if (!_passwordTouched) return null;
    if (_password.text.isEmpty) return 'Kata sandi wajib diisi';
    if (_password.text.length < 8) return 'Minimal 8 karakter';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _email.addListener(() => _onInputChanged(email: true));
    _password.addListener(() => _onInputChanged(email: false));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onInputChanged({required bool email}) {
    if (!mounted) return;
    setState(() {
      if (email) {
        _emailTouched = true;
      } else {
        _passwordTouched = true;
      }
      if (_authError != null) _authError = null;
    });
  }

  void _fillDemo({required bool admin}) {
    _email.text = admin ? demoAdminEmail : demoBuyerEmail;
    _password.text = admin ? demoAdminPassword : demoBuyerPassword;
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
      _authError = null;
    });
  }

  Future<void> _submit({required bool admin}) async {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
      _authError = null;
    });

    if (!_formIsValid) {
      setState(() {
        _authError = 'Periksa kembali email dan kata sandi Anda.';
      });
      return;
    }

    setState(() {
      if (admin) {
        _loadingAdmin = true;
      } else {
        _loadingBuyer = true;
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final email = _email.text.trim();
    final password = _password.text;
    final accounts = admin ? _adminAccounts : _buyerAccounts;
    final matches = accounts[email] == password;

    setState(() {
      _loadingBuyer = false;
      _loadingAdmin = false;
    });

    if (matches) {
      AuthSession.instance.signIn(
        role: admin ? UserRole.admin : UserRole.buyer,
        email: email,
      );
      if (admin) {
        context.go(AppRouter.admin);
      } else {
        context.go(AppRouter.main);
      }
      return;
    }

    setState(() {
      _authError = admin
          ? 'Email atau kata sandi admin tidak cocok. Gunakan akun demo Admin.'
          : 'Email atau kata sandi pembeli tidak cocok. Gunakan akun demo Pembeli.';
    });
  }

  Future<void> _quickLogin({required bool admin}) async {
    _fillDemo(admin: admin);
    await _submit(admin: admin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.92),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go(AppRouter.onboarding),
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3DMARKET STUDIO',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.4,
                color: AppColors.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Autentikasi Vault',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'POLYCRAFT 3D VAULT • AKUN KREATOR',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.tertiary,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masuk ke Studio PolyCraft',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pusat kurasi aset 3D Blender resolusi tinggi, shader nodular, dan lisensi komersial eksklusif.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          _spotlight(),
          const SizedBox(height: 14),
          _demoAccounts(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Column(
              children: [
                if (_authError != null) ...[
                  _inlineError(_authError!),
                  const SizedBox(height: 14),
                ],
                _field(
                  'Alamat Email atau ID Kreator',
                  _email,
                  Icons.alternate_email,
                  'nama@domain.com',
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (_) => _submit(admin: false),
                  trailing: _emailTouched && _emailIsValid
                      ? const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 14),
                _field(
                  'Kata Sandi',
                  _password,
                  Icons.lock_open,
                  'Minimal 8 karakter terenkripsi',
                  obscure: _obscure,
                  errorText: _passwordError,
                  onSubmitted: (_) => _submit(admin: false),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_passwordTouched && _passwordIsValid)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF2E7D32),
                          size: 19,
                        ),
                      IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        tooltip: _obscure
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_passwordTouched || _password.text.isNotEmpty)
                  _passwordRule(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _remember,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _remember = v ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'Ingat saya di perangkat ini',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRouter.forgot),
                      child: const Text('Lupa sandi?'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _busy ? null : () => _submit(admin: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: _loadingBuyer
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.login),
                    label: const Text(
                      'Masuk ke Akun Studio',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _busy ? null : () => _submit(admin: true),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                backgroundColor: AppColors.surfaceContainerLowest,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: _loadingAdmin
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.admin_panel_settings_outlined, size: 20),
              label: const Text(
                'Masuk Studio Admin',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Khusus kurator 3DMarket — kelola katalog, pesanan, dan analitik.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _fillDemo(admin: false),
            icon: const Icon(Icons.g_mobiledata, size: 28),
            label: const Text('Lanjutkan dengan Google Workspace'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Belum memiliki lisensi kreator? ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRouter.register),
                child: const Text('Daftar Akun Baru'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              _Trust('verified', 'Lisensi Komersial', 'Terverifikasi'),
              SizedBox(width: 8),
              _Trust('grid_4x4', '100% Quads', 'Clean Topology'),
              SizedBox(width: 8),
              _Trust('lock', 'Enkripsi Aman', 'Firebase Auth'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _demoAccounts() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt, size: 17, color: AppColors.primary),
              SizedBox(width: 5),
              Text(
                'Akun Demo — sekali ketuk',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Ketuk "Isi" untuk melengkapi formulir, atau "Masuk" untuk langsung login.',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.35,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          _demoTile(
            title: 'Pembeli',
            email: demoBuyerEmail,
            password: demoBuyerPassword,
            icon: Icons.person_outline,
            loading: _loadingBuyer,
            enabled: !_busy,
            onFill: () => _fillDemo(admin: false),
            onLogin: () => _quickLogin(admin: false),
          ),
          const SizedBox(height: 8),
          _demoTile(
            title: 'Admin',
            email: demoAdminEmail,
            password: demoAdminPassword,
            icon: Icons.admin_panel_settings_outlined,
            loading: _loadingAdmin,
            enabled: !_busy,
            onFill: () => _fillDemo(admin: true),
            onLogin: () => _quickLogin(admin: true),
          ),
        ],
      ),
    );
  }

  Widget _demoTile({
    required String title,
    required String email,
    required String password,
    required IconData icon,
    required bool loading,
    required bool enabled,
    required VoidCallback onFill,
    required VoidCallback onLogin,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 7, 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '$email  •  $password',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: enabled ? onFill : null,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 32),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Isi', style: TextStyle(fontSize: 11.5)),
          ),
          const SizedBox(width: 2),
          FilledButton(
            onPressed: enabled ? onLogin : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size(0, 32),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: loading
                ? const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimary,
                    ),
                  )
                : const Text('Masuk', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }

  Widget _inlineError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            size: 16,
            color: AppColors.onErrorContainer,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.35,
                color: AppColors.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordRule() {
    final valid = _passwordIsValid;
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 2),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 13,
            color: valid ? const Color(0xFF2E7D32) : AppColors.outline,
          ),
          const SizedBox(width: 4),
          Text(
            'Minimal 8 karakter',
            style: TextStyle(
              fontSize: 10.5,
              color: valid ? const Color(0xFF2E7D32) : AppColors.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _spotlight() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDmbquykuwPPFtfWAgvnJF0m44UyYuk3cRsUcM4wdg1Dklm41d18UhTstqmJbrF5JSo6xoIRKy90IM_-dy_KzmvsBEHXnBWRkqbGeDd5LvuiV-pUe7cE2RLV6s-lE182wsbtKrGiABEeMOlvZE5SiiWDHDCSvxXx7MYYAOg8wo7ttjkb06AL-OL7nSD-2SogPu0H4r7nfkkCZ1Sk0GDCk6iKTUAG1ibtSuFkCEB3jE',
              width: 58,
              height: 58,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPOTLIGHT MINGGUAN',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Cybernetic Mechanoid Hand v4.2',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Blender 4.x • 4K PBR Textures',
                  style: TextStyle(fontSize: 11, color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, {
    bool obscure = false,
    Widget? trailing,
    String? errorText,
    TextInputType? keyboardType,
    ValueChanged<String>? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            errorMaxLines: 2,
            prefixIcon: Icon(icon, color: AppColors.secondary),
            suffixIcon: trailing,
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: errorText == null
                    ? AppColors.surfaceContainerHigh
                    : AppColors.error,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: errorText == null ? AppColors.primary : AppColors.error,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Trust extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  const _Trust(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceContainerHigh),
        ),
        child: Column(
          children: [
            const Icon(Icons.verified, color: AppColors.tertiary, size: 18),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
