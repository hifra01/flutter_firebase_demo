import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/models/task_item.dart';
import 'package:flutter_firebase_demo/src/services/tasks_firestore.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({Key? key}) : super(key: key);

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  final TasksFirestore _tasksFirestore = TasksFirestore();
  List<TaskItem> _tasksList = [];

  Future<void> _getTasks() async {
    _tasksList = await _tasksFirestore.getAllTasks();
    print(_tasksList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _getTasks();
          setState(() {});
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(48),
          itemCount: _tasksList.length,
          itemBuilder: (context, index) =>
              TaskChecklist(task: _tasksList[index]),
        ),
      ),
    );
  }
}

class TaskChecklist extends StatefulWidget {
  const TaskChecklist({Key? key, required this.task}) : super(key: key);

  final TaskItem task;

  @override
  State<TaskChecklist> createState() => _TaskChecklistState();
}

class _TaskChecklistState extends State<TaskChecklist> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.task.isCompleted,
          onChanged: (bool? value) {
            setState(() {
              widget.task.isCompleted = value!;
            });
          },
        ),
        const SizedBox(
          width: 16,
        ),
        Text(widget.task.task),
      ],
    );
  }
}
