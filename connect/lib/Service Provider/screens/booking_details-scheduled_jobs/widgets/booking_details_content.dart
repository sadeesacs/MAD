import 'package:flutter/material.dart';

const Color black = Colors.black;

class BookingDetailsContent extends StatelessWidget {
  const BookingDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Type',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Cleaning', // Replace with dynamic service type
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text(
          'Service Name',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Kitchen Cleaning', // Replace with dynamic service name
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text(
          'Customer Name',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Leo Perera', // Replace with dynamic customer name
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text(
          'Date',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          '2025-03-03', // Replace with dynamic date
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text(
          'Time',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          '3 PM To 6 PM', // Replace with dynamic time
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text(
          'District',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Colombo', // Replace with dynamic district
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text(
          'Additional Notes',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Beware of dogs when entering from the gate', // Replace with dynamic notes
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text(
          'Estimated Total',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'LKR 6000.00', // Replace with dynamic total
          style: TextStyle(color: black, fontSize: 14),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}