import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart'; // Impor GoogleFonts
import '../services/category_service.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _categoryNameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final CategoryService _categoryService = CategoryService();

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk menyimpan kategori (contoh placeholder)
  Future<void> _saveCategory() async {
      if (_categoryNameController.text.isNotEmpty && _selectedImage != null) {
        try {
          await _categoryService.addCategory(
            _categoryNameController.text,
            _selectedImage!,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category saved successfully')),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save category: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Please enter a category name and select an image'),
          ),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    final Color irisPurple = Color(0xFF9575CD);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: irisPurple,
        title: Text(
          'Add Category',
          style: GoogleFonts.poppins(
              fontWeight:
                  FontWeight.w600), // Gunakan GoogleFonts dengan huruf kapital
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Enter category name',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Category Icon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: irisPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage == null
                    ? const Center(child: Text('Tap to upload image'))
                    : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: irisPurple,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Category'),
            ),
          ],
        ),
      ),
    );
  }
}
