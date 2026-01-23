import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// --- Constants (Matching Screens) ---
class AppColors {
  static const Color bg = Color(0xFF0C0C0C);
  static const Color bgCard = Color(0xFF161618);
  static const Color primaryBlue = Color(0xFF2E5CFF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textMuted = Color(0xFF636366);
  static const Color accentDark = Color(0xFF2C2C2E);
  static const Color deleteRed = Color(0xFFFF453A);
}

class Sizes {
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
}

enum SuppTime { morning, afternoon, evening }

// --- Data Model ---
class Supplement {
  final String id;
  final String name;
  final String dosage;
  final SuppTime timeOfDay;
  final String iconEmoji;
  final List<bool> days;

  Supplement({
    required this.id,
    required this.name,
    required this.dosage,
    required this.timeOfDay,
    required this.iconEmoji,
    required this.days,
  });
}

// --- State Management ---
class SuppNotifier extends StateNotifier<List<Supplement>> {
  SuppNotifier() : super([]) {
    // Initial Mock Data to match screenshot
    state = [
      Supplement(
        id: '1',
        name: 'Magnesium Glycinate',
        dosage: '400mg • With food',
        timeOfDay: SuppTime.morning,
        iconEmoji: '💊',
        days: List.filled(7, true),
      ),
      Supplement(
        id: '2',
        name: 'Omega-3 Fish Oil',
        dosage: '2g • Post-workout',
        timeOfDay: SuppTime.morning,
        iconEmoji: '🐟',
        days: List.filled(7, true),
      ),
      Supplement(
        id: '3',
        name: 'Vitamin D',
        dosage: '5000IU • Anytime',
        timeOfDay: SuppTime.morning,
        iconEmoji: '☀️',
        days: List.filled(7, true),
      ),
    ];
  }

  void addOrUpdate(Supplement item) {
    final index = state.indexWhere((s) => s.id == item.id);
    if (index != -1) {
      state = [
        for (int i = 0; i < state.length; i++) i == index ? item : state[i],
      ];
    } else {
      state = [...state, item];
    }
  }

  void delete(String id) => state = state.where((s) => s.id != id).toList();
}

final suppProvider = StateNotifierProvider<SuppNotifier, List<Supplement>>(
  (ref) => SuppNotifier(),
);

// --- Main Screen ---

class SupplementsScreen extends HookConsumerWidget {
  const SupplementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplements = ref.watch(suppProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Supplements',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Sizes.p20,
          Sizes.p16,
          Sizes.p20,
          100,
        ),
        children: [
          _buildSection(
            context,
            'MORNING SUPPLEMENTS',
            supplements.where((s) => s.timeOfDay == SuppTime.morning).toList(),
          ),
          const SizedBox(height: Sizes.p24),
          _buildSection(
            context,
            'AFTERNOON SUPPLEMENTS',
            supplements
                .where((s) => s.timeOfDay == SuppTime.afternoon)
                .toList(),
          ),
          const SizedBox(height: Sizes.p24),
          _buildSection(
            context,
            'EVENING SUPPLEMENTS',
            supplements.where((s) => s.timeOfDay == SuppTime.evening).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryBlue,
        onPressed: () => _showSheet(context),
        label: const Text(
          'Add Supplement',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Supplement> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: Sizes.p16),
        if (items.isEmpty)
          _buildEmptyCategorySlot()
        else
          ...items.map(
            (item) => GestureDetector(
              onTap: () => _showSheet(context, existing: item),
              child: _SuppCard(item: item),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyCategorySlot() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.link,
            color: AppColors.textMuted.withOpacity(0.5),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No supplements added.',
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context, {Supplement? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SuppEditSheet(existing: existing),
    );
  }
}

// --- Card Widget ---
class _SuppCard extends StatelessWidget {
  final Supplement item;
  const _SuppCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p12),
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Text(item.iconEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: Sizes.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.dosage,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}

// --- Edit / Create Sheet ---
class SuppEditSheet extends HookConsumerWidget {
  final Supplement? existing;
  const SuppEditSheet({super.key, this.existing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: existing?.name ?? "");
    final dosageController = useTextEditingController(
      text: existing?.dosage ?? "",
    );
    final selectedTime = useState<SuppTime>(
      existing?.timeOfDay ?? SuppTime.morning,
    );
    final selectedDays = useState<List<bool>>(
      existing?.days ?? List.filled(7, true),
    );
    final isReminderOn = useState(true);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(Sizes.p20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(suppProvider.notifier)
                        .addOrUpdate(
                          Supplement(
                            id: existing?.id ?? DateTime.now().toString(),
                            name: nameController.text,
                            dosage: dosageController.text,
                            timeOfDay: selectedTime.value,
                            iconEmoji: existing?.iconEmoji ?? '💊',
                            days: selectedDays.value,
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Sizes.p20),
                    const Text(
                      'Supplements',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Sizes.p32),
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.bgCard,
                        child: Icon(
                          Icons.add_reaction_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.p24),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Supplement Name',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 4),

                    TextField(
                      controller: dosageController,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Dosage / Notes (e.g. 200mg)',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: Sizes.p24),
                    const Text(
                      'FREQUENCY',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDaySelector(selectedDays),
                    const SizedBox(height: Sizes.p32),
                    const Text(
                      'TIME OF DAY',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
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
                        ),
                        const SizedBox(width: 8),
                        _timeOption(
                          SuppTime.afternoon,
                          'Afternoon',
                          Icons.wb_cloudy_outlined,
                          selectedTime,
                        ),
                        const SizedBox(width: 8),
                        _timeOption(
                          SuppTime.evening,
                          'Evening',
                          Icons.nights_stay_outlined,
                          selectedTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.p32),
                    const Text(
                      'SETTINGS',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildToggleItem(
                      Icons.notifications_none,
                      'Reminder',
                      isReminderOn.value,
                      (val) => isReminderOn.value = val,
                    ),
                    if (existing != null) ...[
                      const SizedBox(height: 32),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            ref
                                .read(suppProvider.notifier)
                                .delete(existing!.id);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete Supplement',
                            style: TextStyle(color: AppColors.deleteRed),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeOption(
    SuppTime val,
    String label,
    IconData icon,
    ValueNotifier<SuppTime> group,
  ) {
    final isSelected = group.value == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => group.value = val,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : AppColors.accentDark,
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

  Widget _buildDaySelector(ValueNotifier<List<bool>> selectedDays) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentDark),
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
            },
            child: CircleAvatar(
              radius: 16,
              backgroundColor: selectedDays.value[i]
                  ? AppColors.primaryBlue
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

  Widget _buildToggleItem(
    IconData icon,
    String label,
    bool value,
    Function(bool) onChanged,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.bgCard,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.accentDark),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primaryBlue,
        ),
      ],
    ),
  );
}
