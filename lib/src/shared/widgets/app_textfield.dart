
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/theme/custom_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A custom text field widget with additional features
class AppTextField extends HookConsumerWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.textInputAction,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.label,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
    this.textCapitalization,
    this.focusNode,
    this.onChanged,
    this.onNext,
    this.borderRadius = 8.0,
    this.fillColor,
  });

  /// Text editing controller for managing the text input
  final TextEditingController? controller;
  // Whether to hide the text like passwords
  final bool obscureText;

  /// Whether the text field is read-only
  final bool readOnly;

  /// Action to perform when the user submits the input
  final TextInputAction? textInputAction;

  /// Widget to display at the end of the text field
  final Widget? suffixIcon;

  /// Callback function to be called when the text field is tapped
  final VoidCallback? onTap;

  final Function(String)? onChanged;

  /// Callback function to be called when the text field is changed

  /// Validator function for validating the input
  final String? Function(String?)? validator;

  /// Label text to display above the text field
  final String? label;

  /// Hint text to display when the text field is empty
  final String? hintText;

  /// Number of lines to display in the text field
  final int? maxLines;

  /// Type of keyboard to display
  final TextInputType? keyboardType;

  /// Widget to display at the beginning of the text field
  final Widget? prefixIcon;

  /// Capitalization style for the input text
  final TextCapitalization? textCapitalization;

  /// Focus node to control the focus of the text field
  final FocusNode? focusNode;

  final VoidCallback? onNext;

  /// Border radius for the text field
  final double borderRadius;

  final Color? fillColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideText = useState(true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!).textmdRegular.foregroundColor(AppColors.white),
          gapH4,
        ],
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          onTap: onTap,
          onFieldSubmitted: (_) {
            if (onNext != null) {
              onNext!();
            }
          },
          onChanged: onChanged,
          keyboardType: keyboardType,
          readOnly: readOnly,
          validator: validator,
          controller: controller,
          maxLines: maxLines,
          obscureText: obscureText ? hideText.value : false,
          textInputAction: textInputAction ?? TextInputAction.next,
          decoration: InputDecoration(
            errorMaxLines: 2,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon ??
                (obscureText
                    ? IconButton(
                        icon: Icon(
                          hideText.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          hideText.value = !hideText.value;
                        },
                      )
                    : null),
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.white.withAlpha(60),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Segoe UI',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: AppColors.white.withAlpha(100),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: AppColors.white.withAlpha(100),
              ),
            ),
            labelStyle: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Segoe UI',
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: readOnly
                  ?  BorderSide(
                      color: AppColors.defaultLime.withAlpha(100),
                    )
                  : BorderSide(
                      color: AppColors.defaultLime.withAlpha(100),
                    ),
            ),
            filled: true,
            fillColor: fillColor ?? AppColors.black,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: AppColors.error400.withAlpha(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
