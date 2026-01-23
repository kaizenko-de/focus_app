import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Required for the Wheel Picker
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

// --- Constants & Colors ---
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

// --- Data Model ---
class Routine {
  final String id;
  final String title;
  final String time;
  final String duration;
  final String iconEmoji;
  final List<bool> days;

  Routine({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    required this.iconEmoji,
    required this.days,
  });
}

// --- State Management ---
class RoutineNotifier extends StateNotifier<List<Routine>> {
  RoutineNotifier() : super([]) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = [
      Routine(
        id: '1',
        title: 'Morning Protocol',
        time: '07:00 AM',
        duration: '30 mins',
        iconEmoji: '☀️',
        days: List.filled(7, true),
      ),
      Routine(
        id: '2',
        title: 'Deep Work Block',
        time: '09:30 AM',
        duration: '90 mins',
        iconEmoji: '🧠',
        days: List.filled(7, true),
      ),
      Routine(
        id: '3',
        title: 'Gym Session',
        time: '05:00 PM',
        duration: '60 mins',
        iconEmoji: '🏋️',
        days: List.filled(7, true),
      ),
      Routine(
        id: '4',
        title: 'Evening Wind-down',
        time: '09:30 PM',
        duration: '45 mins',
        iconEmoji: '🌙',
        days: List.filled(7, true),
      ),
    ];
  }

  void addOrUpdateRoutine(Routine routine) {
    final index = state.indexWhere((r) => r.id == routine.id);
    if (index != -1) {
      state = [
        for (int i = 0; i < state.length; i++) i == index ? routine : state[i],
      ];
    } else {
      state = [...state, routine];
    }
  }

  void deleteRoutine(String id) =>
      state = state.where((r) => r.id != id).toList();
  void toggleMockData() => state.isEmpty ? _initializeMockData() : state = [];
}

final routineProvider = StateNotifierProvider<RoutineNotifier, List<Routine>>(
  (ref) => RoutineNotifier(),
);

// --- Main Screen ---
class RoutinesScreen extends HookConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Routines',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: routines.isEmpty
          ? const Center(
              child: Text(
                'No routines',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p20,
                Sizes.p16,
                Sizes.p20,
                120,
              ),
              itemCount: routines.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _showSheet(context, routine: routines[index]),
                child: _RoutineCard(routine: routines[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryBlue,
        onPressed: () => _showSheet(context),
        label: const Text(
          'New Routine',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showSheet(BuildContext context, {Routine? routine}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddRoutineSheet(existingRoutine: routine),
    );
  }
}

// --- Add/Edit Routine Sheet ---
class AddRoutineSheet extends HookConsumerWidget {
  final Routine? existingRoutine;
  const AddRoutineSheet({super.key, this.existingRoutine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(
      text: existingRoutine?.title ?? "",
    );
    final selectedDays = useState<List<bool>>(
      existingRoutine?.days ?? List.filled(7, true),
    );
    final selectedTime = useState<String>(existingRoutine?.time ?? '07:00 AM');
    final selectedDuration = useState<String>(
      existingRoutine?.duration ?? '30 mins',
    );

    // Time Picker Logic
    Future<void> _pickTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBlue,
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
      }
    }

    // Wheel Duration Picker Logic
    void _showDurationPicker() {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.bgCard,
        builder: (context) => Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              selectedDuration.value = '${(index + 1) * 5} mins';
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
                        .read(routineProvider.notifier)
                        .addOrUpdateRoutine(
                          Routine(
                            id:
                                existingRoutine?.id ??
                                DateTime.now().toString(),
                            title: nameController.text.isEmpty
                                ? "Untitled"
                                : nameController.text,
                            time: selectedTime.value,
                            duration: selectedDuration.value,
                            iconEmoji: existingRoutine?.iconEmoji ?? '✨',
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
                    Text(
                      existingRoutine == null ? 'New Routine' : 'Edit Routine',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter name...',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildDaySelector(selectedDays),
                    const SizedBox(height: 32),
                    _buildInteractiveSetting(
                      Icons.schedule,
                      'Time of Day',
                      selectedTime.value,
                      _pickTime,
                    ),
                    _buildInteractiveSetting(
                      Icons.timer_outlined,
                      'Duration',
                      selectedDuration.value,
                      _showDurationPicker,
                    ),
                    if (existingRoutine != null) ...[
                      const SizedBox(height: 40),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            ref
                                .read(routineProvider.notifier)
                                .deleteRoutine(existingRoutine!.id);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete Routine',
                            style: TextStyle(color: AppColors.deleteRed),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget _buildDaySelector(ValueNotifier<List<bool>> selectedDays) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
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

  Widget _buildInteractiveSetting(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
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
          Text(value, style: const TextStyle(color: AppColors.textSecondary)),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    ),
  );
}

class _RoutineCard extends StatelessWidget {
  final Routine routine;
  const _RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(routine.iconEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routine.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${routine.time} • ${routine.duration}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
