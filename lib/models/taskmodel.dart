class Task {
  int? id;
  String title;
  String priority;
  String category;
  String date;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.priority,
    this.category = 'OTHERS',
    required this.date,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'category': category,
      'date': date,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      priority: map['priority'],
      category: map['category'] ?? 'OTHERS',
      date: map['date'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
