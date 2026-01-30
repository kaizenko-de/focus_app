
import 'package:flutter/material.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/theme/custom_theme.dart';

class ButtonTile extends StatelessWidget {
  const ButtonTile({
    super.key,
    required this.onTap,
    required this.title,
    this.height,
    this.width,
    this.value,
    this.color,
    this.backgroundColor,
  });

  final VoidCallback onTap;
  final String title;
  final String? value;
  final Color? color;
  final Color? backgroundColor;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Sizes.p12),
        splashColor: AppColors.defaultLime.withAlpha(20),
        highlightColor: AppColors.defaultLime.withAlpha(50),
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(vertical: Sizes.p16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.p12),
            color: backgroundColor ?? AppColors.white.withAlpha(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title).textxsRegular.foregroundColor(color),
              value != null
                  ? Text(value ?? '').textxlBold.foregroundColor(color)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
