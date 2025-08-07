import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/components/video_player_screen.dart';
import 'package:video_player/video_player.dart';

class VideoChatBubble extends StatefulWidget {
  final String videoUrl;
  final bool isSender;

  const VideoChatBubble({
    super.key,
    required this.videoUrl,
    required this.isSender,
  });

  @override
  State<VideoChatBubble> createState() => _VideoChatBubbleState();
}

class _VideoChatBubbleState extends State<VideoChatBubble> {
  late VideoPlayerController _controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Get.to(() => VideoPlayerScreen(videoUrl: widget.videoUrl));
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: widget.isSender
                ? Colors.blue.shade100
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    const Icon(
                      Icons.play_circle_fill,
                      size: 48,
                      color: Colors.white70,
                    ),
                  ],
                )
              : const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                ),
        ),
      ),
    );
  }
}
