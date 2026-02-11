import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';

part 'routines_provider.g.dart';

@HiveType(typeId: 3)
class Routine extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String frequency;

  @HiveField(3)
  late String timeOfDay;

  @HiveField(4)
  late String duration;

  @HiveField(5)
  late bool reminderEnabled;

  @HiveField(6)
  late String icon;

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

class RoutineNotifier extends StateNotifier<AsyncValue<List<Routine>>> {
  final Box<Routine> routineBox;

  RoutineNotifier(this.routineBox)
    : super(AsyncValue.data(routineBox.values.toList())) {
    _initializeIfEmpty();
  }

  void _initializeIfEmpty() {
    if (routineBox.isEmpty) {
      // _addMockData();
    }
  }

  /*   void _addMockData() {
    final mockRoutines = [
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

    for (final routine in mockRoutines) {
      routineBox.put(routine.id, routine);
    }

    _updateState();
  } */

  void addOrUpdateRoutine(Routine routine) {
    routineBox.put(routine.id, routine);
    _updateState();
  }

  void deleteRoutine(String id) {
    routineBox.delete(id);
    _updateState();
  }

  void _updateState() {
    state = AsyncValue.data(routineBox.values.toList());
  }
}

final routineProvider =
    StateNotifierProvider<RoutineNotifier, AsyncValue<List<Routine>>>((ref) {
      final routineBox = Hive.box<Routine>('routines');
      return RoutineNotifier(routineBox);
    });

final routinesByTimeProvider = Provider<AsyncValue<Map<String, List<Routine>>>>(
  (ref) {
    final routinesAsync = ref.watch(routineProvider);

    return routinesAsync.whenData((routines) {
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
  },
);
