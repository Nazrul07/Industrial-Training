import 'package:flutter/material.dart';
import 'student_login.dart';

// Final screen showing the student's performance.
class ResultScreen extends StatelessWidget {
  final String name;
  final String id;
  final int score;
  final int total;

  const ResultScreen({
    super.key,
    required this.name,
    required this.id,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    // Calculating accuracy as a percentage.
    double accuracy = total > 0 ? (score / total) * 100 : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Icon(Icons.stars, size: 100, color: Colors.orange),
              const SizedBox(height: 20),
              Text('Congratulations, $name!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('ID: $id', style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 30),
              Text('Your Score: $score / $total', style: const TextStyle(fontSize: 22)),
              Text('Accuracy: ${accuracy.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 50),
              // Button to restart the process.
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const StudentLoginScreen()),
                  );
                },
                icon: const Icon(Icons.replay),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
