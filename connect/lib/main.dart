import 'package:connect/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'auth/verification_code_screen.dart';
import 'onboarding_screens/onboarding_screen.dart';
import 'repository/authentication_repository.dart';
import 'Customer/screens/home/home_screen.dart'; // Customer Home Screen
import 'Service Provider/screens/dashboard/dashboard_screen.dart'; // SP Dashboard
import 'Customer/screens/search-services/search_services.dart'; // Search Screen Placeholder

void main() async {
  await dotenv.load(fileName: ".env");
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Preserve the native splash until initialization completes.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp app) {
    Get.put(AuthenticationRepository());
  });

  setupAuthListeners();

  runApp(const MyApp());
}

void setupAuthListeners() {
  final authRepo = Get.find<AuthenticationRepository>();

  authRepo.verificationStream.listen((data) {
    if (data['action'] == 'navigate_to_verification') {
      Get.to(() => VerificationCodeScreen(
        verificationId: data['verificationId'],
        userId: data['userId'],
        phoneNumber: data['phoneNumber'],
        verificationCode: '',
        email: '',
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
      // Set OnboardingScreen as the first screen.
      home: const OnboardingScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/search': (context) => const SearchFunctionScreen(),
      },
    );
  }
}
