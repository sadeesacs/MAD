import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../booking_history/booking_history.dart';
import 'widgets/upcoming_history_toggle.dart';
import 'widgets/upcoming_booking_card.dart';
import 'popups/cancel_booking_popup.dart';

class UpcomingBookingsScreen extends StatefulWidget {
  const UpcomingBookingsScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingBookingsScreen> createState() => _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends State<UpcomingBookingsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  /// We’ll store the fetched booking docs here so we can remove them after cancellation.
  late Future<List<DocumentSnapshot>> _futureBookingDocs;

  @override
  void initState() {
    super.initState();
    // Begin listening to scroll for hiding nav bar.
    _scrollController.addListener(_onScroll);
    // Fetch upcoming bookings once (FutureBuilder).
    _futureBookingDocs = _fetchUpcomingBookings();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll logic: show/hide bottom nav bar.
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

  /// Query Firestore for all bookings for the current user, except `status == "completed"`.
  Future<List<DocumentSnapshot>> _fetchUpcomingBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log('No user is signed in!');
      return [];
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Example: if your "booking" docs store "customer" as a reference to /users/uid
    Query query = FirebaseFirestore.instance
        .collection('bookings')
        .where('customer', isEqualTo: userRef)
        .where('status', isNotEqualTo: 'completed');

    final QuerySnapshot snapshot = await query.get();
    return snapshot.docs;
  }

  /// Called when "Cancel" is confirmed in the popup. We update the booking’s status
  /// to "cancelled" in Firestore, then remove it from our local list so it disappears.
  void _onCancelBookingConfirmed(
      List<DocumentSnapshot> bookingDocs, DocumentSnapshot bookingDoc) async {
    try {
      // Update the booking doc's status to "cancelled".
      await bookingDoc.reference.update({'status': 'cancelled'});

      // Remove from the in-memory list so UI updates.
      setState(() {
        bookingDocs.removeWhere((doc) => doc.id == bookingDoc.id);
      });
    } catch (e) {
      log('Error cancelling booking: $e');
    }
  }

