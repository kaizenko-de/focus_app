import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus/src/shared/providers/journey_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:focus/src/router/app_router.dart';
import 'package:go_router/go_router.dart';

class JournalHistoryScreen extends HookConsumerWidget {
  const JournalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(journalProvider);
    final mainStreak = ref.watch(mainStreakProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Header with Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
              color: AppColors.bg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Sizes.p20),
                  const Text(
                    'Journal History',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'Reflecting on your consistency',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Sizes.p24),
                ],
              ),
            ),
            // Fixed Streak Section with Sticky Effect
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
              color: AppColors.bg,
              child: Column(
                children: [
                  _buildStreakSection(mainStreak),
                  const SizedBox(height: Sizes.p24),
                ],
              ),
            ),
            // Scrollable Entries
            Expanded(
              child: entries.when(
                data: (entryList) {
                  final submittedEntries =
                      entryList.where((e) => e.isSubmitted).toList()
                        ..sort((a, b) => b.date.compareTo(a.date));
                  if (submittedEntries.isEmpty) {
                    return Center(
                      child: Text(
                        'No journal entries yet',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.p20,
                      Sizes.p20,
                      Sizes.p20,
                      Sizes.p32,
                    ),
                    itemCount: submittedEntries.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: Sizes.p16),
                    itemBuilder: (context, index) {
                      return _HistoryCard(
                        entry: submittedEntries[index],
                        context: context,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    'Failed to load journal entries',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakSection(int currentStreak) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '30-DAY STREAK',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
            Text(
              '$currentStreak Days',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: Sizes.p12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (currentStreak / 30).clamp(0.0, 1.0),
            minHeight: 6,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            backgroundColor: AppColors.bgBorderSecondary,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final JournalEntry entry;
  final BuildContext context;

  const _HistoryCard({required this.entry, required this.context});

  @override
  Widget build(BuildContext context) {
    final topWin = entry.wins.isNotEmpty
        ? entry.wins
              .firstWhere(
                (w) => w.isHighlighted,
                orElse: () => entry.wins.first,
              )
              .text
        : 'No wins recorded';

    final daysAgo = DateTime.now().difference(entry.date).inDays;
    final dateLabel = daysAgo == 0
        ? 'TODAY'
        : daysAgo == 1
        ? 'YESTERDAY'
        : _getDayLabel(entry.date);

    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.journal.name, extra: entry.id);
      },
      child: Container(
        padding: const EdgeInsets.all(Sizes.p16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateLabel,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  _getDateStr(entry.date),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.p8),
            Text(
              'TOP WIN',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: Sizes.p8),
            Text(
              topWin,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: Sizes.p10),
            Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: Sizes.p4),
                Text(
                  'Show ${entry.wins.length > 1 ? entry.wins.length - 1 : 0} more Achievements',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDayLabel(DateTime date) {
    final days = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];
    return days[date.weekday - 1];
  }

  String _getDateStr(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}';
  }
}
