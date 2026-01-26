import 'package:flutter/material.dart';
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
    final routines = ref.watch(routineProvider);
    final routinesByTime = ref.watch(routinesByTimeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Routines',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: routines.isEmpty
          ? const Center(
              child: Text(
                'No routines added',
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
                children: routinesByTime.entries.map((entry) {
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
                      ...entry.value.map((routine) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Sizes.p12),
                          child: _RoutineCard(routine: routine),
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
          context.pushNamed(AppRoutes.routineEdit.name);
        },
        label: const Text(
          'New Routine',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final Routine routine;

  const _RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.routineEdit.name,
          extra: routine.id,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(Sizes.p16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(routine.icon, style: const TextStyle(fontSize: 24)),
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
                      fontWeight: FontWeight.bold,
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
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
