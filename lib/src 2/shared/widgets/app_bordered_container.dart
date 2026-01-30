import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';

import 'package:flutter/material.dart';

class AppBorderedContainer extends StatelessWidget {
  const AppBorderedContainer({required this.child, this.margin, super.key});

  final Widget child;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p24),
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(Sizes.p16),
        border: Border.all(color: AppColors.white.withAlpha(80)),
      ),
      child: child,
    );
  }
}
