import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String gender;
  final String bio;
  final String profileImage;
  final DateTime createdOn;
  final String id;

  UserModel({
    required this.name,
    required this.gender,
    required this.bio,
    required this.profileImage,
    required this.createdOn,
    required this.id,
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      bio: data['bio'] ?? '',
      profileImage: data['profileImage'] ?? '',
      createdOn: (data['createdOn'] as Timestamp).toDate(),
    );
  }
}
