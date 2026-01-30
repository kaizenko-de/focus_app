import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/theme/custom_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderColor,
    this.svgImage,
    this.prefixIcon,
    this.isLoading = false,
    this.textColor,
    this.height,
    this.width,
    this.radius,
    this.fontSize,
    this.fontWeight,
  });

  ///  The text for the button
  final String text;

  ///  Color for the button. If the color is empty, it default to primary color
  final Color? color;

  /// Border color for the button. If the border color is null, it default
  /// shows transparent color
  final Color? borderColor;

  /// SVG image in prefix of button if svg image is available.
  final String? svgImage;

  /// Optional prefix icon (IconData) for the button.
  final IconData? prefixIcon;

  /// Function to execute on tap of button
  final VoidCallback? onPressed;

  /// isLoading to show circular progress indicator in button. We can show
  /// Circular Progress Indicator, if the function is executing some task
  /// and waiting for the result.
  final bool isLoading;

  /// Text color for the button text
  final Color? textColor;

  /// Height for the button
  final double? height;

  /// Width for the button
  final double? width;

  /// Radius for the button
  final double? radius;

  /// Font size for the button text
  final double? fontSize;

  /// Font weight for the button text
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    // The issue: When you set height, the text disappears because
    // ElevatedButton.styleFrom's padding can cause the child to have zero height
    // if the padding is too large for the given height, especially if vertical padding is not adjusted.
    // Solution: Remove vertical padding from style and use Center to ensure text is always visible.
    return SizedBox(
      height: height ?? 50,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.defaultLime,
          disabledBackgroundColor: AppColors.defaultLime.withAlpha(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? Sizes.p64),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
          // Remove vertical padding to avoid text disappearing when height is set
          padding: EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: 0),
          elevation: 0,
          overlayColor: AppColors.primary.withAlpha(25),
          minimumSize: Size(width ?? 0, height ?? 50),
          // minimumSize ensures the button respects the height
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.black,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (svgImage != null)
                    Padding(
                      padding: EdgeInsets.only(right: Sizes.p8),
                      child: SvgPicture.asset(
                        svgImage!,
                        height: Sizes.p20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (prefixIcon != null)
                    Padding(
                      padding: EdgeInsets.only(right: Sizes.p4),
                      child: Icon(
                        prefixIcon,
                        size:
                            fontSize ??
                            ((height ?? 50) < 40 ? Sizes.p16 : Sizes.p20),
                        color:
                            textColor ??
                            (svgImage != null
                                ? Colors.white
                                : borderColor != null
                                ? AppColors.black
                                : Colors.black),
                      ),
                    ),
                  Flexible(
                    child:
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight:
                                fontWeight ??
                                (borderColor != null ? FontWeight.w700 : null),
                            fontSize:
                                fontSize ??
                                ((height ?? 50) < 40 ? Sizes.p12 : Sizes.p16),
                          ),
                        ).textsmBold.foregroundColor(
                          textColor ??
                              (svgImage != null
                                  ? Colors.white
                                  : borderColor != null
                                  ? AppColors.black
                                  : Colors.black),
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