  /// Show the confirmation popup for cancellation.
  void _showCancelPopup(
      BuildContext context,
      List<DocumentSnapshot> bookingDocs,
      DocumentSnapshot bookingDoc,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CancelBookingPopup(
          bookingInfo: {
            // We can pass any data if we want to show in the popup.
            // For now, let's just pass "bookingId".
            'bookingId': '#${bookingDoc.id.substring(0, 8)}',
          },
          onConfirm: () {
            Navigator.pop(context); // Close popup
            _onCancelBookingConfirmed(bookingDocs, bookingDoc);
          },
          onCancel: () {
            Navigator.pop(context); // Close popup
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          FutureBuilder<List<DocumentSnapshot>>(
            future: _futureBookingDocs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    'No upcoming bookings found.',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF027335),
                    ),
                  ),
                );
              }

              final bookingDocs = snapshot.data!;
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
                    // Upcoming / History Toggle
                    UpcomingHistoryToggle(
                      isUpcomingSelected: true,
                      onUpcomingPressed: () {
                        // Already on upcoming screen, do nothing.
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

                    // Render each booking doc
                    ...bookingDocs.map((doc) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: _buildUpcomingBookingCard(bookingDocs, doc),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
          // Slide-in bottom nav bar
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

  /// Builds a single upcoming booking card. We’ll fetch the associated service doc
  /// (and provider doc) so we can display "serviceType", "serviceProvider", "serviceName".
  Widget _buildUpcomingBookingCard(
      List<DocumentSnapshot> bookingDocs,
      DocumentSnapshot bookingDoc,
      ) {
    final data = bookingDoc.data() as Map<String, dynamic>;
    // We'll display a pseudo-random booking ID by using part of the doc.id:
    final bookingId = '#${bookingDoc.id.substring(0, 8)}';

    // We'll show "date" as a string. The doc has a Firestore Timestamp in data['date'].
    DateTime? dateTime;
    if (data['date'] != null && data['date'] is Timestamp) {
      dateTime = (data['date'] as Timestamp).toDate();
    }
    final dateString = (dateTime != null)
        ? '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}'
        : 'Unknown';

    final timeString = data['time'] ?? 'N/A';
    final totalString = data['total'] ?? 'LKR 0.00';

    // We'll do a FutureBuilder to fetch the "service" doc for service type, name, provider, etc.
    final DocumentReference? serviceRef = data['service'];
    if (serviceRef == null) {
      // If no "service" reference, build the card with unknown service fields:
      return UpcomingBookingCard(
        bookingData: {
          'bookingId': bookingId,
          'serviceType': 'Unknown',
          'serviceProvider': 'Unknown',
          'serviceName': 'Unknown',
          'date': dateString,
          'time': timeString,
          'estimatedTotal': totalString,
        },
        onCancel: () => _showCancelPopup(context, bookingDocs, bookingDoc),
      );
    }

    // If there's a valid service doc, fetch it.
    return FutureBuilder<DocumentSnapshot>(
      future: serviceRef.get(),
      builder: (context, serviceSnap) {
        if (serviceSnap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (serviceSnap.hasError ||
            !serviceSnap.hasData ||
            !serviceSnap.data!.exists) {
          // If error or service doc doesn't exist:
          return UpcomingBookingCard(
            bookingData: {
              'bookingId': bookingId,
              'serviceType': 'Unknown',
              'serviceProvider': 'Unknown',
              'serviceName': 'Unknown',
              'date': dateString,
              'time': timeString,
              'estimatedTotal': totalString,
            },
            onCancel: () => _showCancelPopup(context, bookingDocs, bookingDoc),
          );
        }

        // We have service data
        final serviceData = serviceSnap.data!.data() as Map<String, dynamic>;
        final serviceType = serviceData['category'] ?? 'Unknown';
        final serviceName = serviceData['serviceName'] ?? 'Unknown';

        // Now fetch the provider user doc from 'serviceProvider' field:
        final DocumentReference? providerRef = serviceData['serviceProvider'];
        if (providerRef == null) {
          // If no provider reference, show fallback
          return UpcomingBookingCard(
            bookingData: {
              'bookingId': bookingId,
              'serviceType': serviceType,
              'serviceProvider': 'Unknown',
              'serviceName': serviceName,
              'date': dateString,
              'time': timeString,
              'estimatedTotal': totalString,
            },
            onCancel: () => _showCancelPopup(context, bookingDocs, bookingDoc),
          );
        }

        // Nested FutureBuilder for the provider doc
        return FutureBuilder<DocumentSnapshot>(
          future: providerRef.get(),
          builder: (context, providerSnap) {
            if (providerSnap.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (providerSnap.hasError ||
                !providerSnap.hasData ||
                !providerSnap.data!.exists) {
              return UpcomingBookingCard(
                bookingData: {
                  'bookingId': bookingId,
                  'serviceType': serviceType,
                  'serviceProvider': 'Unknown',
                  'serviceName': serviceName,
                  'date': dateString,
                  'time': timeString,
                  'estimatedTotal': totalString,
                },
                onCancel: () =>
                    _showCancelPopup(context, bookingDocs, bookingDoc),
              );
            }

            final providerData =
            providerSnap.data!.data() as Map<String, dynamic>;
            final providerName = providerData['displayName'] ??
                providerData['name'] ??
                'Unknown';

            // Finally, build the card with all data
            return UpcomingBookingCard(
              bookingData: {
                'bookingId': bookingId,
                'serviceType': serviceType,
                'serviceProvider': providerName,
                'serviceName': serviceName,
                'date': dateString,
                'time': timeString,
                'estimatedTotal': totalString,
              },
              onCancel: () => _showCancelPopup(context, bookingDocs, bookingDoc),
            );
          },
        );
      },
    );
  }
}
