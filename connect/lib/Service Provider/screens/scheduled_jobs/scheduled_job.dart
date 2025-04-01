import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../services/booking_service.dart';
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'widgets/scheduled_job_card.dart';
import '../../screens/booking_details-scheduled_jobs/bookings_details_jobs.dart';

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
  final BookingService _bookingService = BookingService();
  bool _hideNavBar = false;
  double _lastOffset = 0;
  final Map<String, Map<String, dynamic>> _customerDataCache = {};
  final Map<String, Map<String, dynamic>> _serviceDataCache = {};

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

  // Get customer data with caching
  Future<Map<String, dynamic>> _getCachedCustomerData(dynamic customer) async {
    String customerId;

    // Extract the ID from the DocumentReference or handle it as a String
    if (customer is DocumentReference) {
      customerId = customer.id;
    } else if (customer is String && customer.contains('/')) {
      // Handle path-like strings "/users/userId"
      customerId = customer.split('/').last;
    } else {
      // Assume it's a direct user ID
      customerId = customer.toString();
    }

    if (_customerDataCache.containsKey(customerId)) {
      return _customerDataCache[customerId]!;
    }

    final userData = await _bookingService.getCustomerData(customer);
    _customerDataCache[customerId] = userData;
    return userData;
  }

  // Get service data with caching
  Future<Map<String, dynamic>> _getCachedServiceData(dynamic service) async {
    String serviceId;

    // Extract the ID from the DocumentReference or handle it as a String
    if (service is DocumentReference) {
      serviceId = service.id;
    } else if (service is String && service.contains('/')) {
      // Handle path-like strings "/services/serviceId"
      serviceId = service.split('/').last;
    } else {
      // Assume it's a direct service ID
      serviceId = service.toString();
    }

    if (_serviceDataCache.containsKey(serviceId)) {
      return _serviceDataCache[serviceId]!;
    }

    final serviceData = await _bookingService.getServiceData(service);
    _serviceDataCache[serviceId] = serviceData;
    return serviceData;
  }

  // Handle booking completion
  void _completeBooking(String bookingId) async {
    try {
      await _bookingService.updateBookingStatus(bookingId, 'completed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job marked as completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing job: $e')),
      );
    }
  }

  // Handle booking cancellation
  void _cancelBooking(String bookingId) async {
    try {
      await _bookingService.updateBookingStatus(bookingId, 'cancelled');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking has been cancelled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling booking: $e')),
      );
    }
  }
  
  // Process job data for display
  Map<String, dynamic> _createJobDataForDisplay(String docId, Map<String, dynamic> data, 
      Map<String, dynamic> customerData, Map<String, dynamic> serviceData) {
    // Extract location data - preserve the original object type
    final location = data['location'];

    // Format date from Timestamp
    String formattedDate = '';
    if (data['date'] is Timestamp) {
      formattedDate = _bookingService.formatTimestamp(data['date'] as Timestamp);
    } else if (data['date'] is String) {
      formattedDate = data['date'];
    }

    return {
      'bookingId': docId,
      'serviceType': serviceData['category'] ?? 'Unknown Service',
      'serviceName': serviceData['serviceName'] ?? 'Unknown Service',
      'customerName': customerData['name'] ?? 'Unknown Customer',
      'customerData': customerData,
      'customer': data['customer'],
      'date': formattedDate, // Ensure date is a String
      'time': data['time'] ?? '',
      'total': data['total'] ?? '',
      'district': data['district'] ?? '',
      'additional_notes': data['additional_notes'] ?? '',
      'location': location, // Pass the location as is, without type conversion
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBarSP(),
      endDrawer: const SPHamburgerMenu(),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _bookingService.getScheduledJobs(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No scheduled jobs'));
              }

              final allScheduledJobs = snapshot.data!.docs;

              // Filter jobs to only show those for the current service provider
              return FutureBuilder<List<DocumentSnapshot>>(
                future: _bookingService.filterBookingsByCurrentProvider(allScheduledJobs),
                builder: (context, filteredSnapshot) {
                  if (filteredSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (filteredSnapshot.hasError) {
                    return Center(child: Text('Error: ${filteredSnapshot.error}'));
                  }
                  
                  final scheduledJobs = filteredSnapshot.data ?? [];
                  
                  if (scheduledJobs.isEmpty) {
                    return const Center(child: Text('No scheduled jobs for you'));
                  }

                  return SingleChildScrollView(
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

                        // Preload customer and service data
                        FutureBuilder(
                          future: Future.wait([
                            ...scheduledJobs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return _getCachedCustomerData(data['customer']); 
                            }),
                            ...scheduledJobs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return _getCachedServiceData(data['service']);
                            })
                          ]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            
                            return Column(
                              children: scheduledJobs.map((doc) {
                                final jobData = doc.data() as Map<String, dynamic>;
                                final customer = jobData['customer'];
                                final service = jobData['service'];
                                
                                // Extract IDs for cache lookup
                                String customerId = (customer is DocumentReference) ? customer.id : customer.toString();
                                String serviceId = (service is DocumentReference) ? service.id : service.toString();
                                
                                final customerData = _customerDataCache[customerId] ?? 
                                    {'name': 'Loading...', 'profile_pic': ''};
                                final serviceData = _serviceDataCache[serviceId] ?? 
                                    {'category': 'Loading...', 'name': 'Loading...'};
                                
                                final displayData = _createJobDataForDisplay(
                                  doc.id, jobData, customerData, serviceData);
                                
                                return ScheduledJobCard(
                                  bookingId: displayData['bookingId'],
                                  serviceType: displayData['serviceType'],
                                  customerName: displayData['customerName'],
                                  date: displayData['date'],
                                  time: displayData['time'],
                                  total: displayData['total'],
                                  onComplete: () => _completeBooking(doc.id),
                                  onViewDetails: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingDetailsScreen(
                                          bookingId: doc.id,
                                          bookingData: displayData,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          }
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          // Floating Nav Bar that hides on scroll
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

  // Show confirmation dialog for cancelling a booking
  Future<void> _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback confirmAction,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                confirmAction();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScheduledJobsScreen(),
  ));
}