import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String category;
  final String priority;
  final String dateTime;
  final String iconPath;

  const TaskCard({
    Key? key,
    required this.title,
    required this.category,
    required this.priority,
    required this.dateTime,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(iconPath, width: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$category • $priority',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateTime,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Task',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/edit-task',
                      arguments: {
                        'title': title,
                        'category': category,
                        'priority': priority,
                        'date': dateTime,
                        'iconPath': iconPath,
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete Task',
                  onPressed: () {
                    // Tambahkan logika penghapusan jika diperlukan
                    print("Delete tapped for task: $title");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
