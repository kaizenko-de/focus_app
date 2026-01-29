import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/shared/modals/app_modals.dart';
import 'package:focus/src/shared/providers/routines_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';
import 'package:intl/intl.dart';

class RoutineEditScreen extends HookConsumerWidget {
  final String? routineId;

  const RoutineEditScreen({super.key, this.routineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TimeOfDay _parseTime(String timeString) {
      try {
        final format = DateFormat('hh:mm a');
        final date = format.parse(timeString);
        return TimeOfDay(hour: date.hour, minute: date.minute);
      } catch (e) {
        return const TimeOfDay(hour: 7, minute: 0); // Default to 7:00 AM
      }
    }

    int _getInitialDurationIndex(String duration) {
      final match = RegExp(r'(\d+)').firstMatch(duration);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final index = (minutes ~/ 5) - 1;
        return index.clamp(0, 23); // Ensure within bounds
      }
      return 5; // Default to 30 mins (6th item: 30 = (5+1)*5)
    }

    // Helper to initialize days from frequency
    List<bool> _initializeDays(String? frequency) {
      if (frequency == null) return List.filled(7, true);

      if (frequency == 'Daily') {
        return List.filled(7, true);
      } else if (frequency == 'Mon, Wed, Fri') {
        return [true, false, true, false, true, false, false];
      } else if (frequency == 'Weekdays') {
        return [true, true, true, true, true, false, false];
      } else if (frequency == 'Weekends') {
        return [false, false, false, false, false, true, true];
      }
      return List.filled(7, true); // Default
    }

    final routines = ref.watch(routineProvider);
    final existing = routineId != null
        ? routines.cast<Routine?>().firstWhere(
            (r) => r?.id == routineId,
            orElse: () => null,
          )
        : null;

    final nameController = useTextEditingController(text: existing?.name ?? '');
    // Initialize days based on frequency or default to all days selected
    final selectedDays = useState<List<bool>>(
      _initializeDays(existing?.frequency),
    );
    final selectedTime = useState<String>(existing?.timeOfDay ?? '07:00 AM');
    final selectedDuration = useState<String>(existing?.duration ?? '30 mins');
    final hasChanges = useState<bool>(false);

    // Helper to convert days to frequency string
    String _getFrequencyFromDays(List<bool> days) {
      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final selectedDayNames = <String>[];

      for (int i = 0; i < days.length; i++) {
        if (days[i]) {
          selectedDayNames.add(dayNames[i]);
        }
      }

      if (selectedDayNames.isEmpty) return 'Never';
      if (selectedDayNames.length == 7) return 'Daily';
      if (selectedDayNames.length == 5 &&
          days[0] &&
          days[1] &&
          days[2] &&
          days[3] &&
          days[4])
        return 'Weekdays';
      if (selectedDayNames.length == 2 && days[5] && days[6]) return 'Weekends';

      return selectedDayNames.join(', ');
    }

    // Time Picker Logic (exact same as old UI)
    Future<void> _pickTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _parseTime(selectedTime.value),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.bgCard,
            ),
          ),
          child: child!,
        ),
      );
      if (picked != null) {
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        selectedTime.value = DateFormat('hh:mm a').format(dt);
        hasChanges.value = true;
      }
    }

    // Wheel Duration Picker Logic (exact same as old UI)
    void _showDurationPicker() {
      final initialIndex = _getInitialDurationIndex(selectedDuration.value);

      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.bgCard,
        builder: (context) => Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(
              initialItem: initialIndex,
            ),
            onSelectedItemChanged: (index) {
              selectedDuration.value = '${(index + 1) * 5} mins';
              hasChanges.value = true;
            },
            children: List.generate(
              24,
              (i) => Center(
                child: Text(
                  '${(i + 1) * 5} mins',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    }

    void _trackChanges() {
      hasChanges.value = true;
    }

    return WillPopScope(
      onWillPop: () async {
        if (!hasChanges.value) return true;
        final shouldDiscard = await showUnsavedChangesModal(context);
        return shouldDiscard ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          elevation: 0,
          leading: TextButton(
            onPressed: () async {
              if (!hasChanges.value) {
                context.pop();
                return;
              }
              final shouldDiscard = await showUnsavedChangesModal(context);
              if (shouldDiscard == true && context.mounted) {
                context.pop();
              }
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          leadingWidth: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Sizes.p20),
              child: TextButton(
                onPressed: () {
                  final routine = Routine(
                    id: existing?.id ?? DateTime.now().toString(),
                    name: nameController.text.isEmpty
                        ? 'Untitled'
                        : nameController.text,
                    timeOfDay: selectedTime.value,
                    duration: selectedDuration.value,
                    frequency: _getFrequencyFromDays(selectedDays.value),
                    reminderEnabled: existing?.reminderEnabled ?? false,
                    icon: existing?.icon ?? '✨',
                  );
                  ref
                      .read(routineProvider.notifier)
                      .addOrUpdateRoutine(routine);
                  context.pop();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Routines',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.center,
                child: Assets.images.routineAdd.image(height: 80, width: 80),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.only(bottom: Sizes.p8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.textSecondary.withValues(
                        alpha: 0.5,
                      ), // change color as needed
                      width: 1, // border thickness
                    ),
                  ),
                ),
                child: TextField(
                  controller: nameController,
                  maxLines: null,
                  onChanged: (_) => _trackChanges(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: 'What is the routine?',
                    hintStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true,
                    isDense: true,
                    filled: true, // Add this
                    fillColor: Colors.transparent, // Add this
                  ),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 22),

              const Text(
                'FREQUENCY',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),
              // Day Selector (exact same as old UI)
              _buildDaySelector(selectedDays, _trackChanges),
              const SizedBox(height: 32),
              const Text(
                'SETTINGS',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildInteractiveSetting(
                Icons.schedule,
                'Time of Day',
                selectedTime.value,
                _pickTime,
              ),
              // Duration Setting (exact same as old UI)
              _buildInteractiveSetting(
                Icons.timer_outlined,
                'Duration',
                selectedDuration.value,
                _showDurationPicker,
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  border: Border.all(color: AppColors.bgBorderSecondary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgBorderSecondary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Reminder',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: existing?.reminderEnabled ?? false,
                      onChanged: (value) {
                        // Note: This won't be saved unless you track it
                        _trackChanges();
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              if (existing != null) ...[
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      final shouldDelete = await showDeleteConfirmationModal(
                        context,
                        itemName: existing.name,
                        deleteType: "Routine",
                        subtitle: 'This action cannot be undone.',
                      );
                      if (shouldDelete == true && context.mounted) {
                        ref
                            .read(routineProvider.notifier)
                            .deleteRoutine(existing.id);
                        context.pop();
                      }
                    },
                    child: const Text(
                      'Delete Routine',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: Sizes.p32),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helpers (exact same as old UI) ---
  Widget _buildDaySelector(
    ValueNotifier<List<bool>> selectedDays,
    VoidCallback onChanged,
  ) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.bgBorderSecondary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          7,
          (i) => GestureDetector(
            onTap: () {
              final newList = List<bool>.from(selectedDays.value);
              newList[i] = !newList[i];
              selectedDays.value = newList;
              onChanged();
            },
            child: CircleAvatar(
              radius: 16,
              backgroundColor: selectedDays.value[i]
                  ? AppColors.primary
                  : Colors.transparent,
              child: Text(
                days[i],
                style: TextStyle(
                  color: selectedDays.value[i]
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveSetting(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.bgBorderSecondary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgBorderSecondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 20),
            ),

            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Text(value, style: const TextStyle(color: AppColors.textSecondary)),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
