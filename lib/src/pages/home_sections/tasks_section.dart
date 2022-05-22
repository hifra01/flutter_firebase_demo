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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<TaskItem> _tasksList = [];

  Future<void> _getTasks() async {
    _tasksList = await _tasksFirestore.getAllTasks();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _refreshIndicatorKey.currentState!.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await _getTasks();
          setState(() {});
        },
        child: _tasksList.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(48),
                children: const [
                  Center(
                    child: Text("Belum ada tugas"),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(48),
                itemCount: _tasksList.length,
                itemBuilder: (context, index) => TaskChecklist(
                  task: _tasksList[index],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.task.isCompleted,
          onChanged: isLoading ? null : onCheckboxChanged,
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: Text(
            widget.task.task,
            style: TextStyle(
              decoration:
                  widget.task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();

  bool isLoading = false;

  void addTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String newTask = _taskController.text;
      try {
        await _tasksFirestore.addNewTask(newTask);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan: ${e.message}"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah tugas baru"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(
            label: Text('Tugas baru'),
          ),
          controller: _taskController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tugas baru tidak boleh kosong';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Kembali"),
        ),
        ElevatedButton(
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text('Tambah'),
          onPressed: isLoading ? null : addTask,
        ),
      ],
    );
  }
}
