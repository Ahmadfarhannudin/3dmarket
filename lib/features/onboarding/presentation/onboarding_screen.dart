import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/app/router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _heroImage = 'assets/images/onboarding_hero.png';

  static const _pages = [
    _OnboardingPage(
      headline: 'Kurasi Aset 3D Standar Industri Blender',
      body:
          'Koleksi model poligon presisi tinggi, teroptimasi untuk alur kerja '
          'produksi studio, animasi, dan render fotorealistis.',
      heroKicker: 'Model Utama Minggu Ini',
      heroTitle: 'Cybernetic Chrono Arm Mk. IV',
      heroMeta: 'Polycount: 48,250 Quads • 8K PBR Maps',
      catalog: 'Katalog #PC-8821',
      ctaLabel: 'Lanjut ke Kurasi Rigging',
      values: [
        _ValueProp(
          icon: Icons.view_in_ar,
          title: 'Preview Interaktif 3D & GLB Web Viewer',
          body:
              'Inspeksi mesh, material shader, dan alur topologi langsung dari '
              'browser ponsel sebelum mengunduh.',
        ),
        _ValueProp(
          icon: Icons.gavel,
          title: 'Lisensi Komersial Perpetual & Bebas Royalti',
          body:
              'Gunakan untuk video game indie, iklan televisi, VFX, hingga '
              'metaverse tanpa batas durasi tayang.',
        ),
        _ValueProp(
          icon: Icons.precision_manufacturing,
          title: 'Langsung Import ke Rigify & Cycles Engine',
          body:
              'Hierarki bone rapi siap pose, setup lighting terintegrasi, dan '
              'node shader Blender native tanpa error.',
        ),
      ],
    ),
    _OnboardingPage(
      headline: 'Preview Interaktif 3D & GLB Web Viewer',
      body:
          'Inspeksi mesh, material shader, dan alur topologi langsung dari '
          'browser ponsel sebelum mengunduh.',
      heroKicker: 'Preview Real-Time',
      heroTitle: 'Orbit, Zoom & Wireframe',
      heroMeta: 'GLB 2.0 • PBR 8K • 60 FPS',
      catalog: 'Viewer #PC-8821',
      ctaLabel: 'Lanjut ke Lisensi',
      values: [
        _ValueProp(
          icon: Icons.threed_rotation,
          title: 'Orbit 360° Tanpa Aplikasi Tambahan',
          body:
              'Putar, zoom, dan telusuri setiap sisi model langsung di browser '
              'ponsel dengan gesture natural.',
        ),
        _ValueProp(
          icon: Icons.texture,
          title: 'Material Shader PBR Asli',
          body:
              'Tekstur 8K, normal map, dan roughness tampil akurat seperti '
              'hasil render di Blender Cycles.',
        ),
        _ValueProp(
          icon: Icons.account_tree,
          title: 'Topologi & Polycount Transparan',
          body:
              'Lihat struktur quad, jumlah poligon, dan hierarki objek sebelum '
              'memutuskan untuk mengunduh.',
        ),
      ],
    ),
    _OnboardingPage(
      headline: 'Lisensi Komersial Perpetual & Bebas Royalti',
      body:
          'Gunakan untuk game indie, iklan, VFX, dan metaverse tanpa batas '
          'durasi tayang.',
      heroKicker: 'Lisensi Komersial',
      heroTitle: 'Sekali Bayar, Pakai Selamanya',
      heroMeta: 'Perpetual • Worldwide • Royalty-Free',
      catalog: 'Lisensi #PC-8821',
      ctaLabel: 'Mulai Jelajahi Aset',
      values: [
        _ValueProp(
          icon: Icons.gavel,
          title: 'Perpetual Tanpa Perpanjangan',
          body:
              'Sekali transaksi, lisensi aktif selamanya. Tidak ada biaya '
              'langganan atau perpanjangan tahunan.',
        ),
        _ValueProp(
          icon: Icons.public,
          title: 'Berlaku Global untuk Semua Media',
          body:
              'Game, film, iklan, cetak, hingga metaverse — satu lisensi '
              'mencakup seluruh kanal distribusi.',
        ),
        _ValueProp(
          icon: Icons.receipt_long,
          title: 'Faktur & Sertifikat Resmi',
          body:
              'Setiap pembelian disertai faktur dan sertifikat lisensi yang '
              'siap dilampirkan ke klien studio.',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    context.go(AppRouter.login);
  }

  void _goToHome() {
    context.go(AppRouter.main);
  }

  void _next() {
    if (_page == _pages.length - 1) {
      _goToLogin();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onSkip: _goToHome),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _OnboardingPageView(
                  page: _pages[i],
                  index: i,
                  total: _pages.length,
                ),
              ),
            ),
            _Footer(
              page: _page,
              total: _pages.length,
              ctaLabel: _pages[_page].ctaLabel,
              onNext: _next,
              onLogin: _goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Model                                    */
/* -------------------------------------------------------------------------- */

class _OnboardingPage {
  const _OnboardingPage({
    required this.headline,
    required this.body,
    required this.heroKicker,
    required this.heroTitle,
    required this.heroMeta,
    required this.catalog,
    required this.ctaLabel,
    required this.values,
  });

  final String headline;
  final String body;
  final String heroKicker;
  final String heroTitle;
  final String heroMeta;
  final String catalog;
  final String ctaLabel;
  final List<_ValueProp> values;
}

class _ValueProp {
  const _ValueProp({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

/* -------------------------------------------------------------------------- */
/*                                   Header                                   */
/* -------------------------------------------------------------------------- */

class _Header extends StatelessWidget {
  const _Header({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 12, 2),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.view_in_ar,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '3DMARKET STUDIO',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              overlayColor: AppColors.surfaceContainerHigh,
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'LEWATI',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 Page body                                  */
/* -------------------------------------------------------------------------- */

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({
    required this.page,
    required this.index,
    required this.total,
  });

  final _OnboardingPage page;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ArchiveBadge(index: index, total: total),
          const SizedBox(height: 12),
          Text(
            page.headline,
            style: const TextStyle(
              fontFamily: 'Noto Serif',
              fontVariations: [FontVariation('wght', 700)],
              fontSize: 29,
              height: 1.24,
              letterSpacing: -0.4,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            page.body,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.55,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          _HeroCard(page: page),
          const SizedBox(height: 20),
          for (final value in page.values) ...[
            _ValueCard(value: value),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ArchiveBadge extends StatelessWidget {
  const _ArchiveBadge({required this.index, required this.total});

  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final number = (index + 1).toString().padLeft(2, '0');
    final totalNumber = total.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, size: 14, color: AppColors.tertiary),
          const SizedBox(width: 6),
          Text(
            'Arsip Kurasi No. $number / $totalNumber',
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 500)],
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 Hero card                                  */
/* -------------------------------------------------------------------------- */

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  _OnboardingScreenState._heroImage,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.15),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.0, 0.45, 1.0],
                      colors: [
                        Color(0xD91B1C1D),
                        Color(0x331B1C1D),
                        Color(0x001B1C1D),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Flexible(child: _ReadyPill()),
                      SizedBox(width: 8),
                      _OrbitPill(),
                    ],
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              page.heroKicker.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Public Sans',
                                fontVariations: [FontVariation('wght', 500)],
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                                height: 1.2,
                                color: AppColors.primaryFixed,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              page.heroTitle,
                              style: const TextStyle(
                                fontFamily: 'Noto Serif',
                                fontVariations: [FontVariation('wght', 600)],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              page.heroMeta,
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.3,
                                color: Colors.white.withValues(alpha: 0.80),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const _PreviewButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      Icon(Icons.polyline, size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Flexible(child: _RibbonLabel('Clean Sub-D')),
                      _RibbonDivider(),
                      Icon(Icons.flare, size: 14, color: AppColors.tertiary),
                      SizedBox(width: 4),
                      Flexible(child: _RibbonLabel('Cycles & EEVEE')),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  page.catalog,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 500)],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RibbonLabel extends StatelessWidget {
  const _RibbonLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Public Sans',
        fontVariations: [FontVariation('wght', 500)],
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _RibbonDivider extends StatelessWidget {
  const _RibbonDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.outline.withValues(alpha: 0.30),
    );
  }
}

class _ReadyPill extends StatelessWidget {
  const _ReadyPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: _PulseDot(),
          ),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              'Blender 4.x Ready • 100% Quads',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.35,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _OrbitPill extends StatelessWidget {
  const _OrbitPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.videocam, size: 14, color: AppColors.secondary),
          SizedBox(width: 4),
          Text(
            'Orbit 360°',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontVariations: [FontVariation('wght', 500)],
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Buka pratinjau 3D',
      child: Material(
        color: AppColors.surface.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: AppColors.onSurface.withValues(alpha: 0.25),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {},
          child: const SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              Icons.threed_rotation,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                Value cards                                 */
/* -------------------------------------------------------------------------- */

class _ValueCard extends StatelessWidget {
  const _ValueCard({required this.value});

  final _ValueProp value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(value.icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.title,
                  style: const TextStyle(
                    fontFamily: 'Noto Serif',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.body,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Footer                                   */
/* -------------------------------------------------------------------------- */

class _Footer extends StatelessWidget {
  const _Footer({
    required this.page,
    required this.total,
    required this.ctaLabel,
    required this.onNext,
    required this.onLogin,
  });

  final int page;
  final int total;
  final String ctaLabel;
  final VoidCallback onNext;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < total; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  width: i == page ? 28 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == page
                        ? AppColors.primary
                        : AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF3366CC)],
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: onNext,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.onPrimary,
                  shape: const StadiumBorder(),
                  overlayColor: Colors.white.withValues(alpha: 0.14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ctaLabel,
                      style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontVariations: [FontVariation('wght', 600)],
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 17),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sudah terdaftar sebagai kreator?',
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.3,
                  color: AppColors.secondary,
                ),
              ),
              TextButton(
                onPressed: onLogin,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
