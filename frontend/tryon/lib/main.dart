import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryon/view/welcome_page1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
 
  // Load the .env file
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    // MultiProvider(
    //   providers: [],
      // child: 
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const WelcomePage1(),
      // ),
    );
  }
}
