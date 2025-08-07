import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/components/profile_image.dart';
import 'package:stemm_chat/controllers/auth_controller.dart';
import 'package:stemm_chat/controllers/chat_controller.dart';
import 'package:stemm_chat/models/user_model.dart';
import 'package:stemm_chat/views/chat_view.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        centerTitle: true,
        actions: [
          // Logout button
          IconButton(
            onPressed: () => authController.logout(context),
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: chatController.usersSnapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var userData = UserModel.fromDocument(data[index]);
                  return Column(
                    children: [
                      ListTile(
                        leading: ProfileImage(imagePath: userData.profileImage),
                        title: Hero(
                          tag: userData.name,
                          child: Text(
                            userData.name,
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        subtitle: Text(userData.bio),
                        onTap: () {
                          var chatRoomId = chatController.getChatRoomId(
                            userData.id,
                          );
                          Get.to(
                            () => ChatView(
                              userData: userData,
                              chatroomId: chatRoomId,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      Divider(thickness: 0.3, height: 4),
                    ],
                  );
                },
              );
            }
            return Text('Something missing');
          },
        ),
      ),
    );
  }
}
