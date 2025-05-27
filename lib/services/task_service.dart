import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tambah task baru
  Future<void> addTask(Map<String, dynamic> taskData) async {
    await _firestore.collection('tasks').add(taskData);
  }

  // Update task by id
  Future<void> updateTask(String taskId, Map<String, dynamic> taskData) async {
    await _firestore.collection('tasks').doc(taskId).update(taskData);
  }

  // Delete task by id
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  // Mendapatkan list task sebagai stream
  Stream<QuerySnapshot> getTasks() {
    return _firestore
        .collection('tasks')
        .orderBy('date', descending: false)
        .snapshots();
  }
}
