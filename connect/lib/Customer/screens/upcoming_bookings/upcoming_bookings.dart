// lib/Customer/screens/upcoming_bookings/upcoming_bookings.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import 'widgets/upcoming_history_toggle.dart';
import 'widgets/upcoming_booking_card.dart';
import 'package:connect/Customer/screens/upcoming_bookings/popups/cancel_booking_popup.dart';

// A list of booking items that we'll display in this screen
// Each booking is a map with booking info.
final List<Map<String, dynamic>> sampleBookings = [
  {
    'bookingId': '#6489303',
    'serviceType': 'Cleaning',
    'serviceProvider': 'Leo Perera',
    'serviceName': 'Kitchen Cleaning',
    'date': '2005-02-28',
    'time': '3 PM To 6 PM',
    'estimatedTotal': 'LKR 6000.00',
  },
  {
    'bookingId': '#9012874',
    'serviceType': 'Gardening',
    'serviceProvider': 'Nimal Fernando',
    'serviceName': 'Full Garden Maintenance',
    'date': '2005-03-01',
    'time': '9 AM To 11 AM',
    'estimatedTotal': 'LKR 4000.00',
  },
  // Add more as needed...
];

class UpcomingBookingsScreen extends StatefulWidget {
  const UpcomingBookingsScreen({super.key});

  @override
  State<UpcomingBookingsScreen> createState() => _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends State<UpcomingBookingsScreen> {
  // For the hide/show nav bar animation
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  // Assume these are the user’s upcoming bookings
  late List<Map<String, dynamic>> bookings;

  @override
  void initState() {
    super.initState();
    bookings = List<Map<String, dynamic>>.from(sampleBookings);
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

  // This method is called when the user confirms cancellation in the popup.
  void _onCancelBookingConfirmed(Map<String, dynamic> booking) {
    setState(() {
      bookings.remove(booking);
    });
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
                // Screen title
                const Text(
                  'Bookings',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xFF027335),
                  ),
                ),
                const SizedBox(height: 25),
                // The toggle row: "Upcoming Bookings" & "Booking History"
                // (Upcoming Bookings is highlighted on this screen)
                const UpcomingHistoryToggle(isUpcomingSelected: true),
                const SizedBox(height: 25),
                // The booking cards
                ...bookings.map((booking) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: UpcomingBookingCard(
                      bookingData: booking,
                      onCancel: () {
                        // Show popup for cancellation
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return CancelBookingPopup(
                              bookingInfo: booking,
                              onConfirm: () {
                                Navigator.pop(context); // Close popup
                                _onCancelBookingConfirmed(booking);
                              },
                              onCancel: () {
                                Navigator.pop(context); // Close popup
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          // Floating nav bar with the calendar icon highlighted (Upcoming)
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
