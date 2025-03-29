import 'package:flutter/material.dart';
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';

class DetailPendingRequestScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const DetailPendingRequestScreen({
    Key? key,
    required this.bookingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract booking data fields
    final String bookingId       = bookingData['bookingId']       ?? '#123456';
    final String serviceType     = bookingData['serviceType']     ?? 'Cleaning';
    final String serviceName     = bookingData['serviceName']     ?? 'Kitchen cleaning';
    final String customerName    = bookingData['customer']        ?? 'Leo Perera';
    final String date            = bookingData['date']            ?? '2025-03-03';
    final String time            = bookingData['time']            ?? '3 PM To 6 PM';
    final String district        = bookingData['district']        ?? 'Colombo';
    final String additionalNotes = bookingData['additionalNotes'] ?? 'Beware of dogs...';
    final String estimatedTotal  = bookingData['estimatedTotal']  ?? 'LKR 6000.00';
    final String locationImage   = bookingData['locationImage']   ?? '';

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
                          borderRadius: BorderRadius.circular(15), // 15% corners
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
                _buildInfo(estimatedTotal),
                const SizedBox(height: 16),

                // Location
                _buildLabel('Location'),
                const SizedBox(height: 8),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F7),
                    borderRadius: BorderRadius.circular(16),
                    image: locationImage.isNotEmpty
                        ? DecorationImage(
                      image: AssetImage(locationImage),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 25),

                // Message Client button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                    },
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
                    child: const Text(
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

          // Bottom bar with Accept/Reject
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // 20% top corners
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
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF027335),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Accept',
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
                      onPressed: () {
                        // Reject logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Reject',
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