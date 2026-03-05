import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<({String name, String path, AssetGenImage icon})>
  _navigationItems = [
    (name: 'Dashboard', path: '/home', icon: Assets.images.dashboard),
    (name: 'Journal', path: '/journalhistory', icon: Assets.images.journal),
    (name: 'Routines', path: '/routines', icon: Assets.images.routines),
    (
      name: 'Supplements',
      path: '/supplements',
      icon: Assets.images.suppliments,
    ),
    (name: 'Settings', path: '/settings', icon: Assets.images.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.bgCard,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.grey,
        elevation: 8,
        items: List.generate(
          _navigationItems.length,
          (index) => BottomNavigationBarItem(
            icon: _navigationItems[index].icon.image(
              width: 24,
              height: 24,
              color: index == _selectedIndex ? Colors.white : Colors.grey,
            ),
            label: _navigationItems[index].name,
          ),
        ),
        onTap: (index) {
          setState(() => _selectedIndex = index);
          context.go(_navigationItems[index].path);
        },
      ),
    );
  }
}
