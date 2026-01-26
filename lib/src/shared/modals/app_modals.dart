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
  required String itemName,
  String? subtitle,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _DeleteConfirmationModal(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unsaved Changes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Sizes.p12),
            const Text(
              'You have unsaved changes. Are you sure you want to discard them?',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: Sizes.p24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'Keep Editing',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: Sizes.p12),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text(
                    'Discard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
  final String itemName;
  final String? subtitle;

  const _DeleteConfirmationModal({
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
            const Text(
              'Delete Item',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Sizes.p12),
            Text(
              'Are you sure you want to delete "$itemName"?',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: Sizes.p8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: Sizes.p24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: Sizes.p12),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
