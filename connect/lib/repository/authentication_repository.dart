import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_screen.dart';
import '../onboarding_screens/onboarding_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  Future<void> screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final phoneNumber = userDoc.data()!['phoneNumber'];

      if (userDoc.data()!['phoneVerified'] == true) {
        try {
          if (userDoc.exists && userDoc.data() != null) {
            final role = userDoc.data()!['role'];

            if (role == 'CUSTOMER') {
              Get.offNamed('/home');
            } else if (role == 'SERVICE_PROVIDER') {
              Get.offNamed('/dashboard');
            }
          }
        } catch (e) {
          print("Error getting user role: $e");
          Get.offAll(() => const LoginScreen());
        }
      } else {
        await checkPhoneVerification(user);
      }
    } else {
      // Check if the user has seen the onboarding
      bool hasSeenOnboarding = deviceStorage.read('hasSeenOnboarding') ?? false;
      if (!hasSeenOnboarding) {
        // Navigate to onboarding and set flag
        Get.offAll(() => const OnboardingScreen());
        deviceStorage.write('hasSeenOnboarding', true);
      } else {
        // If onboarding already seen, go to LoginScreen (or RoleSelectionScreen if that's desired)
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }

  // Stream controller to emit verification requests
  final StreamController<Map<String, dynamic>> _verificationController =
  StreamController<Map<String, dynamic>>.broadcast();

  // Stream that UI can listen to for verification events
  Stream<Map<String, dynamic>> get verificationStream => _verificationController.stream;

  // Method to check if phone is verified and handle accordingly
  Future<void> checkPhoneVerification(User user) async {
    try {
      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      // If user exists and phone is not verified
      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!['phoneVerified'] == false) {

        // Get phone number from Firestore
        final phoneNumber = userDoc.data()!['phoneNumber'] as String;

        // Send verification code
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            // Auto-verification completed (rare)
          },
          verificationFailed: (FirebaseAuthException e) {
            // Handle verification failure
            _verificationController.add({
              'error': e.message ?? 'Phone verification failed'
            });
          },
          codeSent: (String verificationId, int? resendToken) {
            // Emit event with necessary data for navigation
            _verificationController.add({
              'action': 'navigate_to_verification',
              'verificationId': verificationId,
              'userId': user.uid,
              'phoneNumber': phoneNumber,
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Timeout handling
          },
          timeout: const Duration(minutes: 2),
        );
      }
    } catch (e) {
      debugPrint('Error checking phone verification: $e');
    }
  }

  @override
  void onClose() {
    _verificationController.close();
    super.onClose();
  }
}
