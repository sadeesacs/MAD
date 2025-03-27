import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../upcoming_bookings/upcoming_bookings.dart';
import '../upcoming_bookings/widgets/upcoming_history_toggle.dart';
import 'widgets/booking_history_card.dart';

final List<Map<String, dynamic>> sampleHistoryBookings = [
  {
    'bookingId': '#6489303',
    'serviceType': 'Cleaning',
    'serviceProvider': 'Leo Perera',
    'serviceName': 'Kitchen Cleaning',
    'date': '2005-02-28',
    'time': '3 PM To 6 PM',
    'total': 'LKR 6000.00',
  },
  {
    'bookingId': '#1112223',
    'serviceType': 'Gardening',
    'serviceProvider': 'Nimal Perera',
    'serviceName': 'Full Garden Trim',
    'date': '2005-02-15',
    'time': '1 PM To 3 PM',
    'total': 'LKR 2000.00',
  },
];

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  late List<Map<String, dynamic>> historyBookings;

  @override
  void initState() {
    super.initState();
    historyBookings = List<Map<String, dynamic>>.from(sampleHistoryBookings);
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
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Screen Title
                const Text(
                  'Bookings',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xFF027335),
                  ),
                ),
                const SizedBox(height: 20),

                UpcomingHistoryToggle(
                  isUpcomingSelected: false,
                  onUpcomingPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpcomingBookingsScreen(),
                      ),
                    );
                  },
                  onHistoryPressed: () {
                  },
                ),
                const SizedBox(height: 20),

                // Display booking history cards
                Column(
                  children: historyBookings.map((booking) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: BookingHistoryCard(
                        bookingData: booking,
                      ),
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
              child: const ConnectNavBar(
                isHomeSelected: false,
                isUpcomingSelected: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}