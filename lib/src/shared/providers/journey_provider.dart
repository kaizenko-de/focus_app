import 'package:hooks_riverpod/hooks_riverpod.dart';

// ─────────────────── MODELS ───────────────────

class JournalEntry {
  final String id;
  final DateTime date;
  final int moodIndex; // 0-4: very sad to very happy
  final String gratitude;
  final List<Win> wins;
  final String affirmation;
  final List<String> routineIds; // completed routines
  final List<String> supplementIds; // taken supplements
  final String notes;
  final DateTime createdAt;

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
  });

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
    );
  }
}

class Win {
  final String id;
  final String text;
  final bool isHighlighted;

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

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier() : super([]) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = [
      JournalEntry(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 0)),
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
        createdAt: DateTime.now(),
      ),
      JournalEntry(
        id: '2',
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
        routineIds: ['r1', 'r2'],
        supplementIds: ['s1', 's2', 's3'],
        notes: 'Amazing day overall!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void saveJournalEntry(JournalEntry entry) {
    final index = state.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      // Update existing (only for drafts before submission)
      state = [
        for (int i = 0; i < state.length; i++) i == index ? entry : state[i],
      ];
    } else {
      // Add new entry
      state = [entry, ...state];
    }
  }

  void deleteJournalEntry(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  JournalEntry? getEntryForDate(DateTime date) {
    try {
      return state.firstWhere(
        (e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }
}

final journalProvider =
    StateNotifierProvider<JournalNotifier, List<JournalEntry>>(
      (ref) => JournalNotifier(),
    );

final journalEntryByDateProvider =
    FutureProvider.family<JournalEntry?, DateTime>((ref, date) async {
      final entries = ref.watch(journalProvider);
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
  DraftJournalNotifier() : super(DraftJournalEntry());

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
      state = state.copyWith(wins: updatedWins);
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

  void reset() {
    state = DraftJournalEntry();
  }
}

final draftJournalProvider =
    StateNotifierProvider<DraftJournalNotifier, DraftJournalEntry>(
      (ref) => DraftJournalNotifier(),
    );
