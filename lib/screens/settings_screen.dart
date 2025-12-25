import 'package:flutter/material.dart';
import '../utils/color_themes.dart';
import '../services/sound_service.dart';
import '../services/haptic_service.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final Function(String) onChangeColorTheme;
  final ThemeMode currentThemeMode;
  final String currentColorTheme;

  const SettingsScreen({
    super.key,
    required this.onToggleTheme,
    required this.onChangeColorTheme,
    required this.currentThemeMode,
    required this.currentColorTheme,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final soundEnabled = await StorageService.isSoundEnabled();
    final hapticEnabled = await StorageService.isHapticEnabled();

    setState(() {
      _soundEnabled = soundEnabled;
      _hapticEnabled = hapticEnabled;
    });

    SoundService.setEnabled(soundEnabled);
    HapticService.setEnabled(hapticEnabled);
  }

  void _toggleSound(bool value) {
    setState(() {
      _soundEnabled = value;
    });
    SoundService.setEnabled(value);
    StorageService.setSoundEnabled(value);
  }

  void _toggleHaptic(bool value) {
    setState(() {
      _hapticEnabled = value;
    });
    HapticService.setEnabled(value);
    StorageService.setHapticEnabled(value);
    if (value) HapticService.selection();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  secondary: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: isDarkMode,
                  onChanged: (value) {
                    widget.onToggleTheme();
                    HapticService.selection();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.palette,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Color Theme'),
                  subtitle: Text(_getThemeName(widget.currentColorTheme)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showColorThemeDialog(),
                ),
              ],
            ),
          ),

          // Feedback Section
          _buildSectionHeader(context, 'Feedback'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  subtitle: const Text('Play sounds on actions'),
                  secondary: Icon(
                    _soundEnabled ? Icons.volume_up : Icons.volume_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: _soundEnabled,
                  onChanged: _toggleSound,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Haptic Feedback'),
                  subtitle: const Text('Vibrate on button press'),
                  secondary: Icon(
                    _hapticEnabled ? Icons.vibration : Icons.phone_android,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: _hapticEnabled,
                  onChanged: _toggleHaptic,
                ),
              ],
            ),
          ),

          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.code,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Built with Flutter'),
                  subtitle: const Text('Cross-platform framework'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'Advanced Counter App',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _getThemeName(String theme) {
    return theme[0].toUpperCase() + theme.substring(1);
  }

  void _showColorThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color Theme'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ColorThemes.themeNames.map((theme) {
              final isSelected = theme == widget.currentColorTheme;
              final color = ColorThemes.getPrimaryColor(
                theme,
                widget.currentThemeMode == ThemeMode.dark,
              );

              return RadioListTile<String>(
                title: Text(_getThemeName(theme)),
                value: theme,
                groupValue: widget.currentColorTheme,
                onChanged: (value) {
                  if (value != null) {
                    widget.onChangeColorTheme(value);
                    HapticService.selection();
                    Navigator.pop(context);
                  }
                },
                secondary: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
