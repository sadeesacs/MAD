import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton('Message'),
          _buildButton('Book Now'),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF027335),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,  
          ),
        ),
      ),
    );
  }
}