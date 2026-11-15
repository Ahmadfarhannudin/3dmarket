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

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

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
        title: const Text(
          'Daftar Akun Baru',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Bergabung dengan Arsip PolyCraft',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ruang kurasi eksklusif bagi 3D Artist, Technical Animator, dan Indie Game Studio.',
            style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 16),
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
                    ),
                    onSelected: (_) => setState(() => _role = role),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          _input('Nama Kreator', _name, 'contoh: Aria Bramantyo'),
          _input('Email Studio', _email, 'kreator@studio-animasi.id'),
          _input(
            'Kata Sandi',
            _password,
            'Minimal 8 karakter kombinasi',
            obscure: _obscure,
          ),
          _input(
            'Ulangi Kata Sandi',
            _confirm,
            'Ulangi kata sandi Anda',
            obscure: _obscure,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _terms,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _terms = v ?? false),
            title: const Text(
              'Saya setuju ketentuan lisensi dan keamanan data.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _terms ? () => Navigator.pop(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Daftarkan Akun Kreator',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Sudah memiliki akun arsip? Masuk ke PolyCraft Studio',
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
