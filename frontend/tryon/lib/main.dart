import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Assuming paths based on your previous files
import 'package:tryon/controller/app_provider.dart'; 
import 'package:tryon/core/utils/shared_pref_utils.dart';
import 'package:tryon/view/welcome_page1.dart';
import 'package:tryon/view/bottom_navigation.dart'; // Added this import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Shared Preferences
  await SharedPrefUtils.init();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TryOn App',
      debugShowCheckedModeBanner: false,
      // Use the AuthWrapper to decide the home page
      home: AuthWrapper(),
    );
  }
}

/// A wrapper widget that listens to the AppProvider's auth state
/// and shows the correct screen.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the AppProvider for changes in the login state
    final bool isLoggedIn = context.watch<AppProvider>().isLoggedIn;

    // The AppProvider's constructor synchronously checks SharedPrefUtils,
    // so this will show the correct screen on app start.
    if (isLoggedIn) {
      // If logged in, go to the main app screen
      return const BottomNavigation();
    } else {
      // If not logged in, show the welcome page
      return const WelcomePage1();
    }
  }
}


