import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/models/task_item.dart';
import 'package:flutter_firebase_demo/src/services/tasks_firestore.dart';

final TasksFirestore _tasksFirestore = TasksFirestore();

class TasksSection extends StatefulWidget {
  const TasksSection({Key? key}) : super(key: key);

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
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
        child: _tasksList.length == 0
            ? ListView(
                padding: const EdgeInsets.all(48),
                children: [Center(child: Text("Belum ada tugas"))],
              )
            : ListView.builder(
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
  bool isLoading = false;

  void onCheckboxChanged(bool? value) async {
    try {
      setState(() {
        isLoading = true;
      });
      await _tasksFirestore.setCompletedValue(widget.task, value!);
      setState(() {
        isLoading = false;
        widget.task.isCompleted = value;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Terjadi kesalahan"),
          content: SingleChildScrollView(
            child: Text(e.message ?? "Terjadi kesalahan"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLoading
            ? const CircularProgressIndicator()
            : Checkbox(
                value: widget.task.isCompleted,
                onChanged: onCheckboxChanged,
              ),
        const SizedBox(
          width: 16,
        ),
        Text(
          widget.task.task,
          style: TextStyle(
            decoration:
                widget.task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
