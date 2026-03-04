import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/router/app_router.dart';
import 'package:focus/src/shared/providers/journey_provider.dart';
import 'package:focus/src/shared/providers/routines_provider.dart';
import 'package:focus/src/shared/providers/suppliments_provider.dart';
import 'package:focus/src/theme/custom_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';

import 'package:go_router/go_router.dart';

class EoDFlowScreen extends HookConsumerWidget {
  const EoDFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftState = ref.watch(draftJournalProvider);
    final routinesAsync = ref.watch(routineProvider);
    final supplementsAsync = ref.watch(supplementProvider);
    final todaysEntry = ref.watch(todaysEntryProvider);

    // Initialize draft with existing entry if available (edit mode) - run only once on first load
    final hasInitialized = useRef(false);

    useEffect(() {
      if (!hasInitialized.value &&
          todaysEntry != null &&
          draftState.gratitude.isEmpty &&
          draftState.affirmation.isEmpty &&
          draftState.wins.isEmpty) {
        hasInitialized.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(draftJournalProvider.notifier)
              .loadExistingEntry(todaysEntry);
        });
      }
      return null;
    }, []);

    return WillPopScope(
      onWillPop: () async {
        if (draftState.hasChanges) {
          return await _showUnsavedChangesDialog(context, ref);
        }
        return true;
      },
      child: routinesAsync.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error: $err'))),
        data: (routines) => supplementsAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              Scaffold(body: Center(child: Text('Error: $err'))),
          data: (supplements) => _buildEoDFlow(
            context,
            ref,
            draftState,
            routines,
            supplements,
            todaysEntry,
          ),
        ),
      ),
    );
  }

  Widget _buildEoDFlow(
    BuildContext context,
    WidgetRef ref,
    DraftJournalEntry draftState,
    List<Routine> routines,
    List<Supplement> supplements,
    JournalEntry? existingEntry,
  ) {
    final isEditMode = existingEntry != null;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        automaticallyImplyLeading: false,
        title: TextButton(
          child: Text("Cancel").textmdMedium.foregroundColor(Colors.white),
          onPressed: () async {
            if (draftState.hasChanges) {
              final shouldDiscard = await _showUnsavedChangesDialog(
                context,
                ref,
              );
              if (shouldDiscard) {
                context.pop();
              }
            } else {
              context.pop();
            }
          },
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
            child: Center(
              child: GestureDetector(
                onTap: () => _saveEoD(context, ref),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH16,
            Text(
              isEditMode ? 'Edit today\'s EoD' : 'End of Day',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            gapH8,
            Text(
              _getDateString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            gapH24,
            _buildSectionHeader('REFLECTION'),
            gapH8,
            _buildSectionHeader('MOOD', divider: false),
            gapH8,

            _buildMoodSelector(ref, draftState),
            gapH24,
            _buildGratitudeSection(ref, draftState),
            gapH24,
            _buildThreeWinsSection(ref, draftState),
            gapH24,
            _buildAffirmationSection(ref, draftState),
            gapH32,
            _buildSectionHeader('TRACKING'),
            gapH24,
            _buildRoutinesChecklist(routines, draftState, ref),
            gapH24,
            _buildSupplementsChecklist(supplements, draftState, ref),
            gapH24,
            _buildNotesSection(ref, draftState),
            gapH32,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool? divider = true}) {
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
        if (divider == true) ...[
          const SizedBox(width: Sizes.p16),
          const Expanded(
            child: Divider(color: AppColors.bgBorderSecondary, thickness: 1),
          ),
        ],
      ],
    );
  }

  Widget _buildMoodSelector(WidgetRef ref, DraftJournalEntry draft) {
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
          final isSelected = index == draft.moodIndex;
          return GestureDetector(
            onTap: () => ref.read(draftJournalProvider.notifier).setMood(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 25,
              height: 25,

              child: moods[index].image(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGratitudeSection(WidgetRef ref, DraftJournalEntry draft) {
    final controller = useTextEditingController(text: draft.gratitude);

    // Sync controller with draft state changes
    useEffect(() {
      if (controller.text != draft.gratitude) {
        controller.text = draft.gratitude;
      }
      return null;
    }, [draft.gratitude]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GRATITUDE',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        gapH12,
        Container(
          padding: const EdgeInsets.all(Sizes.p16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            onChanged: (val) =>
                ref.read(draftJournalProvider.notifier).setGratitude(val),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: 'What are you grateful for today?',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              contentPadding: EdgeInsets.zero,
              isCollapsed: true,
              isDense: true,
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildThreeWinsSection(WidgetRef ref, DraftJournalEntry draft) {
    // Create display list with exactly 3 slots
    final displayWins = List.generate(3, (i) {
      if (i < draft.wins.length) {
        return draft.wins[i];
      } else {
        return Win(id: 'empty_$i', text: '', isHighlighted: false);
      }
    });

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
        gapH12,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(),
          itemBuilder: (context, index) {
            final win = displayWins[index];
            final isExistingWin = index < draft.wins.length;

            return _WinCard(
              win: win,
              index: index + 1,
              onToggleHighlight: () {
                if (isExistingWin) {
                  ref
                      .read(draftJournalProvider.notifier)
                      .toggleWinHighlight(win.id);
                }
              },
              onTextChanged: (text) {
                if (isExistingWin) {
                  ref
                      .read(draftJournalProvider.notifier)
                      .updateWinText(win.id, text);
                } else if (text.isNotEmpty) {
                  // Only add new win if text is not empty
                  ref
                      .read(draftJournalProvider.notifier)
                      .addWin(
                        Win(
                          id: 'win_${DateTime.now().millisecondsSinceEpoch}_$index',
                          text: text,
                          isHighlighted: false,
                        ),
                      );
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAffirmationSection(WidgetRef ref, DraftJournalEntry draft) {
    final controller = useTextEditingController(text: draft.affirmation);

    // Sync controller with draft state changes
    useEffect(() {
      if (controller.text != draft.affirmation) {
        controller.text = draft.affirmation;
      }
      return null;
    }, [draft.affirmation]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AFFIRMATION',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        gapH12,
        Container(
          padding: const EdgeInsets.all(Sizes.p16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            onChanged: (val) =>
                ref.read(draftJournalProvider.notifier).setAffirmation(val),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Write your affirmation...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRoutinesChecklist(
    List<Routine> routines,
    DraftJournalEntry draft,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ROUTINES',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        gapH12,
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: routines.isEmpty
              ? Container(
                  height: 116,
                  // width: 116,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Assets.images.routines.image(
                              height: 27,
                              width: 27,
                            ),
                          ),
                        ),
                        Text("No Routings added yet."),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: routines.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: AppColors.bgBorderSecondary,
                    height: 1,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    final routine = routines[index];
                    final isCompleted = draft.completedRoutines.contains(
                      routine.id,
                    );
                    return _ChecklistItem(
                      icon: routine.icon,
                      title: routine.name,
                      subtitle: '${routine.timeOfDay} • ${routine.duration}',
                      isCompleted: isCompleted,
                      onToggle: () => ref
                          .read(draftJournalProvider.notifier)
                          .toggleRoutineCompletion(routine.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSupplementsChecklist(
    List<Supplement> supplements,
    DraftJournalEntry draft,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUPPLEMENTS',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        gapH12,
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: supplements.isEmpty
              ? Container(
                  height: 116,
                  // width: 116,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Assets.images.suppliments.image(
                              height: 27,
                              width: 27,
                            ),
                          ),
                        ),
                        Text("No Routings tracked."),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: supplements.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: AppColors.bgBorderSecondary,
                    height: 1,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    final supplement = supplements[index];
                    final isTaken = draft.takenSupplements.contains(
                      supplement.id,
                    );
                    return _ChecklistItem(
                      icon: supplement.icon,
                      title: supplement.name,
                      subtitle: supplement.dosage,
                      isCompleted: isTaken,
                      onToggle: () => ref
                          .read(draftJournalProvider.notifier)
                          .toggleSupplementTaken(supplement.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(WidgetRef ref, DraftJournalEntry draft) {
    final controller = useTextEditingController(text: draft.notes);

    // Sync controller with draft state changes
    useEffect(() {
      if (controller.text != draft.notes) {
        controller.text = draft.notes;
      }
      return null;
    }, [draft.notes]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOTES',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        gapH12,
        Container(
          padding: const EdgeInsets.all(Sizes.p16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            minLines: 4,
            onChanged: (val) =>
                ref.read(draftJournalProvider.notifier).setNotes(val),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Anything else on your mind? Ideas, worries, todos...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              isCollapsed: true,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
        ),
      ],
    );
  }

  String _getDateString() {
    final now = DateTime.now();
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
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  void _saveEoD(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.read(routineProvider);
    final supplementsAsync = ref.read(supplementProvider);
    final draftNotifier = ref.read(draftJournalProvider.notifier);

    // Extract data from AsyncValue
    int totalRoutines = 0;
    int totalSupplements = 0;

    routinesAsync.whenData((routines) {
      totalRoutines = routines.length;
    });

    supplementsAsync.whenData((supplements) {
      totalSupplements = supplements.length;
    });

    // Submit the EoD (this saves it as an immutable journal entry)
    draftNotifier.submitEoD(
      totalRoutines: totalRoutines,
      totalSupplements: totalSupplements,
    );

    // Navigate to day completed screen
    context.pushReplacementNamed(AppRoutes.dayCompleted.name);
  }

  Future<bool> _showUnsavedChangesDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => _UnsavedChangesDialog(ref: ref),
        ) ??
        false;
  }
}

class _ChecklistItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onToggle;

  const _ChecklistItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p16,
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: Sizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                gapH4,
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  width: 2,
                ),
                color: isCompleted ? AppColors.primary : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnsavedChangesDialog extends StatelessWidget {
  final WidgetRef ref;

  const _UnsavedChangesDialog({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.bgBorderSecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            gapH24,
            const Text(
              'Unsaved Changes?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            gapH12,
            Text(
              "Your daily reflection hasn't been saved yet. If you leave now, your progress will be lost.",
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            gapH24,
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Save Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                gapH12,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(draftJournalProvider.notifier).reset();
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bgBorderSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Discard Changes',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                gapH12,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
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

final gapH4 = const SizedBox(height: 4);
final gapH8 = const SizedBox(height: 8);
final gapH12 = const SizedBox(height: 12);
final gapH16 = const SizedBox(height: 16);
final gapH24 = const SizedBox(height: 24);
final gapH32 = const SizedBox(height: 32);
final gapW12 = const SizedBox(width: 12);
final gapW16 = const SizedBox(width: 16);

// Update the _WinCard widget to include a textfield and proper styling
class _WinCard extends StatefulWidget {
  final Win win;
  final int index;
  final VoidCallback onToggleHighlight;
  final Function(String) onTextChanged;

  const _WinCard({
    required this.win,
    required this.index,
    required this.onToggleHighlight,
    required this.onTextChanged,
  });

  @override
  State<_WinCard> createState() => _WinCardState();
}

class _WinCardState extends State<_WinCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.win.text);
  }

  @override
  void didUpdateWidget(_WinCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.win.text != widget.win.text &&
        _controller.text != widget.win.text) {
      _controller.text = widget.win.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.win.isHighlighted
              ? AppColors.goldenSelected.withValues(
                  alpha: 0.8,
                ) // Use golden color for highlighted wins
              : AppColors.bgBorderSecondary,
          width: widget.win.isHighlighted ? 1 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: 14,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.bgBorderSecondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '${widget.index}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Sizes.p12),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                onChanged: widget.onTextChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: 'Win #${widget.index}',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  isDense: true,
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: Sizes.p12),
            GestureDetector(
              onTap: widget.onToggleHighlight,
              child: Icon(
                widget.win.isHighlighted ? Icons.star : Icons.star,
                color: widget.win.isHighlighted
                    ? AppColors.goldenSelected.withValues(
                        alpha: 0.8,
                      ) // Golden color for highlighted
                    : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
