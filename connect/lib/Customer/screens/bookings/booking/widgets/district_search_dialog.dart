import 'package:flutter/material.dart';

class DistrictSearchDialog extends StatefulWidget {
  const DistrictSearchDialog({super.key});

  @override
  State<DistrictSearchDialog> createState() => _DistrictSearchDialogState();
}

class _DistrictSearchDialogState extends State<DistrictSearchDialog> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _districts = [
    'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo',
    'Galle', 'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara',
    'Kandy', 'Kegalle', 'Kilinochchi', 'Kurunegala', 'Mannar',
    'Matale', 'Matara', 'Monaragala', 'Mullaitivu', 'Nuwara Eliya',
    'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya'
  ];

  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_districts);
    _searchController.addListener(_filter);
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _districts
          .where((d) => d.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Search District',
          prefixIcon: Icon(Icons.search),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: _filtered.length,
          itemBuilder: (context, index) {
            final district = _filtered[index];
            return ListTile(
              title: Text(district),
              onTap: () => Navigator.pop(context, district),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
