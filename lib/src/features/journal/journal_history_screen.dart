import 'package:flutter/material.dart';
import 'package:focus/src/router/app_router.dart';
import 'package:go_router/go_router.dart';

// --- Constants & Colors ---
class AppColors {
  static const Color bg = Color(0xFF0C0C0C); // Main background
  static const Color bgCard = Color(0xFF161618); // Card background
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF98989E); // Muted grey text
  static const Color accentBlueGrey = Color(0xFFAEBCCF); // Progress bar color
  static const Color accentDarkGrey = Color(0xFF2C2C2E); // Progress bar track
  static const Color navBarBg = Color(0xFF101010); // Bottom nav background
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

class JournalHistoryScreen extends StatelessWidget {
  const JournalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Sizes.p20),
                    // Header Title
                    const Text(
                      'Journal History',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: Sizes.p8),
                    // Subtitle
                    const Text(
                      'Reflecting on your consistency',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary, // Light blue-grey tint
                      ),
                    ),
                    const SizedBox(height: Sizes.p32),

                    // Streak Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '30-DAY STREAK',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                        const Text(
                          '24 Days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.p12),
                    // Streak Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 24 / 30,
                        minHeight: 6,
                        backgroundColor: AppColors.accentDarkGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accentBlueGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.p32),

                    // List Items
                    _buildHistoryCard(
                      label: 'YESTERDAY',
                      date: 'Oct 24',
                      topWin: 'Finished the Q4 proposal draft.',
                      context: context,
                    ),
                    const SizedBox(height: Sizes.p16),
                    _buildHistoryCard(
                      label: 'WEDNESDAY',
                      date: 'Oct 23',
                      topWin: 'Finished the Q4 proposal draft.',
                      context: context,
                    ),
                    const SizedBox(height: Sizes.p16),
                    _buildHistoryCard(
                      label: 'TUESDAY',
                      date: 'Oct 22',
                      topWin: 'Finished the Q4 proposal draft.',
                      context: context,
                    ),
                    const SizedBox(height: Sizes.p16),
                    _buildHistoryCard(
                      label: 'MONDAY',
                      date: 'Oct 21',
                      topWin: 'Finished the Q4 proposal draft.',
                      context: context,
                    ),
                    const SizedBox(height: Sizes.p32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String label,
    required String date,
    required String topWin,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.journal.name);
      },
      child: Container(
        padding: const EdgeInsets.all(Sizes.p20),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.textPrimary, // Keeping date white/bright
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.p20),

            // "Top Win" Label
            Text(
              'TOP WIN',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: Sizes.p8),

            // Win Content
            Text(
              topWin,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: Sizes.p16),

            // Expandable Trigger
            Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: Sizes.p4),
                Text(
                  'Show 2 more Achievements',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color = isActive
        ? Colors.white
        : AppColors.textSecondary.withOpacity(0.5);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
