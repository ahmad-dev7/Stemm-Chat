import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/components/gender_picker.dart';
import 'package:stemm_chat/components/profile_image_picker.dart';
import 'package:stemm_chat/controllers/auth_controller.dart';

class CreateProfileView extends StatelessWidget {
  const CreateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Profile'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  ProfileImagePicker(),
                  SizedBox(height: 4),
                  Text(
                    "Add a profile photo",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text("Choose a photo to represent yourself"),
                  SizedBox(height: 30),
                  // Name field
                  TextField(
                    controller: authController.nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter display name',
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  SizedBox(height: 15),
                  GenderPicker(),
                  SizedBox(height: 15),
                  // Bio
                  TextField(
                    maxLines: 3,
                    controller: authController.bioController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: "eg. Software developer at XYZ company.",
                      labelText: 'Bio (Optional)',
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: Obx(
                      () => FilledButton(
                        onPressed: authController.saveProfile,
                        child: authController.isLoading.value
                            ? CupertinoActivityIndicator(color: Colors.white)
                            : Text('Save Profile'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
