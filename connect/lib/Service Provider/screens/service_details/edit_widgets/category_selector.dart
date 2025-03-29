import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final String? selectedCategory;
  final bool isError;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.isError,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final TextEditingController _controller = TextEditingController();

  List<String> categories = [
    'Plumbing','Cleaning','Gardening','Electrical','Car Wash','Cooking',
    'Painting','Fitness','Massage','Babysitting','Eldercare','Laundry'
  ];

  List<String> filtered = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.selectedCategory ?? '';
    filtered = categories;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError ? Colors.red : Colors.black;

    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Category',
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: Colors.black,
        ),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
      onTap: _showCategoryPicker,
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        String searchQuery = '';
        List<String> results = [...categories];

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            void applyFilter(String query) {
              searchQuery = query;
              results = categories
                  .where((cat) => cat.toLowerCase().contains(query.toLowerCase()))
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
                      hintText: 'Search Category...',
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
                            widget.onCategorySelected(selected);
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