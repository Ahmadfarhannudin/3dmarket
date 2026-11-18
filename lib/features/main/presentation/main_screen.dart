import 'package:go_router/go_router.dart';
import 'package:_3dmarket/app/router.dart';
import 'package:flutter/material.dart';

import 'package:_3dmarket/core/constants/app_colors.dart';
import 'package:_3dmarket/core/navigation/main_tab.dart';
import 'package:_3dmarket/core/widgets/bottom_nav.dart';
import 'package:_3dmarket/features/home/presentation/home_screen.dart';
import 'package:_3dmarket/features/explore/presentation/explore_screen.dart';
import 'package:_3dmarket/features/my_assets/presentation/my_assets_screen.dart';
import 'package:_3dmarket/features/profile/presentation/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0, this.child});

  final int initialIndex;
  final Widget? child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = widget.initialIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    MainTab.index.value = widget.initialIndex;
    MainTab.index.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != _currentIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  void _onTabChanged() {
    if (!mounted) return;
    final index = MainTab.index.value;
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);

      // Sync URL with tab selection
      switch (index) {
        case 0:
          context.go(AppRouter.main);
          break;
        case 1:
          context.go(AppRouter.explore);
          break;
        case 2:
          context.go(AppRouter.myAssets);
          break;
        case 3:
          context.go(AppRouter.profile);
          break;
      }
    }
  }

  @override
  void dispose() {
    MainTab.index.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body:
          widget.child ??
          IndexedStack(
            index: _currentIndex,
            children: const [
              HomeScreen(),
              ExploreScreen(),
              MyAssetsScreen(),
              ProfileScreen(),
            ],
          ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => MainTab.index.value = i,
      ),
    );
  }
}
