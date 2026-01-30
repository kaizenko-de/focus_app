import 'package:flutter/material.dart';
import 'package:focus/src/shared/providers/suppliments_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/router/app_router.dart';

class SupplementsScreen extends ConsumerWidget {
  const SupplementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplements = ref.watch(supplementProvider);
    final supplementsByTime = ref.watch(supplementsByTimeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Supplements',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: supplements.isEmpty
          ? const Center(
              child: Text(
                'No supplements added',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p20,
                Sizes.p16,
                Sizes.p20,
                120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: supplementsByTime.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: Sizes.p12),
                      ...entry.value.map((supplement) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Sizes.p12),
                          child: _SupplementCard(supplement: supplement),
                        );
                      }),
                      const SizedBox(height: Sizes.p24),
                    ],
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context.pushNamed(AppRoutes.supplementEdit.name);
        },
        label: const Text(
          'Add Supplement',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SupplementCard extends StatelessWidget {
  final Supplement supplement;

  const _SupplementCard({required this.supplement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.supplementEdit.name, extra: supplement.id);
      },
      child: Container(
        padding: const EdgeInsets.all(Sizes.p16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.bgBorderSecondary),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(supplement.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: Sizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplement.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    supplement.dosage,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                border: Border.all(color: AppColors.bgBorderSecondary),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: const Icon(
                  Icons.chevron_right,
                  size: 21,
                  color: AppColors.textgrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
