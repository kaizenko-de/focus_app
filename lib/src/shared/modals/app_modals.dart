import 'package:flutter/material.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';

/// Shows a confirmation modal for unsaved changes
/// Returns true if the user wants to discard changes, false if they want to keep editing
Future<bool?> showUnsavedChangesModal(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _UnsavedChangesModal(),
  );
}

/// Shows a confirmation modal for deleting an item
/// Returns true if the user confirms deletion, false otherwise
Future<bool?> showDeleteConfirmationModal(
  BuildContext context, {
  required String deleteType,
  required String itemName,
  String? subtitle,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _DeleteConfirmationModal(
      deleteType: deleteType,
      itemName: itemName,
      subtitle: subtitle,
    ),
  );
}

class _UnsavedChangesModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Unsaved Changes?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Sizes.p12),
            const Text(
              "Your daily reflection hasn't been saved yet. If you leave now, your progress will be lost.",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.p24),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      border: Border.all(color: AppColors.bgBorderSecondary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: const Text(
                        'Keep Editing',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                gapH10,
                GestureDetector(
                  onTap: () => Navigator.pop(context, true),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      border: Border.all(color: AppColors.bgBorderSecondary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: const Text(
                        'Discard Changes',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                gapH10,
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.bgBorderSecondary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteConfirmationModal extends StatelessWidget {
  final String deleteType;
  final String itemName;
  final String? subtitle;

  const _DeleteConfirmationModal({
    required this.deleteType,
    required this.itemName,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete $deleteType',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Sizes.p12),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Are you sure you want to delete ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: '"$itemName"',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' from your stack? This action cannot be undone and will remove it from your daily log.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // 👈 this is the key
            ),

            /*    if (subtitle != null) ...[
              const SizedBox(height: Sizes.p8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ], */
            const SizedBox(height: Sizes.p24),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, true),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: AppColors.bgBorderSecondary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                gapH10,
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.bgBorderSecondary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
