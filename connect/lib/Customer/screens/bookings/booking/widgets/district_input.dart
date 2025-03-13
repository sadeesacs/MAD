import 'package:flutter/material.dart';

class DistrictInput extends StatefulWidget {
  final String? initialDistrict;
  final bool isError;
  final ValueChanged<String> onDistrictSelected;

  const DistrictInput({
    super.key,
    this.initialDistrict,
    required this.isError,
    required this.onDistrictSelected,
  });

  @override
  State<DistrictInput> createState() => _DistrictInputState();
}

class _DistrictInputState extends State<DistrictInput> {
  final _controller = TextEditingController();

  List<String> districts = [
    'Ampara','Anuradhapura','Badulla','Batticaloa','Colombo','Galle',
    'Gampaha','Hambantota','Jaffna','Kalutara','Kandy','Kegalle',
    'Kilinochchi','Kurunegala','Mannar','Matale','Matara','Monaragala',
    'Mullaitivu','Nuwara Eliya','Polonnaruwa','Puttalam','Ratnapura',
    'Trincomalee','Vavuniya',
  ];
  List<String> filtered = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialDistrict ?? '';
    filtered = districts;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError ? Colors.red : Colors.black;

    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select District',
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Color(0xFF838383),
        ),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
      onTap: _showDistrictPicker,
    );
  }

  void _showDistrictPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        String searchQuery = '';
        List<String> results = [...districts];

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            void applyFilter(String query) {
              searchQuery = query;
              results = districts
                  .where((d) => d.toLowerCase().contains(query.toLowerCase()))
                  .toList();
              setModalState(() {});
            }

            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(ctx).size.height * 0.7,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search District...',
                    ),
                    onChanged: (val) => applyFilter(val),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(results[index]),
                          onTap: () {
                            final selected = results[index];
                            setState(() {
                              _controller.text = selected;
                            });
                            widget.onDistrictSelected(selected);
                            Navigator.of(ctx).pop();
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}