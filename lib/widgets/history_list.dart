import 'package:flutter/material.dart';
import '../models/counter_history.dart';

class HistoryList extends StatelessWidget {
  final List<CounterHistory> history;

  const HistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 8),
              Text(
                'No history yet',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show last 5 entries
    final recentHistory = history.reversed.take(5).toList();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentHistory.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = recentHistory[index];
              return ListTile(
                leading: Text(
                  entry.actionIcon,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  'Value: ${entry.value}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(entry.formattedTime),
                trailing: Chip(
                  label: Text(
                    entry.action.toUpperCase(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: _getActionColor(context, entry.action),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getActionColor(BuildContext context, String action) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (action) {
      case 'increment':
        return colorScheme.primary.withOpacity(0.2);
      case 'decrement':
        return colorScheme.error.withOpacity(0.2);
      case 'reset':
        return colorScheme.secondary.withOpacity(0.2);
      default:
        return colorScheme.surface;
    }
  }
}
