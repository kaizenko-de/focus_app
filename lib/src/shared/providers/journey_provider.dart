import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';

part 'journey_provider.g.dart';

// ─────────────────── MODELS ───────────────────

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late int moodIndex; // 0-4: very sad to very happy

  @HiveField(3)
  late String gratitude;

  @HiveField(4)
  late List<Win> wins;

  @HiveField(5)
  late String affirmation;

  @HiveField(6)
  late List<String> routineIds; // completed routines

  @HiveField(7)
  late List<String> supplementIds; // taken supplements

  @HiveField(8)
  late String notes;

  @HiveField(9)
  late DateTime createdAt;

  @HiveField(10)
  late bool isSubmitted; // true = EoD is submitted and immutable

  @HiveField(11)
  late bool isPerfectDay; // true = all routines & supplements completed

  @HiveField(12)
  late DateTime eodDate; // normalized local date (YYYY-MM-DD) for upsert logic

  JournalEntry({
    required this.id,
    required this.date,
    required this.moodIndex,
    required this.gratitude,
    required this.wins,
    required this.affirmation,
    required this.routineIds,
    required this.supplementIds,
    required this.notes,
    required this.createdAt,
    this.isSubmitted = false,
    this.isPerfectDay = false,
    DateTime? eodDate,
  }) : eodDate = eodDate ?? DateTime(date.year, date.month, date.day);

  JournalEntry copyWith({
    String? id,
    DateTime? date,
    int? moodIndex,
    String? gratitude,
    List<Win>? wins,
    String? affirmation,
    List<String>? routineIds,
    List<String>? supplementIds,
    String? notes,
    DateTime? createdAt,
    bool? isSubmitted,
    bool? isPerfectDay,
    DateTime? eodDate,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      moodIndex: moodIndex ?? this.moodIndex,
      gratitude: gratitude ?? this.gratitude,
      wins: wins ?? this.wins,
      affirmation: affirmation ?? this.affirmation,
      routineIds: routineIds ?? this.routineIds,
      supplementIds: supplementIds ?? this.supplementIds,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isPerfectDay: isPerfectDay ?? this.isPerfectDay,
      eodDate: eodDate ?? this.eodDate,
    );
  }
}

