import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get all chats for current user
  Stream<QuerySnapshot> getChats() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots();
  }

  // Get messages for a specific chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Mark messages as read when user opens a chat
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      // Option 2: Workaround by using a simpler query and filtering client-side
      // Get all messages for this chat where sender is not current user
      final messagesQuery = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isNotEqualTo: currentUserId)
          .get();
      
      // Filter in application code to find unread messages
      final unreadMessages = messagesQuery.docs.where((doc) {
        final data = doc.data();
        final Map<String, dynamic> readBy = data['readBy'] as Map<String, dynamic>? ?? {};
        return readBy[currentUserId] == false;
      }).toList();
      
      // Create a batch to update multiple documents efficiently
      final batch = _firestore.batch();
      for (var doc in unreadMessages) {
        batch.update(doc.reference, {
          'readBy.${currentUserId}': true,
        });
      }
      
      // Commit the batch if there are unread messages
      if (unreadMessages.isNotEmpty) {
        await batch.commit();
      }
      
      // Update the unread count in the chat document
      await _firestore.collection('chats').doc(chatId).update({
        'unreadCount.${currentUserId}': 0,
      });
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Get user data from users collection
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        // Return default values if user not found
        return {
          'name': 'Unknown User',
          'profile_pic': 'https://via.placeholder.com/150',
        };
      }
    } catch (e) {
      print('Error getting user data: $e');
      return {
        'name': 'Unknown User',
        'profile_pic': 'https://via.placeholder.com/150',
      };
    }
  }

  // Send a message
  Future<void> sendMessage(String chatId, String message) async {
    final timestamp = Timestamp.now();
    
    // Get the chat to find all participants
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    final data = chatDoc.data() as Map<String, dynamic>;
    final List<dynamic> participants = data['participants'];
    
    // Create readBy map with status for each participant
    // Current user has read the message, others haven't
    Map<String, bool> readBy = {};
    for (var userId in participants) {
      readBy[userId] = userId == currentUserId;
    }
    
    // Add message to the messages subcollection
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'text': message,
      'senderId': currentUserId,
      'timestamp': timestamp,
      'readBy': readBy,
    });
    
    // Update chat document with last message info and increment unread counts
    Map<String, dynamic> updateData = {
      'lastMessage': message,
      'lastMessageTime': timestamp,
    };
    
    // Increment unread count for all participants except the sender
    for (var userId in participants) {
      if (userId != currentUserId) {
        updateData['unreadCount.${userId}'] = FieldValue.increment(1);
      }
    }
    
    await _firestore.collection('chats').doc(chatId).update(updateData);
  }

  // Create a new chat or get existing chat
  Future<String> createOrGetChat(String otherUserId) async {
    // Check if chat already exists
    final query = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();
    
    for (var doc in query.docs) {
      List participants = doc['participants'];
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }
    
    // Create new chat if it doesn't exist
    final chatDoc = await _firestore.collection('chats').add({
      'participants': [currentUserId, otherUserId],
      'lastMessage': '',
      'lastMessageTime': Timestamp.now(),
      'createdAt': Timestamp.now(),
      'unreadCount': {
        currentUserId: 0,
        otherUserId: 0,
      }
    });
    
    return chatDoc.id;
  }
  
  // Function to sort chats client-side (useful when you can't use server-side ordering)
  List<DocumentSnapshot> sortChatsByLatestMessage(List<DocumentSnapshot> chats) {
    chats.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;
      final bData = b.data() as Map<String, dynamic>;
      
      final Timestamp? aTime = aData['lastMessageTime'];
      final Timestamp? bTime = bData['lastMessageTime'];
      
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      
      // Sort in descending order (newest first)
      return bTime.compareTo(aTime);
    });
    
    return chats;
  }
}
