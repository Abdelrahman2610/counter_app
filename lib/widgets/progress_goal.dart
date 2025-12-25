import 'package:flutter/material.dart';

class ProgressGoal extends StatelessWidget {
  final int currentValue;
  final int goalValue;
  final VoidCallback onEditGoal;

  const ProgressGoal({
    super.key,
    required this.currentValue,
    required this.goalValue,
    required this.onEditGoal,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = goalValue > 0
        ? (currentValue / goalValue).clamp(0.0, 1.0)
        : 0.0;
    final percentage = (progress * 100).toStringAsFixed(0);
    final isComplete = currentValue >= goalValue;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isComplete ? Icons.emoji_events : Icons.flag,
                      color: isComplete ? Colors.amber : colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Goal Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onEditGoal,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isComplete ? Colors.amber : colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentValue / $goalValue',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isComplete ? Colors.amber : colorScheme.primary,
                  ),
                ),
              ],
            ),

            if (isComplete) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.celebration, color: Colors.amber, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Goal Reached! 🎉',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
