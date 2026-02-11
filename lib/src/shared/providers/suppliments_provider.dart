import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';

part 'suppliments_provider.g.dart';

@HiveType(typeId: 2)
class Supplement extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String dosage;

  @HiveField(3)
  late String timeOfDay;

  @HiveField(4)
  late String frequency;

  @HiveField(5)
  late bool reminderEnabled;

  @HiveField(6)
  late String icon;

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

class SupplementNotifier extends StateNotifier<AsyncValue<List<Supplement>>> {
  final Box<Supplement> supplementBox;

  SupplementNotifier(this.supplementBox)
    : super(AsyncValue.data(supplementBox.values.toList())) {
    _initializeIfEmpty();
  }

  void _initializeIfEmpty() {
    if (supplementBox.isEmpty) {
      // _addMockData();
    }
  }

  /*   void _addMockData() {
    final mockSupplements = [
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

    for (final supplement in mockSupplements) {
      supplementBox.put(supplement.id, supplement);
    }

    _updateState();
  } */

  void addOrUpdateSupplement(Supplement supplement) {
    supplementBox.put(supplement.id, supplement);
    _updateState();
  }

  void deleteSupplement(String id) {
    supplementBox.delete(id);
    _updateState();
  }

  void _updateState() {
    state = AsyncValue.data(supplementBox.values.toList());
  }
}

final supplementProvider =
    StateNotifierProvider<SupplementNotifier, AsyncValue<List<Supplement>>>((
      ref,
    ) {
      final supplementBox = Hive.box<Supplement>('supplements');
      return SupplementNotifier(supplementBox);
    });

// Group supplements by time of day
final supplementsByTimeProvider =
    Provider<AsyncValue<Map<String, List<Supplement>>>>((ref) {
      final supplementsAsync = ref.watch(supplementProvider);

      return supplementsAsync.whenData((supplements) {
        final grouped = <String, List<Supplement>>{};

        for (var supplement in supplements) {
          if (!grouped.containsKey(supplement.timeOfDay)) {
            grouped[supplement.timeOfDay] = [];
          }
          grouped[supplement.timeOfDay]!.add(supplement);
        }

        return grouped;
      });
    });
