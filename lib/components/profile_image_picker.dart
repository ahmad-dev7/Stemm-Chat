import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/controllers/auth_controller.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: authController.pickProfileImage,
      child: Stack(
        children: [
          Obx(
            () => Material(
              elevation: 8,
              color: Colors.grey,
              type: MaterialType.circle,
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                radius: 65,
                backgroundImage: authController.profileImage.value == null
                    ? NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/147/147142.png',
                      )
                    : FileImage(authController.profileImage.value!),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 4,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black54,
              child: Icon(Icons.mode_edit, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
