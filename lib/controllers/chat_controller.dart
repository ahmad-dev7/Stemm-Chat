import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stemm_chat/models/message_model.dart';

late ChatController chatController;

class ChatController extends GetxController {
  // Firebase instances
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final isLoading = false.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> usersSnapshots() {
    var userId = auth.currentUser!.uid;
    var collection = fireStore.collection('users');
    var query = collection.where(FieldPath.documentId, isNotEqualTo: userId);
    return query.snapshots();
  }

  String getChatRoomId(String receiverId) {
    var senderId = auth.currentUser!.uid;
    var ids = [senderId, receiverId]..sort();
    return ids.join('_');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatMessagesStream(
    String chatRoomId,
  ) {
    var ref = fireStore.collection('chats');
    var collection = ref.doc(chatRoomId).collection('messages');
    return collection.orderBy('timestamp').snapshots();
  }

  // Pick and compress image
  Future<String?> getImageUrl() async {
    var status = await Permission.photos.request();

    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        var image = File(pickedFile.path);
        isLoading.value = true;
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Center(child: CupertinoActivityIndicator()),
            );
          },
        );
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          '${image.path}_compressed.jpg',
          quality: 40,
        );
        var fileName = basename(image.path);
        Reference ref = storage.ref().child('chat_files/$fileName');
        await ref.putFile(File(compressedImage!.path));
        var downloadUrl = await ref.getDownloadURL();
        isLoading.value = false;
        Navigator.pop(Get.context!);
        return downloadUrl;
      }
    } else {
      errorSnackbar(
        "Permission Denied",
        "Please allow access to photos from settings.",
      );
    }
    return null;
  }

  // Pick and compress video
  Future<String?> getVideoUrl() async {
    var status = await Permission.videos
        .request(); // Might fallback to storage on Android

    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        var video = File(pickedFile.path);
        isLoading.value = true;
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) =>
              const CupertinoAlertDialog(content: CupertinoActivityIndicator()),
        );
        var fileName = basename(video.path);
        Reference ref = storage.ref().child('chat_files/$fileName');
        await ref.putFile(video);
        var downloadUrl = await ref.getDownloadURL();
        isLoading.value = false;
        Navigator.pop(Get.context!);
        return downloadUrl;
      }
    } else {
      errorSnackbar("Permission Denied", "Please allow access to videos.");
    }
    return null;
  }

  // Pick and compress Document
  Future<String?> getDocumentUrl() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      var file = File(result.files.single.path!);
      isLoading.value = true;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) =>
            const CupertinoAlertDialog(content: CupertinoActivityIndicator()),
      );
      var fileName = basename(file.path);
      Reference ref = storage.ref().child('chat_files/$fileName');
      await ref.putFile(file);
      var downloadUrl = await ref.getDownloadURL();
      isLoading.value = false;
      Navigator.pop(Get.context!);
      return downloadUrl;
    }

    return null;
  }

  sendMessage({
    String? text,
    String? fileUrl,
    required String messageType,
    required String chatroomId,
    required String receiverId,
  }) async {
    var ref = fireStore.collection('chats');
    var collection = ref.doc(chatroomId).collection('messages');
    var message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      text: text,
      fileUrl: fileUrl,
      messageType: messageType,
      timestamp: Timestamp.now(),
    );
    await collection.add(message.toJson());
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
}
