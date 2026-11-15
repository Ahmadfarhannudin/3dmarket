import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Lupa Kata Sandi',
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
            'POLYCRAFT 3D VAULT • PEMULIHAN AKUN',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.tertiary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lupa Kata Sandi?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masukkan alamat email profesional atau ID studio yang terdaftar. Tautan reset berlaku 15 menit.',
            style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _email,
            decoration: InputDecoration(
              hintText: 'desainer@alexandria3d.com',
              prefixIcon: const Icon(Icons.mail_outline),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _sent = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(_sent ? Icons.done_all : Icons.arrow_forward),
              label: Text(
                _sent
                    ? 'Tautan Terkirim! Periksa Inbox'
                    : 'Kirim Tautan Pemulihan',
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.forum_outlined),
            label: const Text('Kirim Kode Verifikasi via WhatsApp / SMS'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Panduan Kurator: 3 Langkah Pemulihan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Masukkan email studio.\n2. Buka tautan terenkripsi.\n3. Buat sandi baru untuk vault aset.',
            style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}
