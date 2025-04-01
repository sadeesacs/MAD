// job_description.dart
import 'package:flutter/material.dart';

class JobDescription extends StatelessWidget {
  const JobDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(13.0),
      child: Text(
        'Lorem ipsum dolor sit amet...',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
