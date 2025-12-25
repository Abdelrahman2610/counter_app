import 'package:flutter/material.dart';
import 'screens/multi_counter_screen.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/sound_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.init();
  await SoundService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String _selectedColorTheme = 'indigo';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDark = await StorageService.isDarkMode();
    final colorTheme = await StorageService.getColorTheme();

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _selectedColorTheme = colorTheme;
    });
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
    StorageService.setDarkMode(_themeMode == ThemeMode.dark);
  }

  void changeColorTheme(String theme) {
    setState(() {
      _selectedColorTheme = theme;
    });
    StorageService.setColorTheme(theme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Counter App',
      theme: AppTheme.getLightTheme(_selectedColorTheme),
      darkTheme: AppTheme.getDarkTheme(_selectedColorTheme),
      themeMode: _themeMode,
      home: MultiCounterScreen(
        onToggleTheme: toggleTheme,
        onChangeColorTheme: changeColorTheme,
        currentThemeMode: _themeMode,
        currentColorTheme: _selectedColorTheme,
      ),
    );
  }
}
