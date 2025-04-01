import 'package:flutter/material.dart';

import '../../widgets/connect_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final String profilePic;
  final String userName;

  const ChatScreen({
    Key? key,
    required this.profilePic,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'user',
      'text': 'Hi there! Nice to meet you!.',
    },
    {
      'sender': 'user',
      'text':
      "I'm John and today I'm going to help you to find your perfect Webflow Template 🧑‍💻",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
            // Input field at bottom
            _buildMessageInputBar(),
          ],
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
          // Profile picture
          ClipOval(
            child: Image.asset(
              widget.profilePic,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Name
          Text(
            widget.userName,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    bool isMe = (msg['sender'] == 'me');
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
        child: Text(
          msg['text'],
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      color: Colors.white,
      child: Row(
        children: [
          // Text field
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Message',
                border: InputBorder.none,
              ),
            ),
          ),
          // Send button
          IconButton(
            onPressed: _onSendMessage,
            icon: const Icon(
              Icons.send,
              color: Color(0xFF027335),
            ),
          ),
        ],
      ),
    );
  }

  void _onSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'me',
        'text': text,
      });
    });
    _messageController.clear();
  }
}