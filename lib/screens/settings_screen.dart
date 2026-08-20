// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;

  static const primary = Color(0xFF4B4BEA);

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _changeTheme(bool value) {
    setState(() => _isDarkMode = value);
    widget.onThemeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette_outlined, size: 20),
            title: const Text(
              'Theme',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              _isDarkMode ? 'Dark' : 'Light',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined, size: 20),
            title: const Text(
              'Change Theme',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              _isDarkMode ? 'Dark / Light' : 'Light / Dark',
              style: const TextStyle(fontSize: 10),
            ),
            trailing: Switch(
              value: _isDarkMode,
              activeColor: primary,
              onChanged: _changeTheme,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline, size: 20),
            title: const Text(
              'About App',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Contact Management App',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Flutter Local Database CRUD Assignment',
              );
            },
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.access_time, size: 20),
            title: Text(
              'Version',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              '1.0.0',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
