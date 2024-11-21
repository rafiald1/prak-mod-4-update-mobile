import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CrudController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? imageFile;
  RxList<DocumentSnapshot> recipes = RxList<DocumentSnapshot>([]);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    isLoading.value = true;
    final snapshot = await firestore.collection('recipe').get();
    recipes.value = snapshot.docs;
    isLoading.value = false;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }

  Future<void> addRecipe() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      await firestore.collection('recipe').add({
        'title': titleController.text,
        'description': descriptionController.text,
        // Tambahkan field lain sesuai kebutuhan
      });

      titleController.clear();
      descriptionController.clear();
      imageFile = null;
      update();
      fetchRecipes();
      Get.back();
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }

  Future<void> updateRecipe(String id) async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      await firestore.collection('recipe').doc(id).update({
        'title': titleController.text,
        'description': descriptionController.text,
        // Tambahkan field lain sesuai kebutuhan
      });

      titleController.clear();
      descriptionController.clear();
      imageFile = null;
      update();
      fetchRecipes();
      Get.back();
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }

  Future<void> deleteRecipe(String id) async {
    await firestore.collection('recipe').doc(id).delete();
    fetchRecipes();
  }
}
