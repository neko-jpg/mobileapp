import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _dataSync = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF101D22),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _SettingsSection(
            title: 'General Settings',
            tiles: [
              _SettingsTile(
                title: 'Push Notifications',
                subtitle: 'Reminders & partner updates',
                trailing: Switch(
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
                  activeColor: const Color(0xFF13B6EC),
                ),
              ),
              _SettingsTile(
                title: 'Notification Times',
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Sounds',
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'Privacy & Data',
            tiles: [
              _SettingsTile(
                title: 'Data Sync',
                subtitle: 'Keep data synced across devices',
                trailing: Switch(
                  value: _dataSync,
                  onChanged: (value) => setState(() => _dataSync = value),
                  activeColor: const Color(0xFF13B6EC),
                ),
              ),
              _SettingsTile(
                title: 'Manage Blocked Users',
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Export My Data',
                trailing: const Icon(Icons.download_outlined, color: Colors.grey),
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Delete Account & Data',
                titleColor: Colors.red.shade600,
                trailing: Icon(Icons.delete_outline, color: Colors.red.shade600),
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'About MinQ',
            tiles: [
              _SettingsTile(
                title: 'Terms of Service',
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Privacy Policy',
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {},
              ),
              _SettingsTile(
                title: 'App Version',
                trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const _SettingsSection({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 24, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF101D22),
            ),
          ),
        ),
        Column(children: tiles),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(color: Colors.grey))
            : null,
        trailing: trailing,
      ),
    );
  }
}