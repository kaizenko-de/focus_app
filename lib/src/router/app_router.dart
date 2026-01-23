import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focus/src/features/auth/login_screen.dart';
import 'package:focus/src/features/auth/onboarding_screen.dart';
import 'package:focus/src/features/home/day_completed.dart';
import 'package:focus/src/features/home/home_screen.dart';
import 'package:focus/src/features/journal/journal_history_screen.dart';
import 'package:focus/src/features/journal/journal_screen.dart';
import 'package:focus/src/features/main/main_screen.dart';
import 'package:focus/src/features/routines/routines_screen.dart';
import 'package:focus/src/features/settings/settings_screen.dart';
import 'package:focus/src/features/supplements/supplements_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum AppRoutes {
  onboarding,
  login,
  home,
  journal,
  journalHistory,
  routines,
  supplements,
  settings,
  dayCompleted,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) async {
      return null;
    },
    routes: [
      // Public routes (no authentication required)
      GoRoute(
        path: '/',
        name: AppRoutes.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
      /*   GoRoute(
        path: '/home',
        name: AppRoutes.home.name,
        builder: (context, state) => const LoginScreen(),
      ), */

      // Protected routes with Shell (Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: AppRoutes.home.name,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/daycompleted',
            name: AppRoutes.dayCompleted.name,
            builder: (context, state) => const DayCompletedScreen(),
          ),
          GoRoute(
            path: '/journal',
            name: AppRoutes.journal.name,
            builder: (context, state) => const JournalScreen(),
          ),
          GoRoute(
            path: '/journalhistory',
            name: AppRoutes.journalHistory.name,
            builder: (context, state) => const JournalHistoryScreen(),
          ),
          GoRoute(
            path: '/routines',
            name: AppRoutes.routines.name,
            builder: (context, state) => const RoutinesScreen(),
          ),
          GoRoute(
            path: '/supplements',
            name: AppRoutes.supplements.name,
            builder: (context, state) => const SupplementsScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: AppRoutes.settings.name,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
