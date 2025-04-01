import 'package:flutter/material.dart';
import '../../widgets/connect_app_bar.dart';
import 'customer_chat_screen.dart';

final List<Map<String, dynamic>> sampleChats = [
  {
    'profilePic': 'assets/images/profile_pic/profile1.png',
    'name': 'Victoria Avila',
    'lastMessage': "That's great, I look forward to hearing back!",
    'time': '11:20 am',
    'unreadCount': 1,
  },
  {
    'profilePic': 'assets/images/profile_pic/ftd.png',
    'name': 'Fitted - Tech & Design',
    'lastMessage': 'Thecla: @Ovo How is it going?',
    'time': '11:11 am',
    'unreadCount': 2,
  },
  {
    'profilePic': 'assets/images/profile_pic/profile2.png',
    'name': 'Demola Andreas',
    'lastMessage': 'Job Description.docx',
    'time': 'Yesterday',
    'unreadCount': 1,
  },
];

class CustomerChatListScreen extends StatefulWidget {
  const CustomerChatListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<CustomerChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> chats = [];

  @override
  void initState() {
    super.initState();
    chats = List<Map<String, dynamic>>.from(sampleChats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
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
                    // Filter logic if needed
                  },
                ),
              ),
              const SizedBox(height: 20),

              // List of chats
              Expanded(
                child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return _buildChatCard(chat);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    final String profilePic  = chat['profilePic'];
    final String name        = chat['name'];
    final String lastMessage = chat['lastMessage'];
    final String time        = chat['time'];
    final int unreadCount    = chat['unreadCount'] ?? 0;

    return InkWell(
      onTap: () {
        // Navigate to chat screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              profilePic: profilePic,
              userName: name,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Profile Picture
            ClipOval(
              child: Image.asset(
                profilePic,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Name + last message
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
            // Time + unread
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
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
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
  }
}