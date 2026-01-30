import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/shared/providers/journey_provider.dart';
import 'package:focus/src/theme/custom_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';

// --- Main Screen ---

class JournalScreen extends HookConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(journalProvider);
    // Display the most recent entry (read-only)
    final entry = entries.isNotEmpty ? entries.first : null;

    if (entry == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Text(
            'No journal entries yet',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return _JournalDetailView(entry: entry);
  }
}

class _JournalDetailView extends StatefulWidget {
  final JournalEntry entry;

  const _JournalDetailView({required this.entry});

  @override
  State<_JournalDetailView> createState() => _JournalDetailViewState();
}

class _JournalDetailViewState extends State<_JournalDetailView> {
  late bool _expandedGratitude;
  late bool _expandedAffirmation;
  late bool _expandedNotes;

  @override
  void initState() {
    super.initState();
    _expandedGratitude = false;
    _expandedAffirmation = false;
    _expandedNotes = false;
  }

  @override
  Widget build(BuildContext context) {
    final moods = ['😢', '☹️', '😐', '🙂', '😄'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        automaticallyImplyLeading: false,
        title: TextButton(
          child: Text("Cancel").textmdMedium.foregroundColor(Colors.white),
          onPressed: () async {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.p8),
            _buildDateHeader(),

            const SizedBox(height: Sizes.p12),
            _buildMoodDisplay(moods[widget.entry.moodIndex]),

            _buildSectionHeader('REFLECTION'),
            const SizedBox(height: Sizes.p12),

            _buildMoodSelector(widget.entry.moodIndex),
            const SizedBox(height: Sizes.p24),
            _buildReadOnlyCard('GRATITUDE', widget.entry.gratitude),
            const SizedBox(height: Sizes.p24),
            _buildWinsDisplay(),
            const SizedBox(height: Sizes.p24),
            _buildReadOnlyCard('AFFIRMATION', widget.entry.affirmation),
            const SizedBox(height: Sizes.p32),
            _buildSectionHeader('TRACKING'),
            const SizedBox(height: Sizes.p24),
            _buildTrackingDisplay(),
            const SizedBox(height: Sizes.p24),
            if (widget.entry.notes.isNotEmpty)
              _buildReadOnlyCard('NOTES', widget.entry.notes),
            const SizedBox(height: Sizes.p32),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    final date = widget.entry.date;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: Sizes.p8),
      ],
    );
  }

  Widget _buildMoodSelector(int selectedMood) {
    final moods = [
      Assets.images.veryDissatified,
      Assets.images.dissatisfied,
      Assets.images.neutral,
      Assets.images.satisfied,
      Assets.images.verysatisfied,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.p20,
        horizontal: Sizes.p16,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,

        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bgBorderSecondary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(moods.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 25,
            height: 25,

            child: moods[index].image(
              color: index == selectedMood
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMoodDisplay(String mood) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.p12,
        horizontal: Sizes.p16,
      ),
      // decoration: BoxDecoration(
      //   color: AppColors.bgCard,
      //   borderRadius: BorderRadius.circular(16),
      // ),
      child: Center(
        child: Column(
          children: [
            Text(mood, style: const TextStyle(fontSize: 56)),

            const Text(
              'Relaxed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(
              'Evening Mood',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyCard(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Sizes.p12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Sizes.p16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            content,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWinsDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THREE WINS',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Sizes.p12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.entry.wins.length,
            separatorBuilder: (_, __) => const Divider(
              color: AppColors.bgBorderSecondary,
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final win = widget.entry.wins[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                  vertical: Sizes.p16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.bgBorderSecondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Sizes.p12),
                    Expanded(
                      child: Text(
                        win.text,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (win.isHighlighted)
                      const Icon(Icons.star, color: AppColors.accent, size: 18),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingDisplay() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(Sizes.p16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ROUTINES',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: Sizes.p12),
                Text(
                  widget.entry.routineIds.length.toString(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'completed',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: Sizes.p12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(Sizes.p16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SUPPLEMENTS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: Sizes.p12),
                Text(
                  widget.entry.supplementIds.length.toString(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'taken',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: Sizes.p16),
        const Expanded(
          child: Divider(color: AppColors.bgBorderSecondary, thickness: 1),
        ),
      ],
    );
  }
}
