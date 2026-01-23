import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus/gen/assets.gen.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class DayCompletedScreen extends StatelessWidget {
  const DayCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH24,

            // ───────── HEADER ─────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Today Completed',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.success, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
              child: Text(
                'Friday, 23rd of January 2026',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ),

            gapH24,

            // ───────── STAR ─────────
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.svg.star),

                  gapH16,

                  // ───────── PERFECT DAY ─────────
                  const Text(
                    'Perfect Day',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  gapH8,
                  SvgPicture.asset(Assets.svg.gradientLine),
                ],
              ),
            ),

            gapH48,
            _buildTrackingCards(),

            // ───────── CARDS ─────────
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
      child: Column(
        children: [
          _trackingCard(
            icon: Assets.images.routines,
            title: 'Routines',
            subtitle: '70% completed',
            value: '4/5',
            progress: 0.7,
          ),
          gapH24,
          _trackingCard(
            icon: Assets.images.suppliments,
            title: 'Supplements',
            subtitle: '50% taken',
            value: '2/4',
            progress: 0.5,
          ),
        ],
      ),
    );
  }

  Widget _trackingCard({
    required AssetGenImage icon,
    required String title,
    required String subtitle,
    required String value,
    required double progress,
  }) {
    return Container(
      height: 119,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgCard,

        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bgBorderSecondary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgBorderSecondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: icon.image(
                  width: 24,
                  height: 24,
                  color: AppColors.iconGrey,
                ),
              ),
              gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          gapH16,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bgBorderSecondary,
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────
}
