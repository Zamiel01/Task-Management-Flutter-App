class Task {
  int? id; // nullable
  String task;

  Task({this.id, required this.task});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'task': task,
    };
    if (id != null) {
      map['id'] = id; // include id only if not null
    }
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      task: map['task'],
    );
  }
}
