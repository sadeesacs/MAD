import 'package:connect/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'auth/verification_code_screen.dart';
import 'repository/authentication_repository.dart';
import 'Customer/screens/home/home_screen.dart'; // Import Customer Home Screen
import 'Service Provider/screens/dashboard/dashboard_screen.dart'; // Import SP Dashboard

void main() async {
  await dotenv.load(fileName: ".env");
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );
  setupAuthListeners();
  runApp(const MyApp());
}

// In your main.dart or app initialization
void setupAuthListeners() {
  final authRepo = Get.find<AuthenticationRepository>();

  authRepo.verificationStream.listen((data) {
    if (data['action'] == 'navigate_to_verification') {
      Get.to(() => VerificationCodeScreen(
        verificationId: data['verificationId'],
        userId: data['userId'],
        phoneNumber: data['phoneNumber'], verificationCode: '', email: '',
      ));
    } else if (data['error'] != null) {
      Get.snackbar('Verification Error', data['error']);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      // home: const RoleSelectionScreen(), // Set Role Selection as the entry screen
      home: const Scaffold(backgroundColor: Colors.amber, body: Center(child: CircularProgressIndicator(color: Colors.white))),
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
