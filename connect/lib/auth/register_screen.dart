
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../role_selection/role_selection.dart';
import 'login_screen.dart';
import 'verification_code_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _errorMessage;

  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // Title: "Register"
              const Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                  color: Color(0xFF027335),
                ),
              ),
              const SizedBox(height: 10),

              // Subtext: "Create an Account"
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              // Name label + field
              _buildLabel('Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hintText: 'Enter your name',
              ),
              const SizedBox(height: 24),

              // Email label + field
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter your email',
              ),
              const SizedBox(height: 24),

              // Phone Number label + field
              _buildLabel('Phone Number'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Enter your phone number',
              ),
              const SizedBox(height: 24),

              // Password label + field
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Confirm Password label + field
              _buildLabel('Confirm Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: 'Re-enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Checkbox: "Agree to Terms & Conditions"
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (val) {
                      setState(() {
                        _agreedToTerms = val ?? false;
                      });
                    },
                  ),
                  const Text(
                    'Agree to Terms & Conditions',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Send OTP button
              ElevatedButton(
                onPressed: _isLoading ? null : _onSendOTPPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF427E4E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
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
                        'Send OTP',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Color(0xFF427E4E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500, // medium
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // 10% corners
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> _onSendOTPPressed() async {
    print("Send OTP button pressed");

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if role is selected
      final storage = GetStorage();
      final userRole = storage.read<String>('userRole');

      if (userRole == null) {
        print("No user role found in storage");
        setState(() {
          _isLoading = false;
        });
        // Redirect to role selection first
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        );
        return;
      }

      // Check phone number format
      String phoneNumber = _phoneController.text.trim();
      if (!phoneNumber.startsWith('+')) {
        print("Phone number does not start with +");
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number must include country code (e.g., +1xxxxxxxxxx)')),
        );
        return;
      }

      print("Creating user with email: ${_emailController.text.trim()}");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      print("User created with ID: ${userCredential.user!.uid}");

      print("Saving user data to Firestore with role: $userRole");
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'phoneVerified': false,
        'role': userRole, // Use the role from localStorage
      });

      print("Starting phone verification");
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          print("Auto verification completed");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Phone verification failed: ${e.message}");
          setState(() {
            _isLoading = false;
            _errorMessage = e.message;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          print("SMS code sent, verification ID: $verificationId");
          setState(() {
            _isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerificationCodeScreen(
                verificationId: verificationId,
                userId: userCredential.user!.uid,
                phoneNumber: phoneNumber, verificationCode: '', email: '',
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code auto retrieval timeout");
        },
        timeout: const Duration(minutes: 2),
      );
    } catch (e) {
      print("Error during registration: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration error: $e')),
      );
      print("Error during registration: $e");
    }
  }
}
