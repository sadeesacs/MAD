import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

// Your custom imports
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../upcoming_bookings/upcoming_bookings.dart';
import '../upcoming_bookings/widgets/upcoming_history_toggle.dart';
import 'widgets/booking_history_card.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
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

  /// Return a stream of the current user's bookings that are "completed".
  Stream<QuerySnapshot> _getCompletedBookings() {
    final user = _auth.currentUser;
    if (user == null) {
      // If no user is signed in, return an empty stream
      return const Stream.empty();
    }

    // Build a reference to the current user doc
    final userDocRef = _firestore.collection('users').doc(user.uid);

    // Only get documents with status = "completed" for that user
    return _firestore
        .collection('booking')
        .where('customer', isEqualTo: userDocRef)
        .where('status', isEqualTo: 'completed')
        .snapshots();
  }

  /// Build a single booking card for the bookingDoc.
  Widget _buildBookingCard(DocumentSnapshot bookingDoc) {
    final bookingData = bookingDoc.data() as Map<String, dynamic>;

    // A random "bookingId" display: substring of doc ID
    final docId = bookingDoc.id;
    final displayedBookingId = "#${docId.substring(0, 6)}";

    // Format date from Timestamp
    final Timestamp? dateTs = bookingData['date'];
    final dateString = (dateTs != null)
        ? "${dateTs.toDate().year}-${dateTs.toDate().month.toString().padLeft(2, '0')}-${dateTs.toDate().day.toString().padLeft(2, '0')}"
        : '';
    final time = bookingData['time'] ?? '';
    final total = bookingData['total'] ?? '';

    // We'll fetch the service doc to get the serviceName, category, provider name, etc.
    final serviceRef = bookingData['service'] as DocumentReference?;
    if (serviceRef == null) {
      // If no service ref, just display minimal data
      return BookingHistoryCard(
        bookingDocId: docId,
        bookingData: {
          'bookingId': displayedBookingId,
          'serviceType': '[No service]',
          'serviceProvider': '[No provider]',
          'serviceName': '[No name]',
          'date': dateString,
          'time': time,
          'total': total,
        },
      );
    }

    // Nested FutureBuilder to fetch service doc
    return FutureBuilder<DocumentSnapshot>(
      future: serviceRef.get(),
      builder: (context, serviceSnap) {
        if (serviceSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!serviceSnap.hasData || !serviceSnap.data!.exists) {
          return const Text("Error loading service details");
        }

        final serviceData = serviceSnap.data!.data() as Map<String, dynamic>;
        final serviceType = serviceData['category'] ?? '';
        final serviceName = serviceData['serviceName'] ?? '';

        // Next, fetch provider doc if we want the provider's name
        final providerRef = serviceData['serviceProvider'] as DocumentReference?;
        if (providerRef == null) {
          return BookingHistoryCard(
            bookingDocId: docId,
            bookingData: {
              'bookingId': displayedBookingId,
              'serviceType': serviceType,
              'serviceProvider': '[No provider ref]',
              'serviceName': serviceName,
              'date': dateString,
              'time': time,
              'total': total,
            },
          );
        }

        return FutureBuilder<DocumentSnapshot>(
          future: providerRef.get(),
          builder: (context, providerSnap) {
            if (providerSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!providerSnap.hasData || !providerSnap.data!.exists) {
              return BookingHistoryCard(
                bookingDocId: docId,
                bookingData: {
                  'bookingId': displayedBookingId,
                  'serviceType': serviceType,
                  'serviceProvider': '[No provider data]',
                  'serviceName': serviceName,
                  'date': dateString,
                  'time': time,
                  'total': total,
                },
              );
            }

            final providerData = providerSnap.data!.data() as Map<String, dynamic>;
            final providerName = providerData['name'] ?? '';

            // Finally we have all the data needed to build the card
            return BookingHistoryCard(
              bookingDocId: docId,
              bookingData: {
                'bookingId': displayedBookingId,
                'serviceType': serviceType,
                'serviceProvider': providerName,
                'serviceName': serviceName,
                'date': dateString,
                'time': time,
                'total': total,
              },
            );
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
          StreamBuilder<QuerySnapshot>(
            stream: _getCompletedBookings(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading booking history."));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(
                  child: Text("No completed bookings found."),
                );
              }

              return SingleChildScrollView(
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

                    // Toggle
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
                        // Already on booking history screen
                      },
                    ),
                    const SizedBox(height: 20),

                    // Display booking history cards
                    Column(
                      children: docs.map((bookingDoc) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildBookingCard(bookingDoc),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),

          // Hide nav bar on scroll
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: const ConnectNavBar(
                isHomeSelected: false,
                // Because we used "isUpcomingSelected: true" in the original design,
                // you may adjust as needed. This toggling is up to your design.
                isUpcomingSelected: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
