import 'package:flutter/material.dart';

class EditableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isEditable;
  final VoidCallback onEditTap;

  const EditableTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isEditable,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.black,
                ),
                enabled: isEditable,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  filled: !isEditable,
                  fillColor: isEditable ? Colors.white : Colors.grey[100],
                ),
              ),
              Positioned(
                right: 20,
                child: GestureDetector(
                  onTap: onEditTap,
                  child: Icon(
                    isEditable ? Icons.check : Icons.edit,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
