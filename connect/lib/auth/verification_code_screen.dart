import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../role_selection/role_selection.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String verificationId;
  final String userId;
  final String phoneNumber;
  final String email;
  final String verificationCode;

  const VerificationCodeScreen(
      {super.key,
      required this.verificationId,
      required this.userId,
      required this.phoneNumber,
      required this.verificationCode,
      required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
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
                  "We've sent a verification code to ${widget.phoneNumber}",
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
        SnackBar(
            content:
                Text('Please wait $_timeLeft seconds before requesting again')),
      );
      return;
    }

    setState(() {
      _resendingCode = true;
    });

    try {
      // Get the phone number from the widget params
      final phoneNumber = widget.phoneNumber;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification completed (rare on most devices)
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _resendingCode = false;
            _errorMessage = e.message;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _resendingCode = false;
          });
          // Update the verification ID
          // Since this is a StatefulWidget, we can't directly modify widget properties
          // Instead, recreate the screen with the new verification ID
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VerificationCodeScreen(
                verificationId: verificationId,
                userId: widget.userId,
                phoneNumber: widget.phoneNumber,
                verificationCode: '',
                email: '',
              ),
            ),
          );

          // Reset timer
          _startTimer();

          // Show confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification code resent')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
        },
        timeout: const Duration(minutes: 2),
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

  Future<void> _verifyCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the 6-digit code from input fields
      final smsCode = _controllers.map((controller) => controller.text).join();

      if (smsCode.length != 6) {
        throw Exception('Please enter all 6 digits');
      }

      // Create credential with verification ID and SMS code
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: smsCode);


      User? user = _auth.currentUser;

      if (user == null) {
        // If user isn't signed in (rare case), sign in with the user ID from widget
        await _auth.signInWithEmailAndPassword(
          email: (await _firestore.collection('users').doc(widget.userId).get())
              .data()!['email'],
          password: '', // This won't work without knowing the password
        );
        user = _auth.currentUser;
      }

      // Now link the phone credential to the existing user account
      await user?.linkWithCredential(credential);

      // Update user's phone verification status
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .update({'phoneVerified': true});

      // Get user role from Firestore
      final userDoc =
          await _firestore.collection('users').doc(widget.userId).get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw Exception('User data not found');
      }

      // Get role and navigate accordingly
      final role = userDoc.data()!['role'];

      setState(() {
        _isLoading = false;
      });

      if (role == 'CUSTOMER') {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else if (role == 'SERVICE_PROVIDER') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (route) => false);
      } else {
        // Invalid role - redirect to role selection
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });

      // Special handling for specific Firebase Auth errors
      String errorMessage = 'Verification failed';
      if (e.code == 'credential-already-in-use') {
        errorMessage = 'Phone number is already linked to another account';
      } else if (e.code == 'invalid-verification-code') {
        errorMessage = 'Invalid verification code';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
