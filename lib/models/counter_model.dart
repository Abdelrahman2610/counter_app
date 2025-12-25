class CounterModel {
  String id;
  String name;
  int value;
  int goal;
  DateTime createdAt;
  DateTime updatedAt;

  CounterModel({
    required this.id,
    required this.name,
    this.value = 0,
    this.goal = 100,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'goal': goal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      id: json['id'],
      name: json['name'],
      value: json['value'] ?? 0,
      goal: json['goal'] ?? 100,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Calculate progress percentage
  double get progress => goal > 0 ? (value / goal).clamp(0.0, 1.0) : 0.0;

  // Check if goal is reached
  bool get isGoalReached => value >= goal;

  // Create a copy with modifications
  CounterModel copyWith({String? name, int? value, int? goal}) {
    return CounterModel(
      id: id,
      name: name ?? this.name,
      value: value ?? this.value,
      goal: goal ?? this.goal,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
