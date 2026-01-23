
import 'package:flutter/material.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/shared/widgets/primary_button.dart';
import 'package:focus/src/theme/custom_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteDialog extends HookConsumerWidget {
  const DeleteDialog({
    super.key,
    required this.title,
    required this.buttonTextOne,
    required this.buttonTextTwo,
    required this.onButtonOnePressed,
    required this.onButtonTwoPressed,
    this.isButtonLoading,
  });

  final String title;
  final String buttonTextOne;
  final String buttonTextTwo;
  final VoidCallback onButtonOnePressed;
  final VoidCallback onButtonTwoPressed;
  final bool? isButtonLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 400,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title).textmdRegular.alignText(TextAlign.center),
            gapH32,
            Row(
              children: [
                OutlinedButton(
                  onPressed: onButtonOnePressed,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(130, 40),
                    backgroundColor: AppColors.defaultLime.withAlpha(10),
                    foregroundColor: AppColors.defaultLime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.p48),
                    ),
                  ),
                  child: Text(buttonTextOne).textmdRegular,
                ),
                Spacer(),
                PrimaryButton(
                  isLoading: isButtonLoading ?? false,
                  height: 40,
                  width: 130,
                  onPressed: onButtonTwoPressed,
                  text: buttonTextTwo,
                  fontSize: Sizes.p16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
