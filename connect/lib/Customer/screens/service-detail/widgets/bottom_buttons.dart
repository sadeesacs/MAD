import 'package:flutter/material.dart';

const Color darkGreen = Color(0xFF027335);
const Color white = Colors.white;

class BottomButtons extends StatelessWidget {
  final VoidCallback? onMessageTap;
  final VoidCallback? onBookNowTap;

  const BottomButtons({
    Key? key,
    this.onMessageTap,
    this.onBookNowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F5F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton('Message', onPressed: onMessageTap),
          _buildButton('Book Now', onPressed: onBookNowTap),
        ],
      ),
    );
  }

  Widget _buildButton(String text, {VoidCallback? onPressed}) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
