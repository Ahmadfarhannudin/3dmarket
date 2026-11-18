import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _terms = false;
  bool _obscure = true;
  String _role = 'Character Rigging';

  // Real-time validation states
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    _name.addListener(_validateName);
    _email.addListener(_validateEmail);
    _password.addListener(_validatePassword);
    _confirm.addListener(_validateConfirm);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _nameError = _name.text.isEmpty ? 'Nama tidak boleh kosong' : null;
    });
  }

  void _validateEmail() {
    final val = _email.text;
    setState(() {
      if (val.isEmpty) {
        _emailError = 'Email tidak boleh kosong';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
        _emailError = 'Format email tidak valid';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      if (_password.text.isEmpty) {
        _passwordError = 'Sandi tidak boleh kosong';
      } else if (_password.text.length < 8) {
        _passwordError = 'Minimal 8 karakter';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirm() {
    setState(() {
      if (_confirm.text != _password.text) {
        _confirmError = 'Sandi tidak cocok';
      } else {
        _confirmError = null;
      }
    });
  }

  bool get _isValid =>
      _name.text.isNotEmpty &&
      _email.text.isNotEmpty &&
      _password.text.isNotEmpty &&
      _confirm.text.isNotEmpty &&
      _nameError == null &&
      _emailError == null &&
      _passwordError == null &&
      _confirmError == null &&
      _terms;

  @override
  Widget build(BuildContext context) {
    const roles = [
      'Character Rigging',
      'Environment Art',
      'Game Asset',
      'ArchViz',
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'POLY ARCHIVE STUDIO',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.4,
                color: AppColors.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Registrasi Kreator',
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
          const Text(
            'Bergabung dengan\nArsip PolyCraft',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ruang kurasi eksklusif bagi 3D Artist, Technical Animator, dan Indie Game Studio.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'SPESIALISASI UTAMA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.tertiary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: roles
                .map(
                  (role) => ChoiceChip(
                    label: Text(role),
                    selected: _role == role,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _role == role ? Colors.white : AppColors.onSurface,
                      fontSize: 12,
                      fontWeight:
                          _role == role ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none,
                    ),
                    onSelected: (_) => setState(() => _role = role),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Column(
              children: [
                _input(
                  'Nama Kreator',
                  _name,
                  'contoh: Aria Bramantyo',
                  errorText: _nameError,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 14),
                _input(
                  'Email Studio',
                  _email,
                  'kreator@studio-animasi.id',
                  errorText: _emailError,
                  icon: Icons.alternate_email,
                ),
                const SizedBox(height: 14),
                _input(
                  'Kata Sandi',
                  _password,
                  'Minimal 8 karakter',
                  obscure: _obscure,
                  errorText: _passwordError,
                  icon: Icons.lock_outline,
                  trailing: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _input(
                  'Konfirmasi Sandi',
                  _confirm,
                  'Ulangi kata sandi',
                  obscure: _obscure,
                  errorText: _confirmError,
                  icon: Icons.lock_clock_outlined,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _terms,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _terms = v ?? false),
                  title: const Text(
                    'Saya setuju ketentuan lisensi dan keamanan data.',
                    style: TextStyle(fontSize: 12),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isValid ? () => Navigator.pop(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.surfaceContainerHigh,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Daftarkan Akun Kreator',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: AppColors.onSurface),
                children: [
                  TextSpan(text: 'Sudah memiliki akun arsip? '),
                  TextSpan(
                    text: 'Masuk di sini',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller,
    String hint, {
    bool obscure = false,
    IconData? icon,
    Widget? trailing,
    String? errorText,
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
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.secondary, size: 20)
                : null,
            suffixIcon: trailing,
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(fontSize: 10, height: 0.8),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}
