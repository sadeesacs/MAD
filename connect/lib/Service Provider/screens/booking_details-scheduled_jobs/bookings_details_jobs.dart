import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import '../../services/booking_service.dart';
import '../../services/chat_service.dart';
import '../../screens/chat/chat_screen.dart';
import 'widgets/booking_details_map.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;
  final Map<String, dynamic> bookingData;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
    required this.bookingData,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final BookingService _bookingService = BookingService();
  final ChatService _chatService = ChatService();
  bool _isProcessing = false;

  void _messageClient(String? customerId, String customerName) async {
    if (customerId == null || customerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing customer information'))
      );
      return;
    }
    
    setState(() => _isProcessing = true);
    try {
      // Create or get existing chat with this customer
      final chatId = await _chatService.createOrGetChat(customerId);
      
      // Get customer data for chat screen
      final customerData = await _bookingService.getCustomerData(customerId);
      
      if (!mounted) return;
      
      // Navigate to chat screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chatId,
            profilePic: customerData['profile_pic'] ?? '',
            userName: customerName,
            otherUserId: customerId,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open chat: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _completeBooking() async {
    setState(() => _isProcessing = true);
    try {
      await _bookingService.updateBookingStatus(widget.bookingId, 'completed');
      
      if (!mounted) return;
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job marked as completed')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete booking: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _cancelBooking() async {
    setState(() => _isProcessing = true);
    try {
      await _bookingService.updateBookingStatus(widget.bookingId, 'cancelled');
      
      if (!mounted) return;
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking has been cancelled')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract booking data fields
    final String bookingId       = widget.bookingData['bookingId']       ?? '#123456';
    final String serviceType     = widget.bookingData['serviceType']     ?? 'Cleaning';
    final String serviceName     = widget.bookingData['serviceName']     ?? 'Unknown Service';
    final String customerName    = widget.bookingData['customerName']    ?? 'Unknown Customer';
    final String date            = widget.bookingData['date']            ?? '';
    final String time            = widget.bookingData['time']            ?? '';
    final String district        = widget.bookingData['district']        ?? '';
    final String additionalNotes = widget.bookingData['additional_notes'] ?? '';
    final String total           = widget.bookingData['total']           ?? '';
    final dynamic customer       = widget.bookingData['customer'];

    // Extract customer ID from DocumentReference or String
    String? customerId;
    if (customer is DocumentReference) {
      customerId = customer.id;
    } else if (customer is String) {
      customerId = customer;
    }

    // Extract location data - handle both GeoPoint and Map formats
    double latitude = 0.0;
    double longitude = 0.0;

    final locationData = widget.bookingData['location'];
    if (locationData != null) {
      if (locationData is GeoPoint) {
        // Handle GeoPoint format
        latitude = locationData.latitude;
        longitude = locationData.longitude;
      } else if (locationData is Map) {
        // Handle Map format
        latitude = _extractDoubleValue(locationData, 'latitude');
        longitude = _extractDoubleValue(locationData, 'longitude');
      }
    }

    final LatLng bookingLocation = LatLng(latitude, longitude);
    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId(bookingId),
        position: bookingLocation,
        infoWindow: InfoWindow(title: 'Service Location', snippet: serviceName),
      ),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
      endDrawer: const SPHamburgerMenu(),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row: Back button + Booking ID
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFE9E3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF027335),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Booking ID : $bookingId',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF027335),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Service Type
                _buildLabel('Service Type'),
                _buildInfo(serviceType),
                const SizedBox(height: 16),

                // Service Name
                _buildLabel('Service Name'),
                _buildInfo(serviceName),
                const SizedBox(height: 16),

                // Customer Name
                _buildLabel('Customer Name'),
                _buildInfo(customerName),
                const SizedBox(height: 16),

                // Date
                _buildLabel('Date'),
                _buildInfo(date),
                const SizedBox(height: 16),

                // Time
                _buildLabel('Time'),
                _buildInfo(time),
                const SizedBox(height: 16),

                // District
                _buildLabel('District'),
                _buildInfo(district),
                const SizedBox(height: 16),

                // Additional Notes
                _buildLabel('Additional Notes'),
                _buildInfo(additionalNotes),
                const SizedBox(height: 16),

                // Estimated Total
                _buildLabel('Estimated Total'),
                _buildInfo(total),
                const SizedBox(height: 16),

                // Location Map
                _buildLabel('Location'),
                const SizedBox(height: 8),
                latitude != 0.0 && longitude != 0.0
                    ? BookingDetailsMap(
                        savedLocation: bookingLocation,
                        markers: markers,
                      )
                    : Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5F7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text('Location not available'),
                        ),
                      ),
                const SizedBox(height: 25),

                // Message Client button
                Center(
                  child: ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () => _messageClient(customerId, customerName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF027335),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Message Client',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 100), // Extra space above bottom bar
              ],
            ),
          ),

          // Bottom bar with Complete/Cancel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF3F5F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _completeBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF027335),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Complete Job',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _cancelBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to safely extract double values
  double _extractDoubleValue(Map<dynamic, dynamic>? map, String key) {
    if (map == null) return 0.0;
    final value = map[key];
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500, // Medium
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildInfo(String info) {
    return Text(
      info,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400, // Regular
        fontSize: 18,
        color: Colors.black,
      ),
    );
  }
}