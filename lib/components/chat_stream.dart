import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/components/document_chat_buble.dart';
import 'package:stemm_chat/components/video_chat_buble.dart';
import 'package:stemm_chat/controllers/chat_controller.dart';
import 'package:stemm_chat/models/message_model.dart';

class ChatStream extends StatelessWidget {
  final String chatroomId;
  const ChatStream({super.key, required this.chatroomId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatController.chatMessagesStream(chatroomId),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          var data = snapShot.data!;
          if (data.docs.isEmpty) {
            return Center(
              child: Text("No message here yet,\nStart conversation"),
            );
          }
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              var doc = data.docs.reversed.toList();

              var message = MessageModel.fromJson(
                doc[index].data(),
                doc[index].id,
              );
              var isSender =
                  message.senderId == chatController.auth.currentUser!.uid;

              switch (message.messageType) {
                case MessageType.text:
                  return BubbleNormal(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    // TODO Use switch case to show different messages typoes
                    text: message.text ?? message.messageType,
                    textStyle: TextStyle(),
                    isSender: isSender,
                    color: isSender
                        ? Colors.blue[300]!
                        : context.theme.highlightColor,
                  );
                case MessageType.image:
                  return BubbleNormalImage(
                    id: message.id!,
                    isSender: isSender,
                    color: isSender
                        ? Colors.blue[300]!
                        : context.theme.highlightColor,
                    image: CachedNetworkImage(imageUrl: message.fileUrl!),
                  );
                case MessageType.video:
                  return VideoChatBubble(
                    videoUrl: message.fileUrl!,
                    isSender: isSender,
                  );
                case MessageType.document:
                  return DocumentChatBubble(
                    fileName: "Document-${message.id!.substring(12)}",
                    filePath: message.fileUrl!,
                    isSender: isSender,
                  );
                default:
                  Text("Message type not supported");
              }
              return null;
            },
          );
        }
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (snapShot.hasError) {
          return Center(child: Text("An error occurred"));
        }
        return Center(child: Text('Unexpected'));
      },
    );
  }
}
