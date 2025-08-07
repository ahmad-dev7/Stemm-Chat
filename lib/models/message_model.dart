import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String senderId;
  final String receiverId;
  final String? text; // nullable if only file is sent
  final String? fileUrl; // nullable
  final String messageType; // one of the types in MessageType
  final Timestamp timestamp;

  MessageModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.fileUrl,
    required this.messageType,
    required this.timestamp,
  });

  /// Factory constructor to create a MessageModel from Firestore JSON
  factory MessageModel.fromJson(Map<String, dynamic> json, String docId) {
    return MessageModel(
      id: docId,
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'],
      fileUrl: json['fileUrl'],
      messageType: json['fileType'],
      timestamp: json['timestamp'] ?? Timestamp.now(),
    );
  }

  /// Convert MessageModel to JSON for uploading to Firestore
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'fileUrl': fileUrl,
      'fileType': messageType,
      'timestamp': timestamp,
    };
  }
}

class MessageType {
  static const String text = 'text';
  static const String image = 'image';
  static const String video = 'video';
  static const String document = 'document';
  static const String audio = 'audio';
}
