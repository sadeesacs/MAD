import 'package:flutter/material.dart';
import 'Customer/screens/home/home_screen.dart';

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
      home: const HomeScreen(),
      routes: {
        // Placeholder route for your search function
        '/search': (context) => const SearchFunctionScreen(),
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
