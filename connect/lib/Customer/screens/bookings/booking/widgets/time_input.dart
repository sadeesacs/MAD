import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeInput extends StatefulWidget {
  final String? initialFromTime;
  final String? initialToTime;
  final bool isError;
  final Function(String fromTime, String toTime) onTimeSelected;

  const TimeInput({
    Key? key,
    this.initialFromTime,
    this.initialToTime,
    required this.isError,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  late TextEditingController _fromController;
  late TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.initialFromTime ?? '');
    _toController = TextEditingController(text: widget.initialToTime ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError ? Colors.red : Colors.black;

    return Row(
      children: [
        // FROM
        Expanded(
          child: TextField(
            controller: _fromController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'From',
              hintStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: Color(0xFF838383),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                final formatted = _formatTime(picked);
                setState(() {
                  _fromController.text = formatted;
                });
                widget.onTimeSelected(formatted, _toController.text.trim());
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          ':',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),

        // TO
        Expanded(
          child: TextField(
            controller: _toController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'To',
              hintStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: Color(0xFF838383),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                final formatted = _formatTime(picked);
                setState(() {
                  _toController.text = formatted;
                });
                widget.onTimeSelected(
                  _fromController.text.trim(),
                  formatted,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  /// Format [TimeOfDay] to "h:mm AM/PM" using intl
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }
}