import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_demo/src/models/task_item.dart';

class TasksFirestore {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TaskItem>> getAllTasks() async {
    CollectionReference tasksCollection = _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks');

    QuerySnapshot<Object?> result = await tasksCollection.get();

    if (result.size == 0) {
      return [];
    }

    List<QueryDocumentSnapshot<Object?>> tasks = result.docs;

    return List.generate(
      result.size,
      (index) => TaskItem.fromQueryDocumentSnapshot(tasks[index]),
    );
  }
}
