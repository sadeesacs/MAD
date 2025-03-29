// lib/Service Provider/screens/pending_requests/pending_requests.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Adjust to your actual paths:
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';

// The separate card widget file
import 'widgets/pending_requests_card.dart';

// Dummy data for pending requests
final List<Map<String, dynamic>> samplePendingRequests = [
  {
    'bookingId': '#6489303',
    'serviceType': 'Cleaning',
    'customer': 'Leo Perera',
    'serviceName': 'Kitchen Cleaning',
    'date': '2005-02-28',
    'time': '3 PM To 6 PM',
    'estimatedTotal': 'LKR 6000.00',
  },
  {
    'bookingId': '#1112223',
    'serviceType': 'Gardening',
    'customer': 'Dasun Perera',
    'serviceName': 'Full Garden Maintenance',
    'date': '2005-03-01',
    'time': '10 AM To 12 PM',
    'estimatedTotal': 'LKR 5000.00',
  },
];

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({Key? key}) : super(key: key);

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  late List<Map<String, dynamic>> pendingRequests;

  @override
  void initState() {
    super.initState();
    pendingRequests = List<Map<String, dynamic>>.from(samplePendingRequests);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && offset > _lastOffset) {
      if (!_hideNavBar) setState(() => _hideNavBar = true);
    } else if (direction == ScrollDirection.forward && offset < _lastOffset) {
      if (_hideNavBar) setState(() => _hideNavBar = false);
    }
    _lastOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title
                const Text(
                  'Pending Requests',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xFF027335),
                  ),
                ),
                const SizedBox(height: 25),

                // Render each pending request as a separate card
                Column(
                  children: pendingRequests.map((request) {
                    return PendingRequestsCard(
                      bookingData: request,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Floating nav bar with the calendar icon highlighted
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: const ConnectNavBarSP(
                isHomeSelected: false,
                isToolsSelected: false,
                isCalendarSelected: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}