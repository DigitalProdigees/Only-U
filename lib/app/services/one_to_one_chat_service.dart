import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OneToOneChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate a chatId by sorting userIds alphabetically
  String getChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join("_");
  }

  /// Create a chat document if it does not exist
  Future<String?> createChatIfNotExists(
      {required String userId1,
      required String userId2,
      required String avatorUser1,
      required String currentUserName,
      required String oppositeUserName}) async {
    String chatId = getChatId(userId1, userId2);
    DocumentReference chatDoc = _firestore.collection('chats').doc(chatId);

    DocumentSnapshot docSnapshot = await chatDoc.get();
    if (!docSnapshot.exists) {
      final oppositUserAvatorUrl = await getUserAvatorByUserID(userId2);
      await chatDoc.set({
        'members': [userId1, userId2],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'avators': {userId1: avatorUser1, userId2: oppositUserAvatorUrl},
        'names': {userId1: currentUserName, userId2: oppositeUserName}
      });
      return chatDoc.id; // Return the new chat ID if a new chat is created
    }
    return chatId; // Return null if the chat already exists
  }

  //Retrieve All Messages From A Chat
  Stream<List<Map<String, dynamic>>> getChatMessages({required String chatID}) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Send a message
  /// [mediaLink] is the URL of the media file (image/audio) if applicable
  /// [text] is the text message
  /// [messageType] is the type of message (text, image, audio)
  /// [chatID] is the ID of the chat
  /// [senderId] is the ID of the sender
  Future<void> sendMessage(
      {required String chatID,
      String? mediaLink,
      String? text,
      String messageType = 'text'}) async {
    try {
      String? senderId = FirebaseAuth.instance.currentUser?.uid;
      await _firestore
          .collection("chats")
          .doc(chatID)
          .collection("messages")
          .add({
        'senderId': senderId,
        'type': messageType,
        'mediaLink': mediaLink,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error sending image message: $e");
    }
  }

  /// Get all user chats (for chat list)
  /// This retrieves all chats where the user is a member
  /// and orders them by the last message time
  /// this list should be used to display the chat list in Chat Tab of the Home Screen
  /// [userId] is the ID of the user
  Stream<QuerySnapshot> getUserChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Future<String?> getUserAvatorByUserID(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['avator'] as String?;
      } else {
        debugPrint('User document does not exist.');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user avatar: $e');
      return null;
    }
  }
}
