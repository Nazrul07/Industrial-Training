import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Ensure that Flutter is initialized before anything else.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false, // Hides the "Debug" banner in the corner.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // The app starts at the HomeScreen.
      home: const HomeScreen(),
    );
  }
}
