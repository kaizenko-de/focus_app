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
    final supplementsAsync = ref.watch(supplementProvider);

    // Available emojis for selection
    final availableEmojis = [
      '💊',
      '💉',
      '🧪',
      '💪',
      '🧬',
      '🌿',
      '💧',
      '⚡',
      '❤️',
      '🧠',
    ];

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

    // Get existing supplement data
    Supplement? existing;
    supplementsAsync.whenData((supplements) {
      if (supplementId != null) {
        try {
          existing = supplements.firstWhere((r) => r.id == supplementId);
        } catch (e) {
          existing = null;
        }
      }
    });

    final nameController = useTextEditingController(text: existing?.name ?? '');
    final dosageController = useTextEditingController(
      text: existing?.dosage ?? '',
    );

    // Emoji picker key
    final emojiButtonKey = useMemoized(() => GlobalKey());

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
    final selectedEmoji = useState<String>(existing?.icon ?? '💊');
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

    // Helper to get emoji name
    String _getEmojiName(String emoji) {
      switch (emoji) {
        case '💊':
          return 'Pill';
        case '💉':
          return 'Injection';
        case '🧪':
          return 'Lab';
        case '💪':
          return 'Strength';
        case '🧬':
          return 'DNA';
        case '🌿':
          return 'Herbal';
        case '💧':
          return 'Drops';
        case '⚡':
          return 'Energy';
        case '❤️':
          return 'Heart';
        case '🧠':
          return 'Brain';
        default:
          return '';
      }
    }

    // Show emoji picker overlay
    void _showEmojiPicker() {
      final renderBox =
          emojiButtonKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final offset = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (dialogContext) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: offset.dy + size.height + 8,
              left: offset.dx,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.bgBorderSecondary),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(77),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Choose an icon',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.bgBorderSecondary,
                        height: 1,
                      ),
                      ...availableEmojis.map(
                        (emoji) => InkWell(
                          onTap: () {
                            selectedEmoji.value = emoji;
                            hasChanges.value = true;
                            Navigator.pop(dialogContext);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                // const SizedBox(width: 12),
                                /*  Text(
                                  _getEmojiName(emoji),
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                ), */
                                if (selectedEmoji.value == emoji) ...[
                                  gapW16,
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: 18,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                  final supplement = Supplement(
                    id: existing?.id ?? DateTime.now().toString(),
                    name: nameController.text.isEmpty
                        ? 'Supplement'
                        : nameController.text,
                    dosage: dosageController.text,
                    timeOfDay: _convertEnumToTime(selectedTime.value),
                    frequency: _getFrequencyFromDays(selectedDays.value),
                    reminderEnabled: isReminderOn.value,
                    icon: selectedEmoji.value,
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
                'Supplements',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Clickable emoji field
              Center(
                child: GestureDetector(
                  key: emojiButtonKey,
                  onTap: _showEmojiPicker,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        selectedEmoji.value,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.only(bottom: Sizes.p8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      width: 1,
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
                    filled: true,
                    fillColor: Colors.transparent,
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
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      width: 1,
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
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: Sizes.p24),
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
              _buildDaySelector(selectedDays, _trackChanges),
              const SizedBox(height: Sizes.p32),
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
                        deleteType: "Supplement",
                        itemName: existing?.name ?? "",
                        subtitle: 'This action cannot be undone.',
                      );
                      if (shouldDelete == true && context.mounted) {
                        ref
                            .read(supplementProvider.notifier)
                            .deleteSupplement(existing!.id);
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

  // --- UI Helpers ---
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
