import 'package:flutter/material.dart';
import 'widgets/otp_input_field.dart';  // Import the OTPInputField widget

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  EmailVerificationScreenState createState() => EmailVerificationScreenState();
}

class EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();
  int countdown = 120;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
        startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom back button with box around it
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,  // Background color of the box
                    borderRadius: BorderRadius.circular(8),  // Rounded corners
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);  // Navigate back to the previous screen
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),  // Added space to make room for the back button

              // Title and subtitle
              const Text(
                "Verify Your Email",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF027335)),
              ),
              const SizedBox(height: 5),
              const Text(
                "Enter the OTP sent to your Email",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OTPInputField(controller: otp1),
                  const SizedBox(width: 10),
                  OTPInputField(controller: otp2),
                  const SizedBox(width: 10),
                  OTPInputField(controller: otp3),
                  const SizedBox(width: 10),
                  OTPInputField(controller: otp4),
                ],
              ),
              const SizedBox(height: 20),

              // Verify Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF027335),  // Green background for Verify button
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // Code Expiry Text
              const Text("Didn’t get code"),
              Text(
                "Expire in $countdown sec",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
