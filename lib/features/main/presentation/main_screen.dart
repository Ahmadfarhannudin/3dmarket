import 'package:flutter/material.dart';
import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/widgets/bottom_nav.dart';
import 'package:_3dmarket/features/home/presentation/home_screen.dart';
import 'package:_3dmarket/features/explore/presentation/explore_screen.dart';
import 'package:_3dmarket/features/my_assets/presentation/my_assets_screen.dart';
import 'package:_3dmarket/features/profile/presentation/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = widget.initialIndex;

  final _screens = const <Widget>[
    HomeScreen(),
    ExploreScreen(),
    MyAssetsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
