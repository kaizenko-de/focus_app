import 'package:flutter/material.dart';
import 'package:focus/gen/assets.gen.dart';
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
    final supplementsAsync = ref.watch(supplementProvider);
    final supplementsByTimeAsync = ref.watch(supplementsByTimeProvider);

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
      body: supplementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        data: (supplements) {
          if (supplements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 80,
                    width: 80,
                    child: Center(
                      child: Assets.images.suppliments.image(
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  gapH12,
                  const Text(
                    'No supplements found',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  gapH8,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'You haven’t added any supplements to your daily routine yet. Please click below button for add new Supplements.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gapH16,
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed(AppRoutes.supplementEdit.name);
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add New Supplement',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // NON-EMPTY STATE
          return supplementsByTimeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Error: $err',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            data: (supplementsByTime) => SingleChildScrollView(
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
                          child: _SupplementCard(
                            supplement: supplement,
                            context: context,
                          ),
                        );
                      }),
                      const SizedBox(height: Sizes.p24),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      // Show floating button only if supplements exist
      floatingActionButton: supplementsAsync.maybeWhen(
        data: (supplements) => supplements.isNotEmpty
            ? FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                onPressed: () {
                  context.pushNamed(AppRoutes.supplementEdit.name);
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Supplement',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            : null,
        orElse: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SupplementCard extends StatelessWidget {
  final Supplement supplement;
  final BuildContext context;

  const _SupplementCard({required this.supplement, required this.context});

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
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.bgBorderSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  supplement.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
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
              child: const Center(
                child: Icon(
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
