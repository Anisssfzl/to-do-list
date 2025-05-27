import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image ke Firebase Storage dan dapatkan URL nya
  Future<String> uploadCategoryImage(File imageFile, String categoryId) async {
    final ref = _storage.ref().child('category_images/$categoryId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Tambah kategori ke Firestore dengan nama dan URL gambar
  Future<void> addCategory(String categoryName, File imageFile) async {
    final docRef = _firestore.collection('categories').doc();
    final imageUrl = await uploadCategoryImage(imageFile, docRef.id);

    await docRef.set({
      'name': categoryName,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Mendapatkan list kategori dari Firestore
  Stream<QuerySnapshot> getCategories() {
    return _firestore
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
