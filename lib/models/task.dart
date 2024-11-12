import 'package:toodo_app/models/subtask.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final String recordType;
  final String recurrence;
  final int? parentId;
   final List<Subtask> subtasks;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.recordType,
    required this.recurrence,
    this.parentId,
    this.subtasks = const [],
  });

  // Tambahkan metode addSubtask
  void addSubtask(Subtask subtask) {
    subtasks.add(subtask);
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      recordType: json['record_type'],
      recurrence: json['recurrence'],
      parentId: json['parent_id'],
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List)
              .map((subtaskJson) => Subtask.fromJson(subtaskJson))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'record_type': recordType,
      'recurrence': recurrence,
      'parent_id': parentId,
      'subtasks': subtasks.map((subtask) => subtask.toJson()).toList(), // Tambahkan serialisasi subtasks
    };
  }
}