@HiveType(typeId: 1)
class Win extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String text;

  @HiveField(2)
  late bool isHighlighted;

  Win({required this.id, required this.text, required this.isHighlighted});

  Win copyWith({String? id, String? text, bool? isHighlighted}) {
    return Win(
      id: id ?? this.id,
      text: text ?? this.text,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}

// ─────────────────── NOTIFIERS ───────────────────

class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final Box<JournalEntry> journalBox;

  JournalNotifier(this.journalBox)
    : super(AsyncValue.data(journalBox.values.toList())) {
    _initializeIfEmpty();
  }

  void _initializeIfEmpty() {
    if (journalBox.isEmpty) {
      // _addMockData();
    }
  }

  /*  void _addMockData() {
    final mockEntries = [
      JournalEntry(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        moodIndex: 4,
        gratitude: 'Grateful for great productivity.',
        wins: [
          Win(
            id: '1',
            text: 'Finished the Q4 proposal draft.',
            isHighlighted: true,
          ),
          Win(id: '2', text: 'Healthy meal prep.', isHighlighted: false),
          Win(id: '3', text: 'Great workout.', isHighlighted: false),
        ],
        affirmation: 'I am confident and focused.',
        routineIds: ['r1', 'r2', 'r3'],
        supplementIds: ['s1', 's2', 's3', 's4'],
        notes: 'Amazing day overall!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isSubmitted: true,
        isPerfectDay: true,
      ),
      JournalEntry(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 2)),
        moodIndex: 4,
        gratitude: 'Grateful for great productivity.',
        wins: [
          Win(
            id: '1',
            text: 'Finished the Q4 proposal draft.',
            isHighlighted: true,
          ),
          Win(id: '2', text: 'Healthy meal prep.', isHighlighted: false),
          Win(id: '3', text: 'Great workout.', isHighlighted: false),
        ],
        affirmation: 'I am confident and focused.',
        routineIds: ['r1', 'r2', 'r3'],
        supplementIds: ['s1', 's2', 's3', 's4'],
        notes: 'Amazing day overall!',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isSubmitted: true,
        isPerfectDay: true,
      ),
      JournalEntry(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 3)),
        moodIndex: 4,
        gratitude: 'Grateful for great productivity.',
        wins: [
          Win(
            id: '1',
            text: 'Finished the Q4 proposal draft.',
            isHighlighted: true,
          ),
          Win(id: '2', text: 'Healthy meal prep.', isHighlighted: false),
          Win(id: '3', text: 'Great workout.', isHighlighted: false),
        ],
        affirmation: 'I am confident and focused.',
        routineIds: ['r1', 'r2', 'r3'],
        supplementIds: ['s1', 's2', 's3', 's4'],
        notes: 'Amazing day overall!',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isSubmitted: true,
        isPerfectDay: true,
      ),
      JournalEntry(
        id: '4',
        date: DateTime.now().subtract(const Duration(days: 4)),
        moodIndex: 3,
        gratitude: 'I am grateful for the focused work...',
        wins: [
          Win(
            id: '1',
            text: 'Finished the Q4 proposal draft.',
            isHighlighted: true,
          ),
          Win(id: '2', text: 'No sugar all day.', isHighlighted: false),
          Win(id: '3', text: 'Called Mom.', isHighlighted: false),
        ],
        affirmation: 'I am capable of handling whatever...',
        routineIds: ['r1', 'r2', 'r3'],
        supplementIds: ['s1', 's2'],
        notes: 'Felt a bit tired around 3 PM but...',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        isSubmitted: true,
        isPerfectDay: true,
      ),
    ];

    for (final entry in mockEntries) {
      journalBox.put(entry.id, entry);
    }

    state = AsyncValue.data(journalBox.values.toList());
  } */

  void saveJournalEntry(JournalEntry entry) {
    journalBox.put(entry.id, entry);
    _updateState();
  }

  void deleteJournalEntry(String id) {
    journalBox.delete(id);
    _updateState();
  }

  JournalEntry? getEntryForDate(DateTime date) {
    try {
      return journalBox.values.firstWhere(
        (e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  void _updateState() {
    state = AsyncValue.data(journalBox.values.toList());
  }

  // Calculate main streak (consecutive days with at least submitted EoD)
  int calculateMainStreak() {
    final entries = journalBox.values.toList();
    if (entries.isEmpty) return 0;

    // Sort by date descending (most recent first)
    entries.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    // Start from yesterday if today has no entry, or from today if it does
    bool hasEntryForToday = false;
    for (final entry in entries) {
      if (_isSameDay(entry.date, checkDate) && entry.isSubmitted) {
        hasEntryForToday = true;
        streak = 1;
        checkDate = checkDate.subtract(const Duration(days: 1));
        break;
      }
    }

    // If no entry for today, start counting from yesterday
    if (!hasEntryForToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Count consecutive days backwards
    for (final entry in entries) {
      if (_isSameDay(entry.date, checkDate) && entry.isSubmitted) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (entry.date.isBefore(checkDate)) {
        // Missed a day, streak is broken
        break;
      }
    }

    return streak;
  }

  // Calculate perfect days count
  int calculatePerfectDaysCount() {
    return journalBox.values
        .where((e) => e.isPerfectDay && e.isSubmitted)
        .length;
  }

  // Get best streak (all-time)
  int calculateBestStreak() {
    final entries = journalBox.values.toList();
    if (entries.isEmpty) return 0;

    // Sort by date
    entries.sort((a, b) => a.date.compareTo(b.date));

    int bestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final entry in entries) {
      if (!entry.isSubmitted) {
        currentStreak = 0;
        lastDate = null;
        continue;
      }

      if (lastDate == null) {
        currentStreak = 1;
      } else {
        final daysDifference = entry.date.difference(lastDate).inDays;
        if (daysDifference == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
      }

      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }

      lastDate = entry.date;
    }

    return bestStreak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Check if entry is editable (today only)
  bool isEntryEditable(DateTime eodDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _isSameDay(eodDate, today);
  }

  // Get or upsert entry for today
  JournalEntry? getExistingEntryForToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    try {
      return journalBox.values.firstWhere((e) => _isSameDay(e.eodDate, today));
    } catch (e) {
      return null;
    }
  }

  // Calculate Perfect Day based on completion
  bool calculateIsPerfectDay(
    int completedRoutines,
    int totalRoutines,
    int completedSupplements,
    int totalSupplements,
  ) {
    return completedRoutines == totalRoutines &&
        completedSupplements == totalSupplements;
  }

  // Calculate perfect days in current month
  int calculatePerfectDaysCurrentMonth() {
    final now = DateTime.now();
    return journalBox.values
        .where(
          (e) =>
              e.isPerfectDay &&
              e.isSubmitted &&
              e.date.year == now.year &&
              e.date.month == now.month,
        )
        .length;
  }

  // Calculate average perfect days per month
  double calculateAvgPerfectDaysPerMonth() {
    final entries = journalBox.values.toList();
    if (entries.isEmpty) return 0.0;

    // Group perfect days by month/year
    final Map<String, int> monthMap = {};

    for (final entry in entries) {
      if (entry.isPerfectDay && entry.isSubmitted) {
        final key = '${entry.date.year}-${entry.date.month}';
        monthMap[key] = (monthMap[key] ?? 0) + 1;
      }
    }

    if (monthMap.isEmpty) return 0.0;
    final totalPerfectDays = monthMap.values.fold<int>(0, (a, b) => a + b);
    return totalPerfectDays / monthMap.length;
  }
}

final journalProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<List<JournalEntry>>>((
      ref,
    ) {
      final journalBox = Hive.box<JournalEntry>('journal');
      return JournalNotifier(journalBox);
    });

final journalEntryByDateProvider =
    FutureProvider.family<JournalEntry?, DateTime>((ref, date) async {
      final asyncEntries = ref.watch(journalProvider);
      final entries = asyncEntries.value ?? [];
      try {
        return entries.firstWhere(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        );
      } catch (e) {
        return null;
      }
    });

// ─────────────────── DRAFT STATE ───────────────────

class DraftJournalEntry {
  final int moodIndex;
  final String gratitude;
  final List<Win> wins;
  final String affirmation;
  final Set<String> completedRoutines;
  final Set<String> takenSupplements;
  final String notes;
  final bool hasChanges;

  DraftJournalEntry({
    this.moodIndex = 2,
    this.gratitude = '',
    this.wins = const [],
    this.affirmation = '',
    this.completedRoutines = const {},
    this.takenSupplements = const {},
    this.notes = '',
    this.hasChanges = false,
  });

  DraftJournalEntry copyWith({
    int? moodIndex,
    String? gratitude,
    List<Win>? wins,
    String? affirmation,
    Set<String>? completedRoutines,
    Set<String>? takenSupplements,
    String? notes,
    bool? hasChanges,
  }) {
    return DraftJournalEntry(
      moodIndex: moodIndex ?? this.moodIndex,
      gratitude: gratitude ?? this.gratitude,
      wins: wins ?? this.wins,
      affirmation: affirmation ?? this.affirmation,
      completedRoutines: completedRoutines ?? this.completedRoutines,
      takenSupplements: takenSupplements ?? this.takenSupplements,
      notes: notes ?? this.notes,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

class DraftJournalNotifier extends StateNotifier<DraftJournalEntry> {
  final Ref ref;

  DraftJournalNotifier(this.ref) : super(DraftJournalEntry());

  void setMood(int index) {
    state = state.copyWith(moodIndex: index, hasChanges: true);
  }

  void setGratitude(String text) {
    state = state.copyWith(gratitude: text, hasChanges: true);
  }

  void updateWinText(String winId, String text) {
    final index = state.wins.indexWhere((w) => w.id == winId);
    if (index != -1) {
      final updatedWins = List<Win>.from(state.wins);
      updatedWins[index] = updatedWins[index].copyWith(text: text);
      state = state.copyWith(wins: updatedWins, hasChanges: true);
    }
  }

  void setAffirmation(String text) {
    state = state.copyWith(affirmation: text, hasChanges: true);
  }

  void setNotes(String text) {
    state = state.copyWith(notes: text, hasChanges: true);
  }

  void toggleWinHighlight(String winId) {
    final updatedWins = state.wins.map((w) {
      return w.id == winId ? w.copyWith(isHighlighted: !w.isHighlighted) : w;
    }).toList();
    state = state.copyWith(wins: updatedWins, hasChanges: true);
  }

  void addWin(Win win) {
    state = state.copyWith(wins: [...state.wins, win], hasChanges: true);
  }

  void updateWin(Win win) {
    final updatedWins = state.wins
        .map((w) => w.id == win.id ? win : w)
        .toList();
    state = state.copyWith(wins: updatedWins, hasChanges: true);
  }

  void removeWin(String winId) {
    state = state.copyWith(
      wins: state.wins.where((w) => w.id != winId).toList(),
      hasChanges: true,
    );
  }

  void toggleRoutineCompletion(String routineId) {
    final updated = Set<String>.from(state.completedRoutines);
    if (updated.contains(routineId)) {
      updated.remove(routineId);
    } else {
      updated.add(routineId);
    }
    state = state.copyWith(completedRoutines: updated, hasChanges: true);
  }

  void toggleSupplementTaken(String supplementId) {
    final updated = Set<String>.from(state.takenSupplements);
    if (updated.contains(supplementId)) {
      updated.remove(supplementId);
    } else {
      updated.add(supplementId);
    }
    state = state.copyWith(takenSupplements: updated, hasChanges: true);
  }

  // Save EoD as submitted (immutable) journal entry with upsert logic
  void submitEoD({required int totalRoutines, required int totalSupplements}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if routines and supplements are 100% completed
    final isPerfectDay =
        state.completedRoutines.length == totalRoutines &&
        state.takenSupplements.length == totalSupplements;

    // Check for existing entry for today (upsert logic)
    final existingEntry = ref
        .read(journalProvider.notifier)
        .getExistingEntryForToday();

    final entry = JournalEntry(
      id: existingEntry?.id ?? 'entry_${today.millisecondsSinceEpoch}',
      date: today,
      eodDate: today,
      moodIndex: state.moodIndex,
      gratitude: state.gratitude,
      wins: state.wins,
      affirmation: state.affirmation,
      routineIds: state.completedRoutines.toList(),
      supplementIds: state.takenSupplements.toList(),
      notes: state.notes,
      createdAt: existingEntry?.createdAt ?? DateTime.now(),
      isSubmitted: true,
      isPerfectDay: isPerfectDay,
    );

    ref.read(journalProvider.notifier).saveJournalEntry(entry);
    reset();
  }

  // Load existing entry into draft for editing
  void loadExistingEntry(JournalEntry entry) {
    state = DraftJournalEntry(
      moodIndex: entry.moodIndex,
      gratitude: entry.gratitude,
      wins: entry.wins,
      affirmation: entry.affirmation,
      completedRoutines: Set.from(entry.routineIds),
      takenSupplements: Set.from(entry.supplementIds),
      notes: entry.notes,
      hasChanges: false,
    );
  }

  void reset() {
    state = DraftJournalEntry();
  }
}

final draftJournalProvider =
    StateNotifierProvider<DraftJournalNotifier, DraftJournalEntry>(
      (ref) => DraftJournalNotifier(ref),
    );

// Provider to get today's submitted entry
final todaysEntryProvider = Provider<JournalEntry?>((ref) {
  final entries = ref.watch(journalProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return entries.whenData((data) {
    try {
      return data.firstWhere(
        (e) =>
            e.date.year == today.year &&
            e.date.month == today.month &&
            e.date.day == today.day &&
            e.isSubmitted,
      );
    } catch (e) {
      return null;
    }
  }).valueOrNull;
});

// Provider to get main streak
final mainStreakProvider = Provider<int>((ref) {
  final journal = ref.watch(journalProvider.notifier);
  return journal.calculateMainStreak();
});

// Provider to get best streak
final bestStreakProvider = Provider<int>((ref) {
  final journal = ref.watch(journalProvider.notifier);
  return journal.calculateBestStreak();
});

// Provider to get perfect days count
final perfectDaysCountProvider = Provider<int>((ref) {
  final journal = ref.watch(journalProvider.notifier);
  return journal.calculatePerfectDaysCount();
});

// Provider to get perfect days in current month
final perfectDaysCurrentMonthProvider = Provider<int>((ref) {
  final journal = ref.watch(journalProvider.notifier);
  return journal.calculatePerfectDaysCurrentMonth();
});

// Provider to get average perfect days per month
final avgPerfectDaysPerMonthProvider = Provider<double>((ref) {
  final journal = ref.watch(journalProvider.notifier);
  return journal.calculateAvgPerfectDaysPerMonth();
});
