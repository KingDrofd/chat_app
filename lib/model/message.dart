import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String sendeEmail;
  final String recieverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.sendeEmail,
    required this.recieverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': sendeEmail,
      'recieverId': recieverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
