import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:stemm_chat/components/info_row.dart';
import 'package:stemm_chat/models/user_model.dart';

class ProfileInfoView extends StatelessWidget {
  final UserModel userData;
  const ProfileInfoView({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: userData.profileImage,
                child: CachedNetworkImage(
                  imageUrl: userData.profileImage,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: context.mediaQueryPadding.top,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      InfoRow(
                        icon: Icons.calendar_today_rounded,
                        label: 'Joined',
                        value: DateFormat(
                          'dd MMM, yyyy',
                        ).format(userData.createdOn),
                      ),
                      InfoRow(
                        icon: Icons.male_rounded,
                        label: 'Gender',
                        value: userData.gender,
                      ),
                      InfoRow(
                        icon: Icons.info_outline_rounded,
                        label: 'Bio',
                        value: userData.bio,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Chip(
                  color: WidgetStatePropertyAll(Colors.white),
                  label: Hero(
                    tag: userData.name,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        userData.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
