import 'package:flutter/material.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/shared/providers/routines_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/router/app_router.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routineProvider);
    final routinesByTimeAsync = ref.watch(routinesByTimeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Routines',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: routinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        data: (routines) {
          if (routines.isEmpty) {
            // EMPTY STATE
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
                      child: Assets.images.routines.image(
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  gapH12,
                  const Text(
                    'Your Routines are clean',
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
                      'You haven’t defined any daily routines yet. Please click below to add new routines.',
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
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      context.pushNamed(AppRoutes.routineEdit.name);
                    },
                    label: const Text(
                      'Add New Routine',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // NON-EMPTY STATE
          return routinesByTimeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Error: $err',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            data: (routinesByTime) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p20,
                Sizes.p16,
                Sizes.p20,
                120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: routinesByTime.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Sizes.p8),
                      ...entry.value.map((routine) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Sizes.p8),
                          child: _RoutineCard(
                            routine: routine,
                            context: context,
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      // SHOW FLOATING BUTTON ONLY WHEN ROUTINES ARE NOT EMPTY
      floatingActionButton: routinesAsync.maybeWhen(
        data: (routines) => routines.isNotEmpty
            ? FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                onPressed: () {
                  context.pushNamed(AppRoutes.routineEdit.name);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                label: const Text(
                  'New Routine',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                icon: const Icon(Icons.add),
              )
            : null,
        orElse: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final Routine routine;
  final BuildContext context;

  const _RoutineCard({required this.routine, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.routineEdit.name, extra: routine.id);
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
                child: Text(routine.icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: Sizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${routine.timeOfDay} • ${routine.duration}',
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
