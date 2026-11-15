import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/app/router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _remember = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, AppRouter.main);
  }

  void _submitAdmin() {
    Navigator.pushNamed(context, AppRouter.admin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.92),
        elevation: 0,
        leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRouter.onboarding),
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
                _field(
                  'Alamat Email atau ID Kreator',
                  _email,
                  Icons.alternate_email,
                  'desainer@alexandria3d.com',
                ),
                const SizedBox(height: 14),
                _field(
                  'Kata Sandi',
                  _password,
                  Icons.lock_open,
                  'Minimal 8 karakter terenkripsi',
                  obscure: _obscure,
                  trailing: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
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
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRouter.forgot),
                      child: const Text('Lupa sandi?'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: _loading
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
              onPressed: _submitAdmin,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                backgroundColor: AppColors.surfaceContainerLowest,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.35)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.admin_panel_settings_outlined, size: 20),
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
            onPressed: () => _email.text = 'kreator.3d@alexandria-poly.id',
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
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.register),
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
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.secondary),
            suffixIcon: trailing,
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
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
