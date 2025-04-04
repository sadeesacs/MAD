import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/auth/reset_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class VerificationCodeScreenEmail extends StatefulWidget {
  final String email;
  final String verificationCode;

  const VerificationCodeScreenEmail(
      {super.key,
      required this.verificationCode,
      required this.email});

  @override
  State<VerificationCodeScreenEmail> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreenEmail> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool _resendingCode = false;
  int _timeLeft = 120; // Timer countdown
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFE9E3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF027335),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // "Verification Code"
              const Center(
                child: Text(
                  'Verification Code',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xFF027335),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Show phone number or email
              Center(
                child: Text(
                  "We've sent a verification code to ${widget.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 6 input fields side by side
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30),

              // Error message if any
              if (_errorMessage != null)
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // Verify button
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF427E4E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Didn't get code / Timer section
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _resendingCode ? null : _resendVerificationCode,
                      child: Text(
                        "Didn't get code",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          color: _resendingCode || _timeLeft > 0
                              ? Colors.grey
                              : Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Expire in $_timeLeft sec',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: Color(0xFF027335),
                      ),
                    ),
                    if (_resendingCode)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 20,
                        height: 20,
                        child: const CircularProgressIndicator(
                          color: Color(0xFF027335),
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _resendVerificationCode() async {
    if (_timeLeft > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please wait $_timeLeft seconds before requesting again')),
      );
      return;
    }

    setState(() {
      _resendingCode = true;
      _errorMessage = null;
    });

    try {
      final email = widget.email;

      // Generate a new verification code
      String newVerificationCode = _generateVerificationCode();

      // Send the email with the new code (using the same method as in ForgotPasswordScreen)
      await sendMailFromGmail(email, 'Reset Password Request', newVerificationCode);

      setState(() {
        _resendingCode = false;
      });

      // Replace the current screen with updated verification code
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationCodeScreenEmail(
            verificationCode: newVerificationCode,
            email: email,
          ),
        ),
      );

      // Reset timer
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code resent to your email')),
      );
    } catch (e) {
      setState(() {
        _resendingCode = false;
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resending code: $e')),
      );
    }
  }

  // Add this method to generate a verification code
  String _generateVerificationCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Add this method to send email (copied from ForgotPasswordScreen)
  Future<void> sendMailFromGmail(String recipient, String subject, String text) async {
    final gmailSmtp = gmail(
      dotenv.env["GMAIL_MAIL"]!,
      dotenv.env["GMAIL_PASSWORD"]!
    );

    final message = Message()
      ..from = Address(dotenv.env["GMAIL_MAIL"]!, 'Reset Password Request Code')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = text;

    try {
      final sendReport = await send(message, gmailSmtp);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      rethrow;
    }
  }

  Future<void> _verifyCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the 6-digit code from input fields
      final enteredCode = _controllers.map((controller) => controller.text).join();

      if (enteredCode.length != 6) {
        throw Exception('Please enter all 6 digits');
      }

      // Check if entered code matches the sent code
      if (enteredCode == widget.verificationCode) {
        setState(() {
          _isLoading = false;
        });

        // Pass the email to ResetPasswordScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(
              email: widget.email,
            ),
          ),
        );
      } else {
        throw Exception('Invalid verification code');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $_errorMessage')),
      );
    }
  }
}
