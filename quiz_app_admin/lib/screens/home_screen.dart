import 'package:flutter/material.dart';
import 'admin/admin_login.dart';
import 'student/student_login.dart';

// The first screen the user sees, offering a choice between Admin and Student panels.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text(
              'Welcome to the Quiz App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Button to navigate to the Admin Panel
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                );
              },
              child: const Text('Admin Panel', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            // Button to navigate to the Student Panel
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentLoginScreen()),
                );
              },
              child: const Text('Student Panel', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
