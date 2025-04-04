import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import '../../services/chat_service.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String profilePic;
  final String userName;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.profilePic,
    required this.userName,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Mark messages as read when chat screen opens
    _chatService.markMessagesAsRead(widget.chatId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Add this GestureDetector to handle taps outside the text field
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ConnectAppBarSP(),
        endDrawer: const SPHamburgerMenu(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              // Chat messages
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatService.getMessages(widget.chatId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No messages yet'));
                    }

                    final messages = snapshot.data!.docs;

                    // Mark messages as read when displayed
                    if (messages.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _chatService.markMessagesAsRead(widget.chatId);
                      });
                    }

                    // Scroll to bottom on new messages
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index].data() as Map<String, dynamic>;
                        final isMe = msg['senderId'] == _chatService.currentUserId;
                        return _buildMessageBubble(msg, isMe);
                      },
                    );
                  },
                ),
              ),
              // Input field at bottom
              _buildMessageInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDFE9E3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF027335),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Profile picture - handle both network and local file paths
          ClipOval(
            child: _buildProfileImage(widget.profilePic, 40, 40),
          ),
          const SizedBox(width: 12),
          // Name
          Expanded(
            child: Text(
              widget.userName,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build profile image from either network or file
  Widget _buildProfileImage(String imagePath, double width, double height) {
    // Check if image path is a URL or local file path
    if (imagePath.startsWith('http')) {
      // It's a network image
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultProfileImage(width, height),
      );
    } else {
      // It's a local file path
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
                  width: 20,
                  height: 20,
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
      color: Colors.grey[300],
      child: Icon(
        Icons.person,
        size: width * 0.6,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    // Handle read status safely
    bool isRead = false;
    try {
      final Map<String, dynamic>? readByMap = msg['readBy'] as Map<String, dynamic>?;
      if (readByMap != null) {
        if (!isMe) {
          // For received messages, mark as read
          isRead = true;
        } else {
          // For sent messages, check if other user read it
          isRead = readByMap[widget.otherUserId] == true;
        }
      }
    } catch (e) {
      // Handle any errors in reading the readBy map
      print('Error checking message read status: $e');
    }

    return Container(
      margin: EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: isMe ? 50 : 0,
        right: isMe ? 0 : 50,
      ),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFEDF9EB) : const Color(0xFFF3F5F7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg['text'] ?? '',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTimestamp(msg['timestamp']),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
               
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
 if (mounted) {
          FocusScope.of(context).requestFocus(_messageFocusNode);
        }      });
    });

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 8
            : MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                minLines: 1,
                style: const TextStyle(fontSize: 16),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _onSendMessage(),
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                },
                // Show keyboard immediately when field is focused
                autofocus: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF027335),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _onSendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              iconSize: 20,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  void _onSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await _chatService.sendMessage(widget.chatId, text);
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final date = timestamp.toDate();
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}