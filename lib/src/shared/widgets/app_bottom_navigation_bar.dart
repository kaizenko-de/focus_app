/* import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/router/app_router.dart';
import 'package:focus/src/theme/custom_theme.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppButtonNavigationBar extends HookConsumerWidget {
  const AppButtonNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final RouteMatch lastMatch =
        router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : router.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: isIOS ? 20 : 12,
        left: 16,
        right: 16,
        top: 8,
      ),
      decoration: BoxDecoration(color: AppColors.defaultBlack),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // BottomNavigationBarItem(
          //   icon: Assets.svg.dashboard,
          //   title: 'Home',
          //   isActive: location.contains('home'),
          //   onTap: () {
          //     context.goNamed(AppRoutes.home.name);
          //   },
          // ),
          BottomNavigationBarItem(
            icon: Assets.svg.journal,
            title: 'Friends',
            isActive: location.contains('friends'),

            onTap: () {},
          ),

          BottomNavigationBarItem(
            icon: Assets.svg.routines,
            title: 'Events',
            isActive: location.contains('events'),

            onTap: () {},
          ),
          BottomNavigationBarItem(
            icon: Assets.svg.pill,
            title: 'Profile',
            isActive: location.contains('settings'),

            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class BottomNavigationBarItem extends StatelessWidget {
  const BottomNavigationBarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    this.fontSize,
    this.onTap,
  });

  final String icon;
  final String title;
  final bool isActive;
  final VoidCallback? onTap;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? null : onTap,
      child: Container(
        width: 82,
        height: 70,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9999)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              gapH4,
              SvgPicture.asset(
                icon,
                width: 24.5,
                height: 24.5,
                colorFilter: ColorFilter.mode(
                  isActive
                      ? AppColors.defaultLime
                      : AppColors.white.withAlpha(80),
                  BlendMode.srcIn,
                ),
              ),
              gapH4,
              Text(
                title,
                style: TextStyle(fontSize: fontSize),
              ).textxsRegular.foregroundColor(
                isActive
                    ? AppColors.defaultLime
                    : AppColors.white.withAlpha(80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */
