import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> serviceData;
  final VoidCallback onArrowTap;

  const ServiceCard({
    super.key,
    required this.serviceData,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extract fields from the service map
    final String serviceName = serviceData['serviceName'] ?? 'No Name';
    final String category = serviceData['category'] ?? 'Unknown';
    final double hourlyRate = serviceData['hourlyRate']?.toDouble() ?? 0.0;
    final String status = serviceData['status'] ?? 'Inactive';
    final String coverImage = serviceData['coverImage'] ?? '';
    final bool isActive = status.toLowerCase() == 'active';
    final Color statusColor = isActive ? const Color(0xFF027335) : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          Padding(
            padding: const EdgeInsets.only(right: 17),
            child: Image.asset(
              coverImage,
              width: 120,
              height: 131,
              fit: BoxFit.cover,
            ),
          ),

          // Text + Arrow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Name
                Text(
                  serviceName,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500, // Medium
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),

                // Category
                Text(
                  category,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),

                // Status
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600, // Semibold
                    fontSize: 13,
                    color: statusColor,
                  ),
                ),

                // Hourly Rate
                Row(
                  children: [
                    Text(
                      'LKR ${hourlyRate.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '/h',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.grey[600], // #838383
                      ),
                    ),
                  ],
                ),

                // Arrow button
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: onArrowTap, // callback from parent
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF027335),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
