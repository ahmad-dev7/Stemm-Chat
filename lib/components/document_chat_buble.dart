import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/components/document_viewer.dart';

class DocumentChatBubble extends StatelessWidget {
  final String fileName;
  final String filePath;
  final bool isSender;

  const DocumentChatBubble({
    super.key,
    required this.fileName,
    required this.filePath,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          Get.to(() => DocumentViewer(filePath: filePath));
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue[300]! : context.theme.highlightColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/document.png', height: 60),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  fileName,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
