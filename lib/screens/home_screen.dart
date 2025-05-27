import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/task_card.dart';
import '../main.dart';
import 'add_category.dart'; // Impor file add_category.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPriority = 'All';
  String _selectedCategory = 'All';

  final List<String> _priorities = ['All', 'High', 'Medium', 'Low'];
  final List<String> _categories = ['All', 'Work', 'Study', 'Personal'];

  final CollectionReference tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter by Priority',
                  style: Theme.of(context).textTheme.titleMedium),
              DropdownButton<String>(
                value: _selectedPriority,
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                  Navigator.pop(context);
                },
                items: _priorities
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text('Filter by Category',
                  style: Theme.of(context).textTheme.titleMedium),
              DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                  Navigator.pop(context);
                },
                items: _categories
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onExportPdfTap() {
    print("Export PDF tapped");
  }

  void _onShareTap() {
    print("Share tapped");
  }

  void _onToggleThemeTap() {
    themeNotifier.value = (themeNotifier.value == ThemeMode.light)
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void _onNotificationTap() {
    print("Notification tapped");
  }

  @override
  Widget build(BuildContext context) {
    final Color irisPurple = Color(0xFF9575CD);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: irisPurple,
        title: Text(
          'Your Tasks',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_list), onPressed: _onFilterTap),
          IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _onExportPdfTap),
          IconButton(icon: const Icon(Icons.share), onPressed: _onShareTap),
          IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: _onToggleThemeTap),
          IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: _onNotificationTap),
        ],
      ),
      body: Container(
        color: irisPurple.withOpacity(0.05),
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: tasksRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading tasks'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final allTasks = snapshot.data!.docs;

            // Filter data sesuai filter yang dipilih
            final filteredTasks = allTasks.where((task) {
              final priority = task['priority'] as String;
              final category = task['category'] as String;

              final matchesPriority =
                  (_selectedPriority == 'All' || priority == _selectedPriority);
              final matchesCategory =
                  (_selectedCategory == 'All' || category == _selectedCategory);

              return matchesPriority && matchesCategory;
            }).toList();

            if (filteredTasks.isEmpty) {
              return Center(child: Text('No tasks found'));
            }

            return ListView.separated(
              itemCount: filteredTasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskCard(
                  title: task['title'],
                  category: task['category'],
                  priority: task['priority'],
                  dateTime: task['dateTime'],
                  iconPath: task['iconPath'],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/add-task'),
            backgroundColor: irisPurple,
            child: const Icon(Icons.add),
            heroTag: 'add_task', // Unique heroTag untuk membedakan FAB
          ),
          const SizedBox(height: 16), // Jarak antar tombol
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCategory()),
            ),
            backgroundColor: irisPurple,
            child: const Icon(Icons.category),
            heroTag: 'add_category', // Unique heroTag untuk membedakan FAB
          ),
        ],
      ),
    );
  }
}
