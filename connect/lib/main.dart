import 'package:flutter/material.dart';
import 'Customer/screens/category_based_service_listing/service_listing_screen.dart'; // Import ServiceListingScreen
import 'Customer/screens/Signup/register_screen.dart';
import 'Customer/screens/Signup/email_verification_screen.dart'; // Import OTP Screen
import 'Customer/screens/Notifications/Notifications.dart'; // Import NotificationsScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NotificationsScreen(), // Start from NotificationsScreen
      routes: {
        '/home': (context) => const HomeScreen(), // HomeScreen route
        '/register': (context) => const RegisterScreen(), // RegisterScreen route
        '/otp': (context) => const EmailVerificationScreen(), // OTP Screen route
        '/category': (context) => const ServiceListingScreen(categoryName: 'Cleaning'), // Set the route for the ServiceListingScreen
        '/notifications': (context) => const NotificationsScreen(), // Add the NotificationsScreen route
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: const Center(child: Text('Welcome to Home Screen')),
    );
  }
}
