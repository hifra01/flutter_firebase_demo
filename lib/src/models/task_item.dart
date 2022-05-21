// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
  String id;
  String task;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.task,
    required this.isCompleted,
  });

  TaskItem copyWith({
    String? id,
    String? task,
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id ?? this.id,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task': task,
      'isCompleted': isCompleted,
    };
  }

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'] as String,
      task: map['task'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  factory TaskItem.fromQueryDocumentSnapshot(QueryDocumentSnapshot document) {
    String id = document.id;
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    return TaskItem(
      id: id,
      task: map['task'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskItem.fromJson(String source) =>
      TaskItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TaskItem(id: $id, task: $task, isCompleted: $isCompleted)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskItem &&
        other.id == id &&
        other.task == task &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => id.hashCode ^ task.hashCode ^ isCompleted.hashCode;
}
