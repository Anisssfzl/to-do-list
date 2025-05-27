import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _priorityController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  final Color irisPurple = const Color(0xFF9575CD);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _titleController = TextEditingController(text: args?['title'] ?? '');
    _categoryController = TextEditingController(text: args?['category'] ?? '');
    _priorityController = TextEditingController(text: args?['priority'] ?? '');
    _dateController = TextEditingController(text: args?['date'] ?? '');
    _timeController = TextEditingController(text: args?['time'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _priorityController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      print('Task Updated: ${_titleController.text}');
      Navigator.pop(context);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final String formattedTime = picked.format(context);
      _timeController.text = formattedTime;
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? irisPurple,
        iconTheme: theme.iconTheme,
        title: Text(
          'Edit Task',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: theme.appBarTheme.titleTextStyle?.color ??
                theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Title'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: _inputDecoration('Category'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priorityController,
                decoration: _inputDecoration('Priority'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: _inputDecoration('Date'),
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodyLarge!.color),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectTime,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: _inputDecoration('Time'),
                    style: GoogleFonts.poppins(
                        color: theme.textTheme.bodyLarge!.color),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: irisPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.onPrimary,
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
