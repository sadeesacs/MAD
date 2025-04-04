// lib/Service Provider/screens/pending_requests/pending_requests.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Service%20Provider/screens/dashboard/dashboard_screen.dart'; // Import DashboardScreen
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../services/booking_service.dart';
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'widgets/pending_requests_card.dart';
import 'detail_pending_request.dart';

const Color darkGreen = Color(0xFF027335);
const Color appBarColor = Color(0xFFF1FAF1);
const Color white = Colors.white;

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;
  final BookingService _bookingService = BookingService();
  final Map<String, Map<String, dynamic>> _customerDataCache = {};
  final Map<String, Map<String, dynamic>> _serviceDataCache = {};
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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

  Future<Map<String, dynamic>> _getCachedCustomerData(dynamic customer) async {
    final customerId = customer is DocumentReference
        ? customer.id
        : customer.toString().split('/').last;
    if (_customerDataCache.containsKey(customerId)) {
      return _customerDataCache[customerId]!;
    }
    final userData = await _bookingService.getCustomerData(customer);
    _customerDataCache[customerId] = userData;
    return userData;
  }

  Future<Map<String, dynamic>> _getCachedServiceData(dynamic service) async {
    final serviceId = service is DocumentReference
        ? service.id
        : service.toString().split('/').last;
    if (_serviceDataCache.containsKey(serviceId)) {
      return _serviceDataCache[serviceId]!;
    }
    final serviceData = await _bookingService.getServiceData(service);
    _serviceDataCache[serviceId] = serviceData;
    return serviceData;
  }

  Map<String, dynamic> _createBookingDataForDisplay(
      String docId,
      Map<String, dynamic> data,
      Map<String, dynamic> customerData,
      Map<String, dynamic> serviceData) {
    final dateStr = data['date'] is Timestamp
        ? _bookingService.formatTimestamp(data['date'] as Timestamp)
        : data['date']?.toString() ?? '';
    return {
      'bookingId': docId,
      'serviceType': serviceData['category'] ?? 'Unknown Service',
      'serviceName': serviceData['serviceName'] ?? 'Unknown Service',
      'customer': customerData['name'] ?? 'Unknown Customer',
      'customerData': customerData,
      'customerRef': data['customer'],
      'date': dateStr,
      'time': data['time'] ?? '',
      'total': data['total'] ?? '',
      'district': data['district'] ?? '',
      'additional_notes': data['additional_notes'] ?? '',
      'location': data['location'],
    };
  }

  Future<List<DocumentSnapshot>> _filterBookingsByServiceProvider(
      List<DocumentSnapshot> bookings) async {
    return await _bookingService.filterBookingsByCurrentProvider(bookings);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Redirect to DashboardScreen when back button is pressed.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: const ConnectAppBarSP(),
        endDrawer: const SPHamburgerMenu(),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _bookingService.getPendingRequests(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Error in StreamBuilder: ${snapshot.error}');
                  return const Center(child: Text('Error: Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  print('No pending requests found in Firestore.');
                  return const Center(child: Text('No pending requests available'));
                }
                final allPendingRequests = snapshot.data!.docs;
                print('Found ${allPendingRequests.length} pending requests in Firestore');

                return FutureBuilder<List<DocumentSnapshot>>(
                  future: _filterBookingsByServiceProvider(allPendingRequests),
                  builder: (context, filteredSnapshot) {
                    if (filteredSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (filteredSnapshot.hasError) {
                      return Center(child: Text('Error filtering requests: ${filteredSnapshot.error}'));
                    }
                    final pendingRequests = filteredSnapshot.data ?? [];
                    if (pendingRequests.isEmpty) {
                      return const Center(child: Text('No pending requests for you'));
                    }

                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Column(
                            children: pendingRequests.map((doc) {
                              final bookingData = doc.data() as Map<String, dynamic>;
                              return FutureBuilder(
                                future: Future.wait([
                                  _getCachedCustomerData(bookingData['customer'] ?? ''),
                                  _getCachedServiceData(bookingData['service'] ?? '')
                                ]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Center(child: CircularProgressIndicator()),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Center(child: Text('Error loading data')),
                                        ),
                                      ),
                                    );
                                  }
                                  final data = snapshot.data as List<dynamic>;
                                  final customerData = data[0] as Map<String, dynamic>;
                                  final serviceData = data[1] as Map<String, dynamic>;
                                  final displayData = _createBookingDataForDisplay(
                                    doc.id,
                                    bookingData,
                                    customerData,
                                    serviceData,
                                  );
                                  return PendingRequestsCard(
                                    bookingData: displayData,
                                    onDetailsPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DetailPendingRequestScreen(
                                            bookingData: displayData,
                                            bookingId: doc.id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  },
                );
              },
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
                  isCalendarSelected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
