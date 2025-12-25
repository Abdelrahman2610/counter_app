import 'package:flutter/material.dart';
import '../widgets/counter_display.dart';
import '../widgets/action_button.dart';
import '../widgets/history_list.dart';
import '../widgets/progress_goal.dart';
import '../widgets/animated_background.dart';
import '../models/counter_model.dart';
import '../models/counter_history.dart';
import '../services/sound_service.dart';
import '../services/haptic_service.dart';
import '../services/storage_service.dart';
import '../services/export_service.dart';

class CounterScreen extends StatefulWidget {
  final CounterModel counter;
  final VoidCallback onBack;

  const CounterScreen({super.key, required this.counter, required this.onBack});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen>
    with SingleTickerProviderStateMixin {
  late CounterModel _counter;
  late List<CounterHistory> _history;
  late List<int> _undoStack;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _showConfetti = false;
  bool _previousGoalReached = false;

  @override
  void initState() {
    super.initState();
    _counter = widget.counter;
    _history = [];
    _undoStack = [];
    _previousGoalReached = _counter.isGoalReached;

    _loadHistory();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_animationController);
  }

  Future<void> _loadHistory() async {
    final history = await StorageService.loadHistory(_counter.id);
    setState(() {
      _history = history;
    });
  }

  Future<void> _saveHistory() async {
    await StorageService.saveHistory(_counter.id, _history);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    if (_counter.value >= 999999) {
      _showMaxReachedSnackBar();
      return;
    }

    setState(() {
      _undoStack.add(_counter.value);
      _counter = _counter.copyWith(value: _counter.value + 1);
      _history.add(
        CounterHistory(
          value: _counter.value,
          timestamp: DateTime.now(),
          action: 'increment',
        ),
      );
    });

    _animationController.forward(from: 0.0);
    SoundService.playIncrement();
    HapticService.light();
    _saveHistory();

    // Check if goal just reached
    if (_counter.isGoalReached && !_previousGoalReached) {
      _triggerConfetti();
      _previousGoalReached = true;
      SoundService.playGoalReached();
      HapticService.heavy();
    }
  }

  void _decrementCounter() {
    if (_counter.value <= 0) {
      _showMinReachedSnackBar();
      return;
    }

    setState(() {
      _undoStack.add(_counter.value);
      _counter = _counter.copyWith(value: _counter.value - 1);
      _history.add(
        CounterHistory(
          value: _counter.value,
          timestamp: DateTime.now(),
          action: 'decrement',
        ),
      );
    });

    _animationController.forward(from: 0.0);
    SoundService.playDecrement();
    HapticService.light();
    _saveHistory();

    if (!_counter.isGoalReached) {
      _previousGoalReached = false;
    }
  }

  void _resetCounter() {
    setState(() {
      _undoStack.add(_counter.value);
      _counter = _counter.copyWith(value: 0);
      _history.add(
        CounterHistory(
          value: _counter.value,
          timestamp: DateTime.now(),
          action: 'reset',
        ),
      );
      _previousGoalReached = false;
    });

    _animationController.forward(from: 0.0);
    SoundService.playReset();
    HapticService.medium();
    _saveHistory();
    _showResetSnackBar();
  }

  void _undoAction() {
    if (_undoStack.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing to undo')));
      return;
    }

    setState(() {
      final previousValue = _undoStack.removeLast();
      _counter = _counter.copyWith(value: previousValue);
      if (_history.isNotEmpty) {
        _history.removeLast();
      }
    });

    HapticService.selection();
    _saveHistory();
  }

  void _triggerConfetti() {
    setState(() {
      _showConfetti = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

  void _editGoal() {
    final controller = TextEditingController(text: _counter.goal.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Goal Value',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newGoal = int.tryParse(controller.text) ?? 100;
              setState(() {
                _counter = _counter.copyWith(goal: newGoal);
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _shareCounter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Share as Text'),
              onTap: () {
                Navigator.pop(context);
                ExportService.shareCounterAsText(_counter.name, _counter.value);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Share as Image'),
              onTap: () {
                Navigator.pop(context);
                // Create a widget to capture
                ExportService.shareCounterAsImage(
                  Container(
                    padding: const EdgeInsets.all(32),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _counter.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${_counter.value}',
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMaxReachedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maximum value reached!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showMinReachedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cannot go below zero!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showResetSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Counter reset!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_counter.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undoStack.isNotEmpty ? _undoAction : null,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareCounter,
            tooltip: 'Share',
          ),
        ],
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16), // Counter display
                CounterDisplay(
                  counter: _counter.value,
                  scaleAnimation: _scaleAnimation,
                  showConfetti: _showConfetti,
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButton(
                      icon: Icons.remove,
                      onPressed: _decrementCounter,
                      backgroundColor: Colors.red,
                      label: 'Decrease',
                      isEnabled: _counter.value > 0,
                    ),
                    const SizedBox(width: 16),
                    ActionButton(
                      icon: Icons.add,
                      onPressed: _incrementCounter,
                      backgroundColor: Colors.green,
                      label: 'Increase',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Reset button
                OutlinedButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Counter'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Progress goal
                ProgressGoal(
                  currentValue: _counter.value,
                  goalValue: _counter.goal,
                  onEditGoal: _editGoal,
                ),

                const SizedBox(height: 16),

                // History
                HistoryList(history: _history),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Quick Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onBack() {
    widget.onBack();
  }
}
