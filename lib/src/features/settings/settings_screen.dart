import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _reminderEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.bg,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p20),
        children: [
          _buildSection(
            context,
            title: 'Notifications',
            children: [
              _buildSettingsTile(
                context,
                title: 'Enable Notifications',
                subtitle: 'Get daily reminders',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
              _buildSettingsTile(
                context,
                title: 'Daily Reminder',
                subtitle: 'Set a time for your reminder',
                value: _reminderEnabled,
                onChanged: (value) {
                  setState(() => _reminderEnabled = value);
                },
              ),
            ],
          ),
          const SizedBox(height: Sizes.p24),
          _buildSection(
            context,
            title: 'Appearance',
            children: [
              _buildSettingsTile(
                context,
                title: 'Dark Mode',
                subtitle: 'Easier on your eyes',
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() => _darkModeEnabled = value);
                },
              ),
            ],
          ),
          const SizedBox(height: Sizes.p24),
          _buildSection(
            context,
            title: 'Account',
            children: [
              _buildAccountTile(
                context,
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle: 'View and edit your profile',
              ),
              _buildAccountTile(
                context,
                icon: Icons.lock_outline,
                title: 'Password',
                subtitle: 'Change your password',
              ),
              _buildAccountTile(
                context,
                icon: Icons.logout_outlined,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                isDangerous: true,
              ),
            ],
          ),
          const SizedBox(height: Sizes.p24),
          _buildSection(
            context,
            title: 'About',
            children: [
              _buildAboutTile(
                context,
                title: 'Version',
                value: '1.0.0',
              ),
              _buildAboutTile(
                context,
                title: 'Build',
                value: '42',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: Sizes.p12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.bgSecondary),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.bgSecondary),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Sizes.p4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDangerous = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.bgSecondary),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDangerous
                  ? AppColors.error.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDangerous ? AppColors.error : AppColors.primary,
            ),
          ),
          const SizedBox(width: Sizes.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDangerous ? AppColors.error : Colors.white,
                  ),
                ),
                const SizedBox(height: Sizes.p4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDangerous ? AppColors.error : AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTile(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.bgSecondary),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
