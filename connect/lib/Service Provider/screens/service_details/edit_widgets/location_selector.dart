import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  final List<String> selectedLocations;
  final bool isError;
  final ValueChanged<List<String>> onLocationsChanged;

  const LocationSelector({
    super.key,
    required this.selectedLocations,
    required this.isError,
    required this.onLocationsChanged,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final TextEditingController _controller = TextEditingController();

  // Example location list
  List<String> allLocations = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Trincomalee',
    'Anuradhapura',
    'Polonnaruwa',
    'Kurunegala',
    'Puttalam',
  ];

  List<String> filtered = [];
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List<String>.from(widget.selectedLocations);
    filtered = allLocations;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError ? Colors.red : Colors.black;
    return GestureDetector(
      onTap: _showLocationPicker,
      child: SizedBox(
        height: 80, // Fixed height so it always fits with parent's 25 padding
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...selected.map((loc) => _buildChip(loc)),
                if (selected.isEmpty)
                  const Text(
                    'Select Locations',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String location) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFDFE9E3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            location,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              setState(() {
                selected.remove(location);
              });
              widget.onLocationsChanged(selected);
            },
            child: const Icon(Icons.close, size: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        String searchQuery = '';
        List<String> results = List.from(allLocations);

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            void applyFilter(String query) {
              searchQuery = query;
              results = allLocations
                  .where((loc) => loc.toLowerCase().contains(query.toLowerCase()))
                  .toList();
              setModalState(() {});
            }

            bool isSelected(String loc) => selected.contains(loc);

            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(ctx).size.height * 0.7,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Search Location...'),
                    onChanged: (val) => applyFilter(val),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final loc = results[index];
                        final selectedFlag = isSelected(loc);
                        return ListTile(
                          title: Text(loc),
                          trailing: selectedFlag
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            // Use setModalState to update bottom sheet UI seamlessly
                            setModalState(() {
                              if (selectedFlag) {
                                selected.remove(loc);
                              } else {
                                selected.add(loc);
                              }
                            });
                            widget.onLocationsChanged(selected);
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
