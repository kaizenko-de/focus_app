import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/router/app_router.dart';
import 'package:focus/src/shared/providers/journey_provider.dart';
import 'package:focus/src/shared/providers/routines_provider.dart';
import 'package:focus/src/shared/providers/suppliments_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime selectedDate;

  late PageController _yearPageCtrl;
  late PageController _monthPageCtrl;
  late PageController _dayPageCtrl;

  static const int _startYear = 2015;
  static const int _infiniteOffset = 500;

  final List<String> _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    _yearPageCtrl = PageController(
      viewportFraction: 0.2,
      initialPage: (selectedDate.year - _startYear) + (_infiniteOffset * 30),
    );
    _monthPageCtrl = PageController(
      viewportFraction: 0.16,
      initialPage: (selectedDate.month - 1) + (_infiniteOffset * 12),
    );
    _dayPageCtrl = PageController(
      viewportFraction: 0.11,
      initialPage: (selectedDate.day - 1) + (_infiniteOffset * 31),
    );
  }

  @override
  void dispose() {
    _yearPageCtrl.dispose();
    _monthPageCtrl.dispose();
    _dayPageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainStreak = ref.watch(mainStreakProvider);
    final todaysEntry = ref.watch(todaysEntryProvider);
    final routinesAsync = ref.watch(routineProvider);
    final supplementsAsync = ref.watch(supplementProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: routinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (routines) => supplementsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (supplements) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH32,
                _buildDatePicker(),
                gapH16,
                _divider(margin: 20),
                gapH24,
                _buildCurrentStreak(mainStreak, todaysEntry, context),
                gapH24,
                _divider(margin: 20),
                gapH24,
                _buildStatsFlat(),
                gapH32,
                _buildTrackingCards(todaysEntry, routines, supplements),
                gapH48,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────── DATE PICKER ───────────────────

  Widget _buildDatePicker() {
    final entriesAsync = ref.watch(journalProvider);
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

    // Default empty list for entries
    final entries = entriesAsync.whenData((data) => data).valueOrNull ?? [];

    return Column(
      children: [
        _snapPicker(
          controller: _yearPageCtrl,
          height: 32,
          onPageChanged: (index) {
            final year = _startYear + (index % 30);
            if (selectedDate.year != year) {
              HapticFeedback.lightImpact();
              setState(
                () => selectedDate = DateTime(
                  year,
                  selectedDate.month,
                  selectedDate.day,
                ),
              );
            }
          },
          itemBuilder: (index, isSelected) =>
              _pickerText((_startYear + (index % 30)).toString(), isSelected),
        ),
        const SizedBox(height: 4),
        _snapPicker(
          controller: _monthPageCtrl,
          height: 32,
          onPageChanged: (index) {
            final month = (index % 12) + 1;
            if (selectedDate.month != month) {
              HapticFeedback.lightImpact();
              int d = selectedDate.day;
              int maxD = DateTime(selectedDate.year, month + 1, 0).day;
              setState(
                () => selectedDate = DateTime(
                  selectedDate.year,
                  month,
                  d > maxD ? maxD : d,
                ),
              );
            }
          },
          itemBuilder: (index, isSelected) =>
              _pickerText(_months[index % 12], isSelected),
        ),
        const SizedBox(height: 4),
        _snapPicker(
          controller: _dayPageCtrl,
          height: 48,
          onPageChanged: (index) {
            final day = (index % daysInMonth) + 1;
            if (selectedDate.day != day) {
              HapticFeedback.lightImpact();
              setState(
                () => selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  day,
                ),
              );
            }
          },
          itemBuilder: (index, isSelected) {
            final day = (index % daysInMonth) + 1;
            final checkDate = DateTime(
              selectedDate.year,
              selectedDate.month,
              day,
            );

            // Check if this day is a perfect day
            final isPerfectDay = entries.any((e) {
              return e.date.year == checkDate.year &&
                  e.date.month == checkDate.month &&
                  e.date.day == checkDate.day &&
                  e.isPerfectDay &&
                  e.isSubmitted;
            });

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pickerDay(day.toString(), isSelected),
                Text(
                  (!isPerfectDay) ? '' : '⭐',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _snapPicker({
    required PageController controller,
    required double height,
    required Function(int) onPageChanged,
    required Widget Function(int, bool) itemBuilder,
  }) {
    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: controller,
        onPageChanged: onPageChanged,
        physics: const BouncingScrollPhysics(),
        padEnds: true,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double page = 0;
              try {
                page = controller.page ?? controller.initialPage.toDouble();
              } catch (_) {
                page = controller.initialPage.toDouble();
              }
              double distance = (page - index).abs();
              double opacity = (1.0 - distance * 0.7).clamp(0.3, 1.0);
              bool isSelected = distance < 0.5;

              return Opacity(
                opacity: opacity,
                child: itemBuilder(index, isSelected),
              );
            },
          );
        },
      ),
    );
  }

  Widget _pickerText(String text, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSelected ? 13 : 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 2),
            height: 1.5,
            width: 14,
            color: Colors.white,
          ),
      ],
    );
  }

  Widget _pickerDay(String text, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSelected ? 12 : 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 2),
            height: 1.5,
            width: 14,
            color: Colors.white,
          ),
      ],
    );
  }

  // ─────────────────── CURRENT STREAK ───────────────────

  Widget _buildCurrentStreak(
    int mainStreak,
    JournalEntry? todaysEntry,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CURRENT STREAK',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              gapH4,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mainStreak.toString(),
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                  gapW8,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'days',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              if (todaysEntry == null) {
                context.pushNamed(AppRoutes.eodFlow.name);
              } else {
                context.pushNamed(AppRoutes.dayCompleted.name);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 34),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── STATS ───────────────────

  Widget _buildStatsFlat() {
    final bestStreak = ref.watch(bestStreakProvider);
    final perfectDaysCount = ref.watch(perfectDaysCountProvider);
    final perfectDaysCurrentMonth = ref.watch(perfectDaysCurrentMonthProvider);
    final avgPerfectDaysPerMonth = ref.watch(avgPerfectDaysPerMonthProvider);

    Widget stat(String title, String value) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            gapH4,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const TextSpan(
                    text: '  days',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stat('BEST STREAK (ALL-TIME)', bestStreak.toString()),
              stat('PERFECT DAYS (YEAR)', perfectDaysCount.toString()),
            ],
          ),
          gapH24,
          _divider(),
          gapH24,
          Row(
            children: [
              stat('CURRENT MONTH', perfectDaysCurrentMonth.toString()),
              stat(
                'AVG. PERFECT/MONTH',
                avgPerfectDaysPerMonth.toStringAsFixed(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────── TRACKING CARDS ───────────────────

  Widget _buildTrackingCards(
    JournalEntry? todaysEntry,
    List<Routine> routines,
    List<Supplement> supplements,
  ) {
    final completedRoutines = todaysEntry?.routineIds.length ?? 0;
    final completedSupplements = todaysEntry?.supplementIds.length ?? 0;

    final routineProgress = routines.isEmpty
        ? 0.0
        : completedRoutines / routines.length;
    final supplementProgress = supplements.isEmpty
        ? 0.0
        : completedSupplements / supplements.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
      child: Column(
        children: [
          _trackingCard(
            icon: Assets.images.routines,
            title: 'Routines',
            subtitle:
                '${(routineProgress * 100).toStringAsFixed(0)}% completed',
            value: '$completedRoutines/${routines.length}',
            progress: routineProgress,
          ),
          gapH24,
          _trackingCard(
            icon: Assets.images.suppliments,
            title: 'Supplements',
            subtitle: '${(supplementProgress * 100).toStringAsFixed(0)}% taken',
            value: '$completedSupplements/${supplements.length}',
            progress: supplementProgress,
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
              gapW16,
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
          gapH16,
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

  Widget _divider({double? margin}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
      height: 1.2,
      color: AppColors.bgSecondary.withOpacity(0.2),
    );
  }
}

const gapH4 = SizedBox(height: 4);
const gapH16 = SizedBox(height: 16);
const gapH24 = SizedBox(height: 24);
const gapH32 = SizedBox(height: 32);
const gapH48 = SizedBox(height: 48);
const gapW8 = SizedBox(width: 8);
const gapW16 = SizedBox(width: 16);
