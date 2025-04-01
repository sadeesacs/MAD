import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'verification_code_screen.dart';
import 'success_password_change_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController     = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                onTap: () => Navigator.pop(context), // back to Verification Code
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

              // Title: "New Password"
              const Center(
                child: Text(
                  'New Password',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xFF027335),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // "Set your new password"
              const Center(
                child: Text(
                  'Set your new password',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // New Password label
              const Text(
                'New Password',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // New Password input
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
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
              const SizedBox(height: 24),

              // Confirm New Password label
              const Text(
                'Confirm New Password',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Confirm New Password input
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Re-enter new password',
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
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Set New Password button
              Center(
                child: ElevatedButton(
                  onPressed: _onSetNewPassword,
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
                    'Set New Password',
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

  Future<void> _onSetNewPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Validate passwords match
      if (_newPasswordController.text != _confirmPasswordController.text) {
        throw Exception("Passwords don't match");
      }

      // Validate password strength
      if (_newPasswordController.text.length < 6) {
        throw Exception("Password must be at least 6 characters");
      }

      // Send a password reset email with the built-in Firebase feature
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);

      setState(() {
        _isLoading = false;
      });

      // Show success screen with instructions to check email
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Password Reset Link Sent'),
          content: Text(
              'A password reset link has been sent to ${widget.email}.\n\n'
                  'Please check your email and click the link to complete the password reset process.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to success screen and clear history
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SuccessPasswordChangeScreen()),
                      (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

    } catch (e) {
      String errorMessage = 'Failed to reset password';

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email address';
        } else if (e.message != null) {
          errorMessage = e.message!;
        }
      } else {
        errorMessage = e.toString();
      }

      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}