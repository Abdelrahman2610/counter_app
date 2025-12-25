class CounterHistory {
  final int value;
  final DateTime timestamp;
  final String action; // 'increment', 'decrement', 'reset'

  CounterHistory({
    required this.value,
    required this.timestamp,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'action': action,
    };
  }

  factory CounterHistory.fromJson(Map<String, dynamic> json) {
    return CounterHistory(
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp']),
      action: json['action'],
    );
  }

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String get actionIcon {
    switch (action) {
      case 'increment':
        return '➕';
      case 'decrement':
        return '➖';
      case 'reset':
        return '🔄';
      default:
        return '•';
    }
  }
}
