import 'package:flutter/material.dart';
import 'role_selection/role_selection.dart'; // Import Role Selection Screen
import 'Customer/screens/home/home_screen.dart'; // Import Customer Home Screen
import 'Service Provider/screens/dashboard/dashboard_screen.dart'; // Import SP Dashboard

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
        fontFamily: 'Roboto',
      ),
      home: const RoleSelectionScreen(), // Set Role Selection as the entry screen
      routes: {
        '/home': (context) => const HomeScreen(), // Customer Home Screen
        '/dashboard': (context) => const DashboardScreen(), // Service Provider Dashboard
        '/search': (context) => const SearchFunctionScreen(), // Search Screen Placeholder
      },
    );
  }
}

/// Simple placeholder for your Search screen
class SearchFunctionScreen extends StatelessWidget {
  const SearchFunctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Screen Placeholder')),
      body: const Center(child: Text('Search Screen Placeholder')),
    );
  }
}
