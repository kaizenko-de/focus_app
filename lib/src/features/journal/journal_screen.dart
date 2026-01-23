import 'package:flutter/material.dart';
import 'package:focus/constants/app_sizes.dart';

// --- Constants & Colors ---
class AppColors {
  static const Color bg = Color(0xFF0C0C0C); // Very dark background
  static const Color bgCard = Color(0xFF1C1C1E); // Dark grey card
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color accentBlue = Color(0xFF2E5CFF); // Bright blue
  static const Color accentBlueDark = Color(
    0xFF1A2240,
  ); // Darker blue background for icons
  static const Color starYellow = Color(0xFFFFD60A);
  static const Color divider = Color(0xFF2C2C2E);
  static const Color iconGreen = Color(0xFF30D158);
}

class Sizes {
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
}

// --- Main Screen ---

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  int _selectedMood = 3; // Matching the screenshot (Happy face)
  bool _expandedGratitude = false;
  bool _expandedAffirmation = false;
  bool _expandedNotes = false;

  final String _gratitudeText = 'I am grateful for the focused work...';
  final String _affirmationText = 'I am capable of handling whatever...';
  final String _notesText = 'Felt a bit tired around 3 PM but...';

  final List<String> _wins = [
    'Finished the Q4 proposal draft.',
    'No sugar all day.',
    'Called Mom.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textSecondary,
          ),
          onPressed: () => Navigator.pop(context), // Logic to go back
        ),
        titleSpacing: 0,
        title: Text(
          'ARCHIVE ENTRY',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.p8),
            // Header Title
            const Text(
              'Wednesday, Oct 26',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            const SizedBox(height: Sizes.p8),
            // Header Subtitle
            const Text(
              'Day 298 of 366 • 94% Consistency',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: Sizes.p32),

            // Reflection Header
            _buildSectionHeader('REFLECTION'),
            const SizedBox(height: Sizes.p24),

            // Mood Section
            _buildLabel('MOOD'),
            const SizedBox(height: Sizes.p16),
            _buildMoodSelector(),
            const SizedBox(height: Sizes.p24),

            // Gratitude Section
            _buildLabel('GRATITUDE'),
            const SizedBox(height: Sizes.p12),
            _buildCollapsibleCard(
              text: _gratitudeText,
              isExpanded: _expandedGratitude,
              onTap: () =>
                  setState(() => _expandedGratitude = !_expandedGratitude),
            ),
            const SizedBox(height: Sizes.p24),

            // Three Wins Section
            _buildLabel('THREE WINS'),
            const SizedBox(height: Sizes.p12),
            _buildThreeWinsCard(),
            const SizedBox(height: Sizes.p24),

            // Affirmation Section
            _buildLabel('AFFIRMATION'),
            const SizedBox(height: Sizes.p12),
            _buildCollapsibleCard(
              text: _affirmationText,
              isExpanded: _expandedAffirmation,
              onTap: () =>
                  setState(() => _expandedAffirmation = !_expandedAffirmation),
            ),
            const SizedBox(height: Sizes.p32),

            // Tracking Header
            _buildSectionHeader('TRACKING'),
            const SizedBox(height: Sizes.p24),
            _buildTrackingCards(),
            const SizedBox(height: Sizes.p24),

            // Notes Section
            _buildLabel('NOTES'),
            const SizedBox(height: Sizes.p12),
            _buildCollapsibleCard(
              text: _notesText,
              isExpanded: _expandedNotes,
              onTap: () => setState(() => _expandedNotes = !_expandedNotes),
            ),
            gapH24,
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: Sizes.p16),
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildMoodSelector() {
    // Icons matching the line-art style
    final moods = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.p20,
        horizontal: Sizes.p16,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(moods.length, (index) {
          final isSelected = index == _selectedMood;
          return GestureDetector(
            onTap: () => setState(() => _selectedMood = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, // Background inside circle
                border: Border.all(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary.withOpacity(0.5),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Icon(
                moods[index],
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                size: 24,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCollapsibleCard({
    required String text,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sizes.p16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
                maxLines: isExpanded ? null : 1,
                overflow: isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: Sizes.p8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreeWinsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(_wins.length, (index) {
          final isLast = index == _wins.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                  vertical: Sizes.p16,
                ),
                child: Row(
                  children: [
                    // Number Circle
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accentBlueDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Color(0xFF5E85FD),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Sizes.p12),
                    Expanded(
                      child: Text(
                        _wins[index],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (index == 0) // The star for the first item
                      const Icon(
                        Icons.star,
                        color: AppColors.starYellow,
                        size: 18,
                      ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTrackingCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSingleTracker(
            title: 'ROUTINES',
            current: 5,
            total: 5,
            icon: Icons.check_circle_outline,
            iconColor: AppColors.iconGreen,
          ),
        ),
        const SizedBox(width: Sizes.p12),
        Expanded(
          child: _buildSingleTracker(
            title: 'SUPPLEMENTS',
            current: 4,
            total: 4,
            icon: Icons.link,
            iconColor: AppColors.accentBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleTracker({
    required String title,
    required int current,
    required int total,
    required IconData icon,
    required Color iconColor,
  }) {
    double progress = current / total;

    return Container(
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, color: iconColor, size: 16),
            ],
          ),
          const SizedBox(height: Sizes.p12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$current',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                ' / $total',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.p12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
