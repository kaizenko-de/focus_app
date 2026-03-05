import 'package:flutter/material.dart';
import 'package:focus/constants/app_colors.dart';

/// A custom dropdown button widget
class AppDropButton extends StatelessWidget {
  const AppDropButton({
    super.key,
    required this.hintText,
    required this.options,
    this.selectedValue,
    required this.onChanged,
    this.onTap,
    this.isError = false,
    this.disabled,
    this.backgroundColor,
  });

  /// The hint text to display when no option is selected
  final String hintText;

  /// The list of options to display in the dropdown
  final List<String> options;

  /// The currently selected value
  final String? selectedValue;

  /// Callback function to be called when an option is selected
  final ValueChanged<String?> onChanged;

  /// Flag to indicate if there's an error (to display error styling)
  final bool isError;

  /// Callback function to be called when the dropdown is tapped
  final void Function()? onTap;

  final bool? disabled;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Segoe UI',
          ),
          filled: true,
          fillColor: backgroundColor ?? AppColors.defaultBlack,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: isError
                  ? Colors.red
                  : AppColors.defaultLime.withAlpha(100),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: isError
                  ? Colors.red
                  : AppColors.defaultLime.withAlpha(100),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: isError
                  ? Colors.red
                  : AppColors.defaultLime.withAlpha(100),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: isError
                  ? Colors.red
                  : AppColors.defaultLime.withAlpha(100),
            ),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            onTap: onTap,
            hint: Text(
              hintText,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Segoe UI',
              ),
            ),
            value: selectedValue,
            items: disabled ?? false
                ? []
                : options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            onChanged: disabled ?? false ? null : onChanged,
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: AppColors.defaultBlack,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
