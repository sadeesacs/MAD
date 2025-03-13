import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final String? initialDate;
  final bool isError;
  final ValueChanged<String> onDateSelected;

  const DateInput({
    Key? key,
    this.initialDate,
    required this.isError,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  late TextEditingController _controller;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(text: _selectedDate ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select Date',
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Color(0xFF838383),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.isError ? Colors.red : Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.isError ? Colors.red : Colors.black,
            width: 2,
          ),
        ),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          String formatted = DateFormat('yyyy/MM/dd').format(picked);
          setState(() {
            _selectedDate = formatted;
            _controller.text = formatted;
          });
          widget.onDateSelected(formatted);
        }
      },
    );
  }
}