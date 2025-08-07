import 'package:flutter/material.dart';

void showAttachmentOptions(
  BuildContext context, {
  required VoidCallback onSendImage,
  required VoidCallback onSendVideo,
  required VoidCallback onSendDocument,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Choose file type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.image_rounded,
                    label: 'Image',
                    onTap: () async {
                      Navigator.pop(context);
                      onSendImage();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.videocam_rounded,
                    label: 'Video',
                    onTap: () {
                      Navigator.pop(context);
                      onSendVideo();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file_rounded,
                    label: 'Document',
                    onTap: () {
                      Navigator.pop(context);
                      onSendDocument();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildAttachmentOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue[50],
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
      ),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 13)),
    ],
  );
}
