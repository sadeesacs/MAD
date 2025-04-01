import 'dart:math';

import 'package:connect/auth/verification_code_screen_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_screen.dart';
import 'verification_code_screen.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/mailer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final gmailSmtp =
      gmail(dotenv.env["GMAIL_MAIL"]!, dotenv.env["GMAIL_PASSWORD"]!);

  bool _isLoading = false;
  String? _errorMessage;

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
                onTap: () => Navigator.pop(context), // back to Login
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

              // Title: "Forgot Password"
              const Center(
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xFF027335),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Subtext
              const Center(
                child: Text(
                  'Enter your registered email to receive\n'
                  'a password reset link.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Email label
              const Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Email input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),

              // Send OTP button
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendPasswordResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF427E4E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
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

  sendMailFromGmail(String sender, sub, text) async {
    final message = Message()
      ..from = Address(dotenv.env["GMAIL_MAIL"]!, 'Reset Password Request Code')
      ..recipients.add(sender)
      ..subject = sub
      ..text = text;

    try {
      final sendReport = await send(message, gmailSmtp);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid email address');
      }

      final verificationCode = _generateVerificationCode();

      // Send password reset code
      sendMailFromGmail(email, 'Reset Password Request', verificationCode);
      // Don't navigate away - show success message but stay on screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset link sent! Please check your inbox and spam folder',
            style: TextStyle(fontSize: 14),
          ),
          duration: Duration(seconds: 5),
        ),
      );

      // Clear loading state but stay on screen
      setState(() {
        _isLoading = false;
      });

      // Navigate to verification code screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationCodeScreenEmail(
            verificationCode: verificationCode,
            email: email,
          ),
        ),
      );

    } catch (e) {
      String errorMessage = 'Failed to send password reset code';

      // Handle specific Firebase auth errors
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email address';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is invalid';
        } else if (e.message != null) {
          errorMessage = e.message!;
        }
      }

      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Generate a random 4-digit verification code
  String _generateVerificationCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000))
        .toString(); // 6-digit number between 1000-9999
  }
}
