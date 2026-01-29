import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus/gen/assets.gen.dart';
import 'package:focus/src/shared/modals/app_modals.dart';
import 'package:focus/src/shared/providers/suppliments_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus/constants/app_colors.dart';
import 'package:focus/constants/app_sizes.dart';

enum SuppTime { morning, afternoon, evening }

class SupplementEditScreen extends HookConsumerWidget {
  final String? supplementId;

  const SupplementEditScreen({super.key, this.supplementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplements = ref.watch(supplementProvider);

    // Convert time string to enum
    SuppTime _convertTimeToEnum(String time) {
      switch (time.toLowerCase()) {
        case 'afternoon':
          return SuppTime.afternoon;
        case 'evening':
          return SuppTime.evening;
        default:
          return SuppTime.morning;
      }
    }

    final existing = supplementId != null
        ? supplements.cast<Supplement?>().firstWhere(
            (r) => r?.id == supplementId,
            orElse: () => null,
          )
        : null;

    final nameController = useTextEditingController(text: existing?.name ?? '');
    final dosageController = useTextEditingController(
      text: existing?.dosage ?? '',
    );

    // Convert string time to enum for old UI
    final selectedTime = useState<SuppTime>(
      _convertTimeToEnum(existing?.timeOfDay ?? 'Morning'),
    );

    final selectedDays = useState<List<bool>>(
      existing?.frequency == 'Daily'
          ? List.filled(7, true)
          : [true, true, true, true, true, false, false],
    );
    final isReminderOn = useState<bool>(existing?.reminderEnabled ?? true);
    final hasChanges = useState<bool>(false);

    // Convert enum to time string
    String _convertEnumToTime(SuppTime time) {
      switch (time) {
        case SuppTime.afternoon:
          return 'Afternoon';
        case SuppTime.evening:
          return 'Evening';
        default:
          return 'Morning';
      }
    }

    // Convert days to frequency string
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
                  final supplement = Supplement(
                    id: existing?.id ?? DateTime.now().toString(),
                    name: nameController.text.isEmpty
                        ? 'Supplement'
                        : nameController.text,
                    dosage: dosageController.text,
                    timeOfDay: _convertEnumToTime(selectedTime.value),
                    frequency: _getFrequencyFromDays(selectedDays.value),
                    reminderEnabled: isReminderOn.value,
                    icon: existing?.icon ?? '💊',
                  );
                  ref
                      .read(supplementProvider.notifier)
                      .addOrUpdateSupplement(supplement);
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
                'Suppliments',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.center,
                child: Assets.images.routineAdd.image(height: 80, width: 80),
              ),

              const SizedBox(height: Sizes.p24),
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
                    hintText: 'Supplement Name',
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
                  controller: dosageController,
                  maxLines: null,
                  onChanged: (_) => _trackChanges(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: 'Dosage / Notes (e.g. 200mg)',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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

              const SizedBox(height: Sizes.p24),
              // FREQUENCY (exact same as old UI)
              const Text(
                'FREQUENCY',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              // Day Selector (exact same as old UI)
              _buildDaySelector(selectedDays, _trackChanges),
              const SizedBox(height: Sizes.p32),
              // TIME OF DAY (exact same as old UI)
              const Text(
                'TIME OF DAY',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              // Time Options (exact same as old UI)
              Row(
                children: [
                  _timeOption(
                    SuppTime.morning,
                    'Morning',
                    Icons.wb_sunny_outlined,
                    selectedTime,
                    _trackChanges,
                  ),
                  const SizedBox(width: 8),
                  _timeOption(
                    SuppTime.afternoon,
                    'Afternoon',
                    Icons.wb_cloudy_outlined,
                    selectedTime,
                    _trackChanges,
                  ),
                  const SizedBox(width: 8),
                  _timeOption(
                    SuppTime.evening,
                    'Evening',
                    Icons.nights_stay_outlined,
                    selectedTime,
                    _trackChanges,
                  ),
                ],
              ),
              const SizedBox(height: Sizes.p32),
              // SETTINGS (exact same as old UI)
              const Text(
                'SETTINGS',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              // Reminder Toggle (exact same as old UI)
              _buildToggleItem(
                Icons.notifications_none,
                'Reminder',
                isReminderOn.value,
                (val) {
                  isReminderOn.value = val;
                  _trackChanges();
                },
              ),
              if (existing != null) ...[
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      final shouldDelete = await showDeleteConfirmationModal(
                        context,
                        deleteType: "Suppliment",
                        itemName: existing.name,
                        subtitle: 'This action cannot be undone.',
                      );
                      if (shouldDelete == true && context.mounted) {
                        ref
                            .read(supplementProvider.notifier)
                            .deleteSupplement(existing.id);
                        context.pop();
                      }
                    },
                    child: const Text(
                      'Delete Supplement',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
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
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgBorderSecondary),
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

  Widget _timeOption(
    SuppTime val,
    String label,
    IconData icon,
    ValueNotifier<SuppTime> group,
    VoidCallback onChanged,
  ) {
    final isSelected = group.value == val;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          group.value = val;
          onChanged();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.black,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    IconData icon,
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgBorderSecondary),
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
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
