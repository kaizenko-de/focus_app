import 'package:hooks_riverpod/hooks_riverpod.dart';

class Routine {
  final String id;
  final String name;
  final String frequency;
  final String timeOfDay;
  final String duration;
  final bool reminderEnabled;
  final String icon;

  Routine({
    required this.id,
    required this.name,
    required this.frequency,
    required this.timeOfDay,
    required this.duration,
    required this.reminderEnabled,
    required this.icon,
  });

  Routine copyWith({
    String? id,
    String? name,
    String? frequency,
    String? timeOfDay,
    String? duration,
    bool? reminderEnabled,
    String? icon,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      duration: duration ?? this.duration,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      icon: icon ?? this.icon,
    );
  }
}

class RoutineNotifier extends StateNotifier<List<Routine>> {
  RoutineNotifier() : super([]) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = [
      Routine(
        id: 'r1',
        name: 'Morning Meditation',
        frequency: 'Daily',
        timeOfDay: '07:00 AM',
        duration: '20 mins',
        reminderEnabled: true,
        icon: '🧘',
      ),
      Routine(
        id: 'r2',
        name: 'Reading',
        frequency: 'Daily',
        timeOfDay: '08:00 PM',
        duration: '30 mins',
        reminderEnabled: false,
        icon: '📖',
      ),
      Routine(
        id: 'r3',
        name: 'Workout',
        frequency: 'Mon, Wed, Fri',
        timeOfDay: '05:00 PM',
        duration: '60 mins',
        reminderEnabled: true,
        icon: '🏋️',
      ),
    ];
  }

  void addOrUpdateRoutine(Routine routine) {
    final index = state.indexWhere((r) => r.id == routine.id);
    if (index != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          i == index ? routine : state[i],
      ];
    } else {
      state = [...state, routine];
    }
  }

  void deleteRoutine(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}

final routineProvider =
    StateNotifierProvider<RoutineNotifier, List<Routine>>(
  (ref) => RoutineNotifier(),
);

final routinesByTimeProvider =
    Provider<Map<String, List<Routine>>>((ref) {
  final routines = ref.watch(routineProvider);
  final routinesByTime = <String, List<Routine>>{};

  for (final routine in routines) {
    final timeLabel = routine.timeOfDay;
    if (!routinesByTime.containsKey(timeLabel)) {
      routinesByTime[timeLabel] = [];
    }
    routinesByTime[timeLabel]!.add(routine);
  }

  return routinesByTime;
});
