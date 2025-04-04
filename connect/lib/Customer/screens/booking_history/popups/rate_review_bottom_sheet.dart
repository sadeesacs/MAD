import 'package:flutter/material.dart';

class RateReviewBottomSheet extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const RateReviewBottomSheet({
    super.key,
    required this.bookingData,
  });

  @override
  State<RateReviewBottomSheet> createState() => _RateReviewBottomSheetState();
}

class _RateReviewBottomSheetState extends State<RateReviewBottomSheet> {
  int _selectedStars = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F5F7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Title
              const Center(
                child: Text(
                  'Leave a Review',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF027335),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Rate the Service label
              const Text(
                'Rate the Service',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Star row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final bool isStarFilled = index < _selectedStars;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStars = index + 1;
                      });
                    },
                    child: Icon(
                      isStarFilled ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFC48D),
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              // Share your experience label
              const Text(
                'Share your experience',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Review input field
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Leave a review about the service',
                  hintStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Submit button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF027335),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final int rating = _selectedStars;
    final String review = _reviewController.text.trim();
    // Pass this back to the caller
    Navigator.pop(context, {
      'rating': rating,
      'review': review,
    });
  }
}
