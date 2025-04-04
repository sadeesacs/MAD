// lib/Customer/screens/upcoming_bookings/upcoming_bookings.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:connect/Customer/screens/home/home_screen.dart'; // Import HomeScreen
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../booking_history/booking_history.dart';
import 'widgets/upcoming_history_toggle.dart';
import 'widgets/upcoming_booking_card.dart';
import 'popups/cancel_booking_popup.dart';

class UpcomingBookingsScreen extends StatefulWidget {
  const UpcomingBookingsScreen({super.key});

  @override
  State<UpcomingBookingsScreen> createState() => _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends State<UpcomingBookingsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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

  /// Deletes the booking document from Firestore.
  Future<void> _deleteBooking(DocumentSnapshot bookingDoc) async {
    await bookingDoc.reference.delete();
  }

  /// Retrieves all bookings for the logged-in customer.
  /// We use the user's document reference to match the 'customer' field.
  Stream<QuerySnapshot> _getUpcomingBookings() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    final userDocRef = _firestore.collection('users').doc(user.uid);
    return _firestore
        .collection('booking')
        .where('customer', isEqualTo: userDocRef)
        .snapshots();
  }

  /// Builds a booking card for each booking document.
  /// This uses nested FutureBuilders to fetch the service details and the service provider's name.
  Widget _buildBookingCard(BuildContext context, DocumentSnapshot bookingDoc) {
    final bookingData = bookingDoc.data() as Map<String, dynamic>;
    final status = bookingData['status'] ?? '';
    // Skip if the booking is completed.
    if (status.toLowerCase() == "completed") {
      return const SizedBox.shrink();
    }

    // Generate a random display booking ID using the document ID.
    final docId = bookingDoc.id;
    final displayedBookingId = "#${docId.substring(0, 6)}";

    // Format the date.
    final Timestamp? dateTs = bookingData['date'];
    final String dateString = dateTs != null
        ? "${dateTs.toDate().year}-${dateTs.toDate().month.toString().padLeft(2, '0')}-${dateTs.toDate().day.toString().padLeft(2, '0')}"
        : '';
    final String timeString = bookingData['time'] ?? '';
    final String totalString = bookingData['total'] ?? '';

    // Get the service reference from the booking.
    final serviceRef = bookingData['service'] as DocumentReference?;
    if (serviceRef == null) {
      return UpcomingBookingCard(
        bookingData: {
          'bookingId': displayedBookingId,
          'serviceType': '[No service]',
          'serviceProvider': '[No provider]',
          'serviceName': '[No serviceName]',
          'date': dateString,
          'time': timeString,
          'estimatedTotal': totalString,
        },
        onCancel: () {
          _showCancelDialog(context, bookingDoc);
        },
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: serviceRef.get(),
      builder: (context, serviceSnap) {
        if (serviceSnap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!serviceSnap.hasData || !serviceSnap.data!.exists) {
          return const Text("Error loading service details");
        }
        final serviceData = serviceSnap.data!.data() as Map<String, dynamic>;
        final serviceType = serviceData['category'] ?? '';
        final serviceName = serviceData['serviceName'] ?? '';

        // Now fetch the service provider document.
        final providerRef = serviceData['serviceProvider'] as DocumentReference?;
        if (providerRef == null) {
          return UpcomingBookingCard(
            bookingData: {
              'bookingId': displayedBookingId,
              'serviceType': serviceType,
              'serviceProvider': '[No provider]',
              'serviceName': serviceName,
              'date': dateString,
              'time': timeString,
              'estimatedTotal': totalString,
            },
            onCancel: () {
              _showCancelDialog(context, bookingDoc);
            },
          );
        }

        return FutureBuilder<DocumentSnapshot>(
          future: providerRef.get(),
          builder: (context, providerSnap) {
            if (providerSnap.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (!providerSnap.hasData || !providerSnap.data!.exists) {
              return UpcomingBookingCard(
                bookingData: {
                  'bookingId': displayedBookingId,
                  'serviceType': serviceType,
                  'serviceProvider': '[No provider data]',
                  'serviceName': serviceName,
                  'date': dateString,
                  'time': timeString,
                  'estimatedTotal': totalString,
                },
                onCancel: () {
                  _showCancelDialog(context, bookingDoc);
                },
              );
            }
            final providerData = providerSnap.data!.data() as Map<String, dynamic>;
            final providerName = providerData['name'] ?? '';

            return UpcomingBookingCard(
              bookingData: {
                'bookingId': displayedBookingId,
                'serviceType': serviceType,
                'serviceProvider': providerName,
                'serviceName': serviceName,
                'date': dateString,
                'time': timeString,
                'estimatedTotal': totalString,
              },
              onCancel: () {
                _showCancelDialog(context, bookingDoc);
              },
            );
          },
        );
      },
    );
  }

  /// Displays the cancellation popup.
  void _showCancelDialog(BuildContext context, DocumentSnapshot bookingDoc) {
    final docId = bookingDoc.id;
    final displayedBookingId = "#${docId.substring(0, 6)}";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CancelBookingPopup(
          bookingInfo: {
            'bookingId': displayedBookingId,
          },
          onConfirm: () async {
            Navigator.pop(context);
            await _deleteBooking(bookingDoc);
          },
          onCancel: () {
            Navigator.pop(context);
          },
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Redirect back to HomeScreen when back button is pressed.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const ConnectAppBar(),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _getUpcomingBookings(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading bookings."),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                return SingleChildScrollView(
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
                      // Toggle widget to switch between Upcoming and History
                      UpcomingHistoryToggle(
                        isUpcomingSelected: true,
                        onUpcomingPressed: () {
                          // Already on Upcoming Bookings screen.
                        },
                        onHistoryPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BookingHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      // Render booking cards.
                      ...docs.map((bookingDoc) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: _buildBookingCard(context, bookingDoc),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
            // Floating navigation bar that hides on scroll.
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
      ),
    );
  }
}
