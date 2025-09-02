class Task {
  final int? id;
  final String title;
  final String category;
  final String priority;
  final bool completed;
  final DateTime? dueDate;
  final String? notes;

  Task({
    this.id,
    required this.title,
    this.category = 'General',
    this.priority = 'Medium',
    this.completed = false,
    this.dueDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'priority': priority,
      'completed': completed ? 1 : 0,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'notes': notes,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      category: map['category'] ?? 'General',
      priority: map['priority'] ?? 'Medium',
      completed: map['completed'] == 1,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
      notes: map['notes'],
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? category,
    String? priority,
    bool? completed,
    DateTime? dueDate,
    String? notes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
    );
  }
}
