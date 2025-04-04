// lib/Customer/screens/customer_chats/chat_list_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Customer/services/customer_chat_service.dart';
import '../../../Customer/widgets/connect_app_bar.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'chat_screen.dart';
import 'package:connect/Service Provider/screens/dashboard/dashboard_screen.dart'; // Import DashboardScreen

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CustomerChatService _chatService = CustomerChatService();
  String _searchQuery = '';
  // Cache for user data to avoid repeated Firestore lookups
  final Map<String, Map<String, dynamic>> _userDataCache = {};

  @override
  void initState() {
    super.initState();
  }

  // Get user data with caching
  Future<Map<String, dynamic>> _getCachedUserData(String userId) async {
    if (_userDataCache.containsKey(userId)) {
      return _userDataCache[userId]!;
    }

    final userData = await _chatService.getUserData(userId);
    _userDataCache[userId] = userData;
    return userData;
  }

  // Preload user data for better search functionality
  Future<void> _preloadUserData(List<DocumentSnapshot> chats) async {
    // Extract all user IDs from chat participants
    final Set<String> userIds = {};
    for (var chatDoc in chats) {
      final data = chatDoc.data() as Map<String, dynamic>;
      final List<dynamic> participants = data['participants'];

      for (var userId in participants) {
        if (userId != _chatService.currentUserId && !_userDataCache.containsKey(userId)) {
          userIds.add(userId.toString());
        }
      }
    }

    // Fetch user data in parallel
    await Future.wait(
        userIds.map((userId) async {
          final userData = await _chatService.getUserData(userId);
          _userDataCache[userId] = userData;
        })
    );
  }

  // Search in chats using cached user data
  List<DocumentSnapshot> _filterChatsBySearchQuery(List<DocumentSnapshot> chats, String query) {
    if (query.isEmpty) return chats;

    return chats.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> participants = data['participants'];
      final String lastMessage = (data['lastMessage'] ?? '').toString().toLowerCase();

      // Check last message content
      if (lastMessage.contains(query)) {
        return true;
      }

      // Check participant names
      for (var userId in participants) {
        if (userId != _chatService.currentUserId) {
          if (_userDataCache.containsKey(userId)) {
            final userName = _userDataCache[userId]!['name']?.toString().toLowerCase() ?? '';
            if (userName.contains(query)) {
              return true;
            }
          }
        }
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // When the device back button is pressed, redirect to DashboardScreen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: const ConnectAppBar(),
        endDrawer: const SPHamburgerMenu(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Chats" title
                const Text(
                  'Chats',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xFF027335),
                  ),
                ),
                const SizedBox(height: 20),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.toLowerCase();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // List of chats
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _chatService.getChats(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No chats available'));
                      }
                      final allChats = snapshot.data!.docs;
                      // Preload user data for better search
                      _preloadUserData(allChats);
                      // Filter chats based on search query
                      final filteredChats = _filterChatsBySearchQuery(allChats, _searchQuery);
                      // Sort by latest message
                      final sortedChats = _chatService.sortChatsByLatestMessage(filteredChats);
                      if (sortedChats.isEmpty && _searchQuery.isNotEmpty) {
                        return Center(child: Text('No results for "$_searchQuery"'));
                      }
                      return ListView.builder(
                        itemCount: sortedChats.length,
                        itemBuilder: (context, index) {
                          return _buildChatCard(sortedChats[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build profile image
  Widget _buildProfileImage(String imagePath, double width, double height) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultProfileImage(width, height),
      );
    } else {
      final file = File(imagePath);
      return FutureBuilder<bool>(
        future: file.exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: const Center(
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return Image.file(
              file,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildDefaultProfileImage(width, height),
            );
          } else {
            return _buildDefaultProfileImage(width, height);
          }
        },
      );
    }
  }

  // Default profile image placeholder
  Widget _buildDefaultProfileImage(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(width / 2),
      ),
      child: Icon(
        Icons.person,
        size: width * 0.6,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildChatCard(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>? ?? {};
    final chatId = document.id;
    final List<dynamic> participants = data['participants'] as List<dynamic>? ?? [];

    final String? otherUserId = participants.firstWhere(
            (id) => id != _chatService.currentUserId,
        orElse: () => null
    ) as String?;

    if (otherUserId == null) {
      return const SizedBox.shrink();
    }

    final lastMessage = data['lastMessage'] ?? '';
    final Timestamp? lastMessageTime = data['lastMessageTime'];
    final time = _formatTimestamp(lastMessageTime);

    final Map<String, dynamic>? unreadCountMap = data['unreadCount'] as Map<String, dynamic>?;
    final int unreadCount = unreadCountMap?[_chatService.currentUserId.toString()] ?? 0;

    return FutureBuilder<Map<String, dynamic>>(
      future: _getCachedUserData(otherUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final userData = snapshot.data!;
        final String name = userData['name'] ?? 'Unknown';
        final String profilePic = userData['profile_pic'] ?? 'https://via.placeholder.com/150';

        return InkWell(
          onTap: () async {
            await _chatService.markMessagesAsRead(chatId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  chatId: chatId,
                  profilePic: profilePic,
                  userName: name,
                  otherUserId: otherUserId,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                ClipOval(
                  child: _buildProfileImage(profilePic, 50, 50),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    unreadCount > 0
                        ? Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B6B),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      final weekday = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return weekday[date.weekday - 1];
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
