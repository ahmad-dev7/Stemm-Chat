import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imagePath;
  const ProfileImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imagePath,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.cover,
            height: 45,
            width: 45,
            scale: 2,
            placeholder: (context, imageProvider) =>
                CupertinoActivityIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
