import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/models/task_item.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({Key? key}) : super(key: key);

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  List<TaskItem> tasksList = <TaskItem>[
    TaskItem(
      task: "Lorem ipsum #1",
      isCompleted: false,
    ),
    TaskItem(
      task: "Lorem ipsum #2",
      isCompleted: false,
    ),
    TaskItem(
      task: "Lorem ipsum #3",
      isCompleted: true,
    ),
    TaskItem(
      task: "Lorem ipsum #4",
      isCompleted: true,
    ),
    TaskItem(
      task: "Lorem ipsum #5",
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(48),
      itemCount: tasksList.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Checkbox(
              value: tasksList[index].isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  tasksList[index].isCompleted = value!;
                });
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Text(tasksList[index].task),
          ],
        );
      },
    );
  }
}
