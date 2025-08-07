import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stemm_chat/views/auth_view.dart';
import 'package:stemm_chat/views/create_profile_view.dart';
import 'package:stemm_chat/views/users_view.dart';

late AuthController authController;

class AuthController extends GetxController {
  // Firebase instances
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final fireStore = FirebaseFirestore.instance;

  // Password visibility handler
  final isLogin = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final bioController = TextEditingController();

  // Focus node
  final confirmPasswordFocusNode = FocusNode();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Loader
  final isLoading = false.obs;

  // Picked profile image
  Rx<File?> profileImage = Rx<File?>(null);

  // Gender
  final genders = ['Male', 'Female'];
  final selectedGender = Rx<String?>(null);

  // Email validator
  emailValidator(String? value) {
    if (value == null) {
      return "Please enter email address";
    } else if (!value.isEmail) {
      return "Please enter a valid email address";
    } else {
      return;
    }
  }

  // Password validator
  passwordValidator(String? value) {
    if (value == null) {
      return "Please enter password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long";
    } else {
      return;
    }
  }

  // Confirm password validator
  confirmPasswordValidator(String? value) {
    if (value == null) {
      return "Please confirm password";
    } else if (passwordController.text != confirmPasswordController.text) {
      return "Password and Confirm password is not matching";
    } else {
      return;
    }
  }

  // Form validator
  validateForm() {
    if (formKey.currentState!.validate()) {
      isLogin.value ? login() : signup();
    }
  }

  // login
  login() async {
    var email = emailController.text;
    var password = passwordController.text;
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // To handle the cases if user has registered earlier but didn't completed profile
      if (auth.currentUser!.displayName == null ||
          auth.currentUser!.photoURL == null) {
        Get.offAll(() => CreateProfileView());
        Get.snackbar(
          'Complete profile',
          "Please complete your profile to continue",
        );
      } else {
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        Get.offAll(() => UsersView());
      }
    } on FirebaseAuthException catch (e) {
      Get.log('Exception while login: $e', isError: true);
      errorSnackbar('Login Failed', e.message);
      throw Exception(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  // signup
  signup() async {
    var email = emailController.text;
    var password = passwordController.text;
    isLoading.value = true;
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      Get.offAll(() => CreateProfileView());
    } on FirebaseAuthException catch (e) {
      Get.log('Exception while signup: $e', isError: true);
      errorSnackbar('Signup Failed', e.message);
      throw Exception(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  // logout
  logout(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text('you want to logout'),
          title: Text('Are you sure!?'),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Get.offAll(() => AuthView());
                await auth.signOut();
              },
              child: Text('Logout'),
            ),
            CupertinoDialogAction(onPressed: Get.back, child: Text('Cancel')),
          ],
        );
      },
    );
  }

  // Error Snackbar
  errorSnackbar(String title, String? message) {
    Get.snackbar(
      title,
      message ?? "An unexpected error occurred",
      backgroundColor: const Color(0xFFB00020),
      colorText: const Color(0xFFFFFFFF),
      isDismissible: true,
      duration: const Duration(seconds: 5),
    );
  }

  // Pick profile image
  pickProfileImage() async {
    var status = await Permission.photos.request();

    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } else {
      errorSnackbar(
        "Permission Denied",
        "Please allow access to photos from settings.",
      );
    }
  }

  // Save profile
  saveProfile() async {
    if (profileImage.value == null) {
      errorSnackbar('Select image', 'Please choose profile image from gallery');
      return;
    }
    if (nameController.text.isEmpty) {
      errorSnackbar('Enter name', 'Name field can\'t be empty');
      return;
    }
    if (selectedGender.value == null) {
      errorSnackbar('Select gender', 'Please select your gender');
      return;
    }
    isLoading.value = true;
    await Future.delayed(3.seconds);
    try {
      var fileName = basename(profileImage.value!.path);
      Reference ref = storage.ref().child('profile_images/$fileName');
      Get.log('Compressing image');
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        profileImage.value!.absolute.path,
        '${profileImage.value!.path}_compressed.jpg',
        quality: 40,
      );
      Get.log('Compression success');
      Get.log('Uploading image');
      // Upload the file
      await ref.putFile(File(compressedImage!.path));
      Get.log('Upload success');
      // Get the download URL
      String downloadURL = await ref.getDownloadURL();
      Get.log('Image uploaded successfully. Download URL: $downloadURL');
      await auth.currentUser!.updatePhotoURL(downloadURL);
      await auth.currentUser!.updateDisplayName(nameController.text);

      // Update user info
      fireStore.collection('users').doc(auth.currentUser!.uid).set({
        'name': nameController.text,
        'gender': selectedGender.value,
        'bio': bioController.text,
        'profileImage': downloadURL,
        'createdOn': DateTime.now(),
      });
      var storedInfo = await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      Get.log('Added user info in collection $storedInfo');
      Get.log("updated photo url: ${auth.currentUser!.photoURL}");
      Get.log("updated display name: ${auth.currentUser!.displayName}");

      Get.snackbar(
        'Success',
        'Profile saved successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      selectedGender.value = null;
      profileImage.value = null;
      bioController.clear();
      nameController.clear();
      Get.offAll(() => UsersView());
    } on FirebaseAuthException catch (e) {
      errorSnackbar(
        "Failed to save profile",
        e.message ??
            'An unexpected error occurred while trying to save profile',
      );
      throw Exception(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Compress Image
  Future<File?> compressImage(File file) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Compress the image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // Adjust quality (0-100)
        minWidth: 800, // Maximum width
        minHeight: 800, // Maximum height
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (e) {
      Get.log('Error compressing image: $e', isError: true);
      return null;
    }
  }
}
