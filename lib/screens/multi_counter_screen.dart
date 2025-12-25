import 'package:flutter/material.dart';
import '../models/counter_model.dart';
import '../widgets/counter_card.dart';
import '../widgets/animated_background.dart';
import '../services/storage_service.dart';
import 'counter_screen.dart';
import 'settings_screen.dart';

class MultiCounterScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final Function(String) onChangeColorTheme;
  final ThemeMode currentThemeMode;
  final String currentColorTheme;

  const MultiCounterScreen({
    super.key,
    required this.onToggleTheme,
    required this.onChangeColorTheme,
    required this.currentThemeMode,
    required this.currentColorTheme,
  });

  @override
  State<MultiCounterScreen> createState() => _MultiCounterScreenState();
}

class _MultiCounterScreenState extends State<MultiCounterScreen>
    with SingleTickerProviderStateMixin {
  List<CounterModel> _counters = [];
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCounters();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCounters() async {
    final counters = await StorageService.loadCounters();
    setState(() {
      _counters = counters;
      if (_counters.isEmpty) {
        _counters.add(
          CounterModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'My First Counter',
            value: 0,
            goal: 100,
          ),
        );
        _saveCounters();
      }
    });
  }

  Future<void> _saveCounters() async {
    await StorageService.saveCounters(_counters);
  }

  void _addNewCounter() {
    final nameController = TextEditingController();
    final goalController = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Counter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Counter Name',
                border: OutlineInputBorder(),
                hintText: 'e.g., Daily Steps',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Goal',
                border: OutlineInputBorder(),
                hintText: '100',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a name')),
                );
                return;
              }

              final goal = int.tryParse(goalController.text) ?? 100;

              setState(() {
                _counters.add(
                  CounterModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    value: 0,
                    goal: goal,
                  ),
                );
              });

              _saveCounters();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _editCounter(CounterModel counter) {
    final nameController = TextEditingController(text: counter.name);
    final goalController = TextEditingController(text: counter.goal.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Counter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Counter Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Goal',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final goal = int.tryParse(goalController.text) ?? counter.goal;

              setState(() {
                final index = _counters.indexWhere((c) => c.id == counter.id);
                if (index != -1) {
                  _counters[index] = counter.copyWith(name: name, goal: goal);
                }
              });

              _saveCounters();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCounter(CounterModel counter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Counter?'),
        content: Text('Are you sure you want to delete "${counter.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counters.removeWhere((c) => c.id == counter.id);
              });
              _saveCounters();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${counter.name} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openCounterDetail(CounterModel counter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CounterScreen(
          counter: counter,
          onBack: () {
            _loadCounters();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          onToggleTheme: widget.onToggleTheme,
          onChangeColorTheme: widget.onChangeColorTheme,
          currentThemeMode: widget.currentThemeMode,
          currentColorTheme: widget.currentColorTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: 'Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'All Counters'),
            Tab(icon: Icon(Icons.info_outline), text: 'About'),
          ],
        ),
      ),
      body: AnimatedBackground(
        child: TabBarView(
          controller: _tabController,
          children: [_buildCountersTab(), _buildAboutTab()],
        ),
      ),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _addNewCounter,
              icon: const Icon(Icons.add),
              label: const Text('New Counter'),
            )
          : null,
    );
  }

  Widget _buildCountersTab() {
    if (_counters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calculate_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No counters yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addNewCounter,
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Counter'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: _counters.length,
      itemBuilder: (context, index) {
        final counter = _counters[index];
        return CounterCard(
          counter: counter,
          onTap: () => _openCounterDetail(counter),
          onDelete: () => _deleteCounter(counter),
          onEdit: () => _editCounter(counter),
        );
      },
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Advanced Counter App',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Version 1.0.0',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Features',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    Icons.add_circle,
                    'Multiple Counters',
                    'Create unlimited counters for different purposes',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.flag,
                    'Goal Tracking',
                    'Set goals and track your progress visually',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.history,
                    'History',
                    'View recent counter changes and actions',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.undo,
                    'Undo/Redo',
                    'Easily revert accidental changes',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.share,
                    'Export & Share',
                    'Share your counter as text or image',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.celebration,
                    'Confetti Animation',
                    'Celebrate when you reach your goals',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.vibration,
                    'Haptic Feedback',
                    'Feel every tap with tactile responses',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.volume_up,
                    'Sound Effects',
                    'Audio feedback for counter actions',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.dark_mode,
                    'Dark Mode',
                    'Easy on the eyes with dark theme',
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.palette,
                    'Color Themes',
                    'Choose from 5 beautiful color schemes',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Use',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHowToStep(
                    context,
                    '1',
                    'Create a counter with the + button',
                  ),
                  _buildHowToStep(
                    context,
                    '2',
                    'Tap on any counter to open details',
                  ),
                  _buildHowToStep(
                    context,
                    '3',
                    'Use +/- buttons to change value',
                  ),
                  _buildHowToStep(context, '4', 'Set goals and track progress'),
                  _buildHowToStep(context, '5', 'Share your achievements!'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Technologies Used',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTechChip(context, 'Flutter'),
                      _buildTechChip(context, 'Dart'),
                      _buildTechChip(context, 'Material Design'),
                      _buildTechChip(context, 'Google Fonts'),
                      _buildTechChip(context, 'SharedPreferences'),
                      _buildTechChip(context, 'AudioPlayers'),
                      _buildTechChip(context, 'Confetti'),
                      _buildTechChip(context, 'Share Plus'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Made using Flutter',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToStep(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildTechChip(BuildContext context, String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
