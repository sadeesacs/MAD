import 'package:connect/Service%20Provider/screens/scheduled_jobs/widgets/scheduled_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar_sp.dart' show ConnectAppBarSP;
import '../../widgets/connect_nav_bar_sp.dart' show ConnectNavBarSP;

const Color darkGreen = Color(0xFF027335);
const Color appBarColor = Color(0xFFF1FAF1);
const Color white = Colors.white;

class ScheduledJobsScreen extends StatefulWidget {
  const ScheduledJobsScreen({super.key});

  @override
  _ScheduledJobsScreenState createState() => _ScheduledJobsScreenState();
}

class _ScheduledJobsScreenState extends State<ScheduledJobsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;

    // Hide nav bar on scroll down, show on scroll up
    if (direction == ScrollDirection.reverse && offset > _lastOffset) {
      if (!_hideNavBar) {
        setState(() => _hideNavBar = true);
      }
    } else if (direction == ScrollDirection.forward && offset < _lastOffset) {
      if (_hideNavBar) {
        setState(() => _hideNavBar = false);
      }
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
      backgroundColor: white,
      appBar: const ConnectAppBarSP(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scheduled Jobs',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),

                // Job Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3, // Replace with your actual data length
                  itemBuilder: (context, index) {
                    return ScheduledJobCard(
                      bookingId: '#6489303',
                      serviceType: 'Cleaning',
                      customerName: 'Leo Perera',
                      date: '2005-02-28',
                      time: '3 PM To 6 PM',
                      estimatedTotal: 'LKR 6000.00',
                    );
                  },
                ),
              ],
            ),
          ),

          // Floating Nav Bar that hides on scroll
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: ConnectNavBarSP(
                isHomeSelected: false,
                isToolsSelected: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScheduledJobsScreen(),
  ));
}