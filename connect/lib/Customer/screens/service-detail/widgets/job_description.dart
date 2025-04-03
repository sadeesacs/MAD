// lib/Customer/screens/service-detail/widgets/job_description.dart
import 'package:flutter/material.dart';

class JobDescription extends StatelessWidget {
  final String description;

  const JobDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Text(
        description.isEmpty ? 'No job description provided.' : description,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
