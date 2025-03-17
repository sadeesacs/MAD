import 'package:flutter/material.dart';

class ServiceDetailCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onEdit;

  const ServiceDetailCard({
    Key? key,
    required this.service,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example fields assumed:
    final name = service['name'] ?? 'Service Name';
    final category = service['category'] ?? 'Cleaning';
    final hourlyRate = service['hourlyRate'] ?? 0.0;
    final locations = service['locations'] ?? ['Colombo', 'Kalutara', 'Galle'];
    final dates = service['dates'] ?? ['Monday', 'Tuesday', 'Friday'];
    final hours = service['hours'] ?? '8AM - 5 PM';

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Service Details',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              InkWell(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFF1D730)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Color(0xFFF1D730),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Service Name
          _buildLabelValue('Service Name', service['serviceName'] ?? 'Service Name'),

          // Category
          _buildLabelValue('Category', category),

          // Hourly Rate
          _buildLabelValue('Hourly Rate', 'LKR ${hourlyRate.toStringAsFixed(2)}'),

          // Location
          _buildLabelValue('Location', locations.join('   ')),

          // Available Dates
          _buildLabelValue('Available Dates', dates.join('   ')),

          // Available Hours
          _buildLabelValue('Available Hours', hours),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          // Value
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              color: Color(0xFF838383),
            ),
          ),
        ],
      ),
    );
  }
}