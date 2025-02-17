import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/login_provider.dart';
import '../../../../widgets/confirmation_dialog.dart';

class StudentSettingsPage extends StatefulWidget {
  const StudentSettingsPage({Key? key}) : super(key: key);

  @override
  State<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> with SingleTickerProviderStateMixin {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool darkMode = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Settings Sections
              ..._buildSettingsSections(),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>showLogoutConfirmationDialog(context),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.red[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSettingsSections() {
    return [
      _buildSection(
        title: 'Account Settings',
        icon: Icons.person_outline,
        children: [
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            iconColor: const Color(0xFF6750A4),
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.email_outlined,
            title: 'Change Email',
            iconColor: const Color(0xFF6750A4),
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            iconColor: Colors.red[700]!,
            textColor: Colors.red[700]!,
            onTap: () {},
          ),
        ],
      ),
      _buildSection(
        title: 'Notification Preferences',
        icon: Icons.notifications_none_outlined,
        children: [
          _buildToggleItem(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            value: pushNotifications,
            onChanged: (value) => setState(() => pushNotifications = value),
          ),
          _buildDivider(),
          _buildToggleItem(
            icon: Icons.mark_email_unread_outlined,
            title: 'Email Notifications',
            value: emailNotifications,
            onChanged: (value) => setState(() => emailNotifications = value),
          ),
        ],
      ),
      _buildSection(
        title: 'App Preferences',
        icon: Icons.settings_outlined,
        children: [
          _buildSettingItem(
            icon: Icons.language,
            title: 'Language',
            trailing: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6750A4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'English',
                    style: TextStyle(
                      color: Color(0xFF6750A4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            showChevron: false,
            onTap: () {},
          ),
          _buildDivider(),
          _buildToggleItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            value: darkMode,
            onChanged: (value) => setState(() => darkMode = value),
          ),
        ],
      ),
      _buildSection(
        title: 'Support & Help',
        icon: Icons.help_outline_outlined,
        children: [
          _buildSettingItem(
            icon: Icons.question_answer_outlined,
            title: 'FAQ',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.headset_mic_outlined,
            title: 'Contact Support',
            onTap: () {},
          ),
        ],
      ),
      _buildSection(
        title: 'About',
        icon: Icons.info_outline,
        children: [
          _buildSettingItem(
            icon: Icons.new_releases_outlined,
            title: 'Version',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                '2.1.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            showChevron: false,
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.shield_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
        ],
      ),
    ];
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF6750A4),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF6750A4),
    Color? textColor,
    Widget? trailing,
    bool showChevron = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withOpacity(0.1),
                      iconColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor ?? const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (showChevron && trailing == null)
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6750A4).withOpacity(0.1),
                  const Color(0xFF6750A4).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6750A4),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6750A4),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      endIndent: 16,
      color: Color(0xFFEEEEEE),
    );
  }
}
void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: 'Confirm Logout',
        content: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        cancelText: 'Cancel',
        onConfirm: () {
          Provider.of<LoginProvider>(context, listen: false).logout(context);
        },
      );
    },
  );
}
