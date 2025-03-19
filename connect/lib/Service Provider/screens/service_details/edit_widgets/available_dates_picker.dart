import 'package:flutter/material.dart';

class AvailableDatesPicker extends StatefulWidget {
  final Set<String> selectedDays; // e.g. {'M','T','W','T2','F','S','S2'}
  final bool isError;
  final ValueChanged<String> onDayToggled;

  const AvailableDatesPicker({
    super.key,
    required this.selectedDays,
    required this.isError,
    required this.onDayToggled,
  });

  @override
  State<AvailableDatesPicker> createState() => _AvailableDatesPickerState();
}

class _AvailableDatesPickerState extends State<AvailableDatesPicker> {
  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError ? Colors.red : Colors.transparent;

    // Define the 7 items in order: M, T, W, T2, F, S, S2.
    // For display, T2 and S2 show as "T" and "S" respectively.
    final items = [
      {'key': 'M', 'label': 'M'},
      {'key': 'T', 'label': 'T'},
      {'key': 'W', 'label': 'W'},
      {'key': 'T2', 'label': 'T'},
      {'key': 'F', 'label': 'F'},
      {'key': 'S', 'label': 'S'},
      {'key': 'S2', 'label': 'S'},
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: borderColor == Colors.red ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.map((item) {
          final bool selected = widget.selectedDays.contains(item['key']);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0), // little space between dates
            child: GestureDetector(
              onTap: () {
                widget.onDayToggled(item['key'] as String);
              },
              child: Container(
                width: 43,
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF027335)
                      : const Color(0xFFDFE9E3),
                  border: selected ? null : Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
