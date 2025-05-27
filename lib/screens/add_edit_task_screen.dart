import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedPriority;
  DateTime? _selectedDateTime;

  final Color irisPurple = const Color(0xFF9575CD);

  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String get _formattedDateTime {
    if (_selectedDateTime == null) return 'Select Date & Time';
    return '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}, '
        '${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}';
  }

  InputDecoration _inputDecoration(String label) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: theme.textTheme.bodyLarge!.color),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: irisPurple),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: irisPurple.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: theme.cardColor.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'priority': _selectedPriority,
        'dueDate': _selectedDateTime,
        'createdAt': DateTime.now(),
        'isCompleted': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task saved successfully!')),
      );

      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah simpan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save task: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? irisPurple,
        iconTheme: theme.iconTheme,
        title: Text(
          'Add Task',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: theme.appBarTheme.titleTextStyle?.color ??
                theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Title'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Description'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _inputDecoration('Category'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
                iconEnabledColor: irisPurple,
                items: const [
                  DropdownMenuItem(value: 'Work', child: Text('Work')),
                  DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'Study', child: Text('Study')),
                ],
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: _inputDecoration('Priority'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
                iconEnabledColor: irisPurple,
                items: const [
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                ],
                validator: (value) =>
                    value == null ? 'Please select a priority' : null,
                onChanged: (value) => setState(() => _selectedPriority = value),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _formattedDateTime,
                  style: GoogleFonts.poppins(
                      color: theme.textTheme.bodyLarge!.color),
                ),
                onPressed: _pickDateTime,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: irisPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: irisPurple,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 5,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 3),
                      )
                    : Text(
                        'Save Task',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
