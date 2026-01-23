
import 'package:flutter/material.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/theme/custom_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrimaryDialog extends HookConsumerWidget {
  const PrimaryDialog({
    super.key,
    this.icon,
    required this.title,
    required this.buttonOne,
    this.buttonTwo,
    this.child,
  });

  /// Optional icon widget displayed above the title
  final Widget? icon;

  /// Title of the dialog
  final String title;

  /// First button (required)
  final Widget buttonOne;

  /// Second button (optional)
  final Widget? buttonTwo;

  /// Optional child widget displayed between the title and the buttons
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          color: AppColors.defaultBlack,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.defaultLime.withAlpha(10),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            // Main dialog content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  gapH16,
                ],
                // Title
                Text(
                  title,
                ).textmdRegular.alignText(TextAlign.center),
                if (child != null) ...[
                  gapH16,
                  child!,
                ],
                gapH32,
                if (buttonTwo == null)
                  SizedBox(
                    width: double.infinity,
                    child: buttonOne,
                  )
                else
                  Row(
                    children: [
                      Expanded(child: buttonOne),
                      gapW16,
                      Expanded(child: buttonTwo!),
                    ],
                  ),
              ],
            ),
            // X button in the top right
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  splashRadius: 20,
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  tooltip: 'Close',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
