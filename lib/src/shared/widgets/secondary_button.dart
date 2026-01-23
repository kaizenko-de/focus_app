import 'package:flutter/material.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/theme/custom_theme.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
  });

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(width ?? 130, height ?? 50),
          backgroundColor: AppColors.defaultLime.withAlpha(10),
          foregroundColor: AppColors.defaultLime,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? Sizes.p48),
          ),
          side: BorderSide(color: AppColors.defaultLime),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? Sizes.p16,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ).textmdRegular,
      ),
    );
  }
}
