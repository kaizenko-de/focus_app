import 'package:hooks_riverpod/hooks_riverpod.dart';

class Supplement {
  final String id;
  final String name;
  final String dosage;
  final String timeOfDay;
  final String frequency;
  final bool reminderEnabled;
  final String icon;

  Supplement({
    required this.id,
    required this.name,
    required this.dosage,
    required this.timeOfDay,
    required this.frequency,
    required this.reminderEnabled,
    required this.icon,
  });

  Supplement copyWith({
    String? id,
    String? name,
    String? dosage,
    String? timeOfDay,
    String? frequency,
    bool? reminderEnabled,
    String? icon,
  }) {
    return Supplement(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      frequency: frequency ?? this.frequency,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      icon: icon ?? this.icon,
    );
  }
}

class SupplementNotifier extends StateNotifier<List<Supplement>> {
  SupplementNotifier() : super([]) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = [
      Supplement(
        id: 's1',
        name: 'Magnesium',
        dosage: '500mg',
        timeOfDay: 'Morning',
        frequency: 'Daily',
        reminderEnabled: true,
        icon: '💊',
      ),
      Supplement(
        id: 's2',
        name: 'Vitamin D',
        dosage: '2000 IU',
        timeOfDay: 'Morning',
        frequency: 'Daily',
        reminderEnabled: false,
        icon: '☀️',
      ),
      Supplement(
        id: 's3',
        name: 'Omega 3',
        dosage: '1000mg',
        timeOfDay: 'Evening',
        frequency: 'Daily',
        reminderEnabled: true,
        icon: '🐟',
      ),
      Supplement(
        id: 's4',
        name: 'Creatine',
        dosage: '5g',
        timeOfDay: 'Evening',
        frequency: 'After Gym',
        reminderEnabled: false,
        icon: '💪',
      ),
    ];
  }

  void addOrUpdateSupplement(Supplement supplement) {
    final index = state.indexWhere((s) => s.id == supplement.id);
    if (index != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          i == index ? supplement : state[i],
      ];
    } else {
      state = [...state, supplement];
    }
  }

  void deleteSupplement(String id) {
    state = state.where((s) => s.id != id).toList();
  }
}

final supplementProvider =
    StateNotifierProvider<SupplementNotifier, List<Supplement>>(
      (ref) => SupplementNotifier(),
    );

// Group supplements by time of day
final supplementsByTimeProvider = Provider<Map<String, List<Supplement>>>((
  ref,
) {
  final supplements = ref.watch(supplementProvider);
  final grouped = <String, List<Supplement>>{};

  for (var supplement in supplements) {
    if (!grouped.containsKey(supplement.timeOfDay)) {
      grouped[supplement.timeOfDay] = [];
    }
    grouped[supplement.timeOfDay]!.add(supplement);
  }

  return grouped;
});
