import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Haptics
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/router/app_router.dart';
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
      viewportFraction: 0.14,
      initialPage: (selectedDate.year - _startYear) + (_infiniteOffset * 30),
    );
    _monthPageCtrl = PageController(
      viewportFraction: 0.12,
      initialPage: (selectedDate.month - 1) + (_infiniteOffset * 12),
    );
    _dayPageCtrl = PageController(
      viewportFraction: 0.095,
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
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH32,
            _buildDatePicker(),
            gapH16,
            _divider(margin: 20),
            gapH24,
            _buildCurrentStreak(),
            gapH24,
            _divider(margin: 20),
            gapH24,
            _buildStatsFlat(),
            gapH32,
            _buildTrackingCards(),
            gapH48,
          ],
        ),
      ),
    );
  }

  // ─────────────────── DATE PICKER ───────────────────

  Widget _buildDatePicker() {
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

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
        // Day Picker: Key removed to prevent the "multiple PageViews" error
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
            // The ⭐ from your screenshot logic
            // final hasStar = {1, 2, 3, 4, 5, 7, 8, 9, 10, 11}.contains(day);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pickerDay(day.toString(), isSelected),
                Text(
                  isSelected ? '' : '⭐',
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
        itemBuilder: (context, index) {
          // Optimized selection check to avoid controller position conflicts
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

  // ─────────────────── RETAINED ORIGINAL UI ───────────────────

  Widget _buildCurrentStreak() {
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
                  const Text(
                    '14',
                    style: TextStyle(
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
              context.pushNamed(AppRoutes.eodFlow.name);
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

  Widget _buildStatsFlat() {
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
              stat('BEST STREAK (ALL-TIME)', '42'),
              stat('BEST STREAK (2024)', '28'),
            ],
          ),
          gapH24,
          _divider(),
          gapH24,
          Row(
            children: [
              stat('PERFECT DAYS (YEAR)', '184'),
              stat('AVG. PERFECT/MONTH', '22.4'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
      child: Column(
        children: [
          _trackingCard(
            icon: Assets.images.routines,
            title: 'Routines',
            subtitle: '70% completed',
            value: '4/5',
            progress: 0.7,
          ),
          gapH24,
          _trackingCard(
            icon: Assets.images.suppliments,
            title: 'Supplements',
            subtitle: '50% taken',
            value: '2/4',
            progress: 0.5,
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
