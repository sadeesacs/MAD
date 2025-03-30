import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'widgets/completed_jobs_card.dart';

final List<Map<String, dynamic>> sampleCompletedJobs = [
  {
    'bookingId': '#6489303',
    'serviceType': 'Cleaning',
    'customer': 'Leo Perera',
    'date': '2005-02-28',
    'time': '3 PM To 6 PM',
    'estimatedTotal': 'LKR 6000.00',
    'rating': 3,
    'review': 'The Service was really good. I recommend!',
  },
  {
    'bookingId': '#9876543',
    'serviceType': 'Gardening',
    'customer': 'Nimal Perera',
    'date': '2005-03-01',
    'time': '9 AM To 11 AM',
    'estimatedTotal': 'LKR 4500.00',
    'rating': 5,
    'review': 'Excellent job!',
  },
];

class CompletedJobsScreen extends StatefulWidget {
  const CompletedJobsScreen({Key? key}) : super(key: key);

  @override
  State<CompletedJobsScreen> createState() => _CompletedJobsScreenState();
}

class _CompletedJobsScreenState extends State<CompletedJobsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  late List<Map<String, dynamic>> completedJobs;

  @override
  void initState() {
    super.initState();
    completedJobs = List<Map<String, dynamic>>.from(sampleCompletedJobs);
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
      endDrawer: const SPHamburgerMenu(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Completed Jobs',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xFF027335),
                  ),
                ),
                const SizedBox(height: 20),

                // List of completed jobs
                Column(
                  children: completedJobs.map((job) {
                    return CompletedJobsCard(
                      bookingData: job,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

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
                isCalendarSelected: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
