import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/components/attachment_sheet.dart';
import 'package:stemm_chat/components/chat_stream.dart';
import 'package:stemm_chat/components/profile_image.dart';
import 'package:stemm_chat/controllers/chat_controller.dart';
import 'package:stemm_chat/models/message_model.dart';
import 'package:stemm_chat/models/user_model.dart';
import 'package:stemm_chat/views/profile_info_view.dart';

class ChatView extends StatelessWidget {
  final UserModel userData;
  final String chatroomId;
  const ChatView({super.key, required this.userData, required this.chatroomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        scrolledUnderElevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        title: ListTile(
          onTap: () => Get.to(
            () => ProfileInfoView(userData: userData),
            transition: Transition.cupertino,
          ),
          leading: ProfileImage(imagePath: userData.profileImage),
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Hero(
            tag: userData.name,
            child: Text(
              userData.name,
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ChatStream(chatroomId: chatroomId)),
            Material(
              elevation: 10,
              color: Colors.grey,
              child: MessageBar(
                messageBarColor: Colors.blue[50]!,
                onSend: (text) {
                  if (text.trim().isNotEmpty) {
                    chatController.sendMessage(
                      text: text,
                      messageType: MessageType.text,
                      chatroomId: chatroomId,
                      receiverId: userData.id,
                    );
                  }
                },
                actions: [
                  IconButton(
                    onPressed: () => showAttachmentOptions(
                      context,
                      onSendImage: () async {
                        var imageUrl = await chatController.getImageUrl();
                        if (imageUrl != null) {
                          await chatController.sendMessage(
                            messageType: MessageType.image,
                            fileUrl: imageUrl,
                            chatroomId: chatroomId,
                            receiverId: userData.id,
                          );
                        }
                      },
                      onSendVideo: () async {
                        var videoUrl = await chatController.getVideoUrl();
                        if (videoUrl != null) {
                          await chatController.sendMessage(
                            messageType: MessageType.video,
                            fileUrl: videoUrl,
                            chatroomId: chatroomId,
                            receiverId: userData.id,
                          );
                        }
                      },
                      onSendDocument: () async {
                        var documentUrl = await chatController.getDocumentUrl();
                        if (documentUrl != null) {
                          await chatController.sendMessage(
                            messageType: MessageType.document,
                            fileUrl: documentUrl,
                            chatroomId: chatroomId,
                            receiverId: userData.id,
                          );
                        }
                      },
                    ),
                    icon: Icon(Icons.attach_file_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
