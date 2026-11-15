import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  static const items = [
    (
      'Chronograph Horology Masterpiece',
      'Rp 115.000',
      'Rp 192.000',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDvtQF99rAAeA5yEFKoBbjKIys32CpnVJ7PkPYhoepokoW-JSxl0p2jDa-MqfHgSooCWiracdbeuRcXntXBP5GWk3O8Jx_5bvGFZ0-Ee4hsEyA5y15wsoLa4MpfDxKImK7AmYY1y1e0Cf-ZrHNzNXscT74JumXeiKoymn7pT9Dr3BO93CnnDEb1WN2hGSfkl1J_SVDHZNYumjr7k_Aaa5_m_BMrIYn1RnkKX15vfWE',
    ),
    (
      'Sci-Fi Heavy Mech Robot Vanguard-X',
      'Rp 149.000',
      '',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDOwbsDzYU-xrSbuQnu_5k20AylS9tinXX6tFID5Cl_OskT1e_H5QPP2mJT6ziDRFTdSd2uT1C-RG3MAdnBA2ADLU5wjSZmdq35Z4D_-JN9FYtT1cEK2XjVThrgmAkLCI0YirNU0qHhaLHjMM0lvVQjrwFaOo8LCyW6_PjAlCbJRaG2HJErk-yoZCIEXNVbCC0EhOt0xB5COHkH59YFmImbke6UBXt_bERUNTEs_bQ',
    ),
    (
      'Tactical Exo Helmet Armor Mk. II',
      'Rp 75.000',
      '',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDM32yhucoHvXl-SIPFCxWwOQPlZUAjDBSRpcDrWQNocTo4W47HK6w89IY1b75VFistewjnprwOPcIiDlpjPIzyPaYRaeV8dIDS_wVx8ZVJIsUaVJM4IjclO-wbbIL3c3GnLIT0JtzC8DNziigFEqSW7XfJMmyqBtQux9kZM8FzRv_OOfC3kMdZKObtl0d-r698zz0CyZsQMSr47piNoAmM817PdeP_aFSapadxE5Q',
    ),
    (
      'Stylized Fantasy Weapon Arsenal',
      'GRATIS',
      '',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAOY5_GlAzJdfOxfxagw3UzlkGydoavQMK0VqV_NYPprz8dkyO4XAHBZBBH2VUUHrAhATPCl5wp8nVydw8S_aMtuIhFg8nVNEXFq7623kk4WrtdYpDdBsOuC9qdAAvED9YkB9K4UpE0lSrgSRJ_VVfHRCoBjKhmAfGkefZ7aF28WbzIGJpYx56op1EKQh_W4xM_9aloOdvQp36rZs2HzdGT2gVpi6we4YmnUy-4n2A',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      leading: const BackButton(),
      title: const Text('Koleksi & Wishlist'),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(child: Icon(Icons.person)),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        const Text(
          'ARSIP KURASI PRIBADI',
          style: TextStyle(
            color: AppColors.tertiary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const Text(
          'Koleksi Favorit & Wishlist',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          color: AppColors.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('12 Model', 'Tersimpan'),
                _stat('3 Promo', 'Diskon'),
                _stat('Rp 1.14 Jt', 'Nilai'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const ChoiceChip(label: Text('Semua (12)'), selected: true),
              const SizedBox(width: 8),
              ...[
                'Sedang Diskon',
                'Karakter & Rig',
                'Environment & Props',
                'Shader / Nodes',
              ].map(
                (t) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(label: Text(t), selected: false),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (i) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        i.$4,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          width: 90,
                          height: 90,
                          child: Icon(Icons.view_in_ar),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i.$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const Text(
                              'Format: .blend',
                              style: TextStyle(fontSize: 11),
                            ),
                            Row(
                              children: [
                                Text(
                                  i.$2,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (i.$3.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      i.$3,
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Hapus'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Beli'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _stat(String v, String l) => Column(
    children: [
      Text(v, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(l, style: const TextStyle(fontSize: 10)),
    ],
  );
}
