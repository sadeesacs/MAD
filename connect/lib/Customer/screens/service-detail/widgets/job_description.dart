import 'package:flutter/material.dart';

class JobDescription extends StatelessWidget {
  const JobDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}