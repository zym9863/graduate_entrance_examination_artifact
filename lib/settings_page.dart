import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final ThemeMode currentMode;

  const SettingsPage({Key? key, required this.currentMode}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.currentMode;
  }

  void _onModeChanged(ThemeMode? mode) {
    if (mode != null) {
      setState(() {
        _selectedMode = mode;
      });
    }
  }

  Widget _buildRadioOption(ThemeMode mode, String title) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: mode,
      groupValue: _selectedMode,
      onChanged: _onModeChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedMode);
            },
            child: const Text(
              '保存',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '主题设置',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildRadioOption(ThemeMode.system, '跟随系统'),
          _buildRadioOption(ThemeMode.light, '浅色主题'),
          _buildRadioOption(ThemeMode.dark, '深色主题'),
        ],
      ),
    );
  }
}
