import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/shared/providers/journey_provider.dart';
import 'package:focus/src/shared/providers/routines_provider.dart';
import 'package:focus/src/shared/providers/suppliments_provider.dart';
import 'package:focus/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class DayCompletedScreen extends ConsumerWidget {
  const DayCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysEntry = ref.watch(todaysEntryProvider);
    final routinesAsync = ref.watch(routineProvider);
    final supplementsAsync = ref.watch(supplementProvider);

    if (todaysEntry == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Back'),
          ),
        ),
      );
    }

    return routinesAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (routines) => supplementsAsync.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error: $err'))),
        data: (supplements) {
          final completedRoutines = todaysEntry.routineIds.length;
          final completedSupplements = todaysEntry.supplementIds.length;
          final routineProgress = routines.isEmpty
              ? 0.0
              : completedRoutines / routines.length;
          final supplementProgress = supplements.isEmpty
              ? 0.0
              : completedSupplements / supplements.length;

          return Scaffold(
            backgroundColor: AppColors.bg,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gapH24,

                  // ───────── HEADER ─────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            'Today Completed',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.success,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
                    child: Text(
                      _getDateString(todaysEntry.date),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  gapH16,

                  // ───────── EDIT BUTTON ─────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.pushNamed(AppRoutes.eodFlow.name),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit Today\'s EoD'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  gapH24,

                  // ───────── STAR ─────────
                  if (todaysEntry.isPerfectDay)
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svg.star),

                          gapH16,

                          // ───────── PERFECT DAY ─────────
                          const Text(
                            'Perfect Day',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          gapH8,
                          SvgPicture.asset(Assets.svg.gradientLine),
                        ],
                      ),
                    ),

                  gapH48,
                  _buildTrackingCards(
                    completedRoutines,
                    routines.length,
                    completedSupplements,
                    supplements.length,
                  ),

                  // ───────── CARDS ─────────
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDateString(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[date.weekday - 1]}, ${date.day}th of ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildTrackingCards(
    int completedRoutines,
    int totalRoutines,
    int completedSupplements,
    int totalSupplements,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
      child: Column(
        children: [
          _trackingCard(
            icon: Assets.images.routines,
            title: 'Routines',
            subtitle:
                '${(completedRoutines / totalRoutines * 100).toStringAsFixed(0)}% completed',
            value: '$completedRoutines/$totalRoutines',
            progress: totalRoutines == 0
                ? 0.0
                : completedRoutines / totalRoutines,
          ),
          gapH24,
          _trackingCard(
            icon: Assets.images.suppliments,
            title: 'Supplements',
            subtitle:
                '${(completedSupplements / totalSupplements * 100).toStringAsFixed(0)}% taken',
            value: '$completedSupplements/$totalSupplements',
            progress: totalSupplements == 0
                ? 0.0
                : completedSupplements / totalSupplements,
          ),
        ],
      ),
    );
  }

  Widget _trackingCard({
    required AssetGenImage icon,
    required String title,
    required String subtitle,
    required String value,
    required double progress,
  }) {
    return Container(
      height: 119,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bgBorderSecondary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgBorderSecondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: icon.image(
                  width: 24,
                  height: 24,
                  color: AppColors.iconGrey,
                ),
              ),
              const SizedBox(width: Sizes.p16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.p16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bgBorderSecondary,
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────
}

const gapH4 = SizedBox(height: 4);
const gapH8 = SizedBox(height: 8);
const gapH16 = SizedBox(height: 16);
const gapH24 = SizedBox(height: 24);
const gapH48 = SizedBox(height: 48);
