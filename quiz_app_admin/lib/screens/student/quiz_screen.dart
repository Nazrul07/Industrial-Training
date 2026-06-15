import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for dates (optional but helpful)
import '../../database/database_helper.dart';
import '../../models/question.dart';
import '../../models/result.dart'; // Import Result model
import 'result_screen.dart';

// The main quiz screen where questions are displayed one by one.
class QuizScreen extends StatefulWidget {
  final String studentName;
  final String studentId;

  const QuizScreen({super.key, required this.studentName, required this.studentId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _timerSeconds = 15;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // Load questions from database and start the timer.
  void _loadQuestions() async {
    final data = await DatabaseHelper.instance.readAllQuestions();
    setState(() {
      _questions = data;
      _isLoading = false;
    });
    if (_questions.isNotEmpty) {
      _startTimer();
    }
  }

  // Timer logic: counts down from 15 to 0.
  void _startTimer() {
    _timer?.cancel();
    _timerSeconds = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _nextQuestion(); // Automatically move to next question when time is up.
        }
      });
    });
  }

  // Move to the next question or show results if it was the last one.
  void _nextQuestion({String? selectedOption}) async {
    // 1. Stop the timer immediately so it doesn't keep running in the background
    _timer?.cancel();

    // 2. Check if the answer is correct (only if the user actually clicked an option)
    if (selectedOption != null) {
      String correctAnswer = _questions[_currentIndex].answer;
      if (selectedOption == correctAnswer) {
        _score++; // Increase score if correct
      }
    }

    // 3. Check if there are more questions left
    bool isLastQuestion = _currentIndex >= _questions.length - 1;

    if (!isLastQuestion) {
      // Move to next question
      setState(() {
        _currentIndex++;
      });
      _startTimer(); // Restart the 15s timer for the new question
    } else {
      // No more questions!
      
      // NEW: Save the result to the database for the Admin to see
      double accuracy = _questions.isNotEmpty ? (_score / _questions.length) * 100 : 0;
      final finalResult = QuizResult(
        studentName: widget.studentName,
        studentId: widget.studentId,
        score: _score,
        total: _questions.length,
        accuracy: accuracy,
        date: DateFormat('dd-MMM-yyyy, hh:mm a').format(DateTime.now()), // Format current time
      );
      
      await DatabaseHelper.instance.createResult(finalResult);

      // Navigate to the result screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              name: widget.studentName,
              id: widget.studentId,
              score: _score,
              total: _questions.length,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always cancel timers to avoid memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_questions.isEmpty) return const Scaffold(body: Center(child: Text('No questions available.')));

    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1} / ${_questions.length}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Display the countdown timer.
            LinearProgressIndicator(
              value: _timerSeconds / 15,
              backgroundColor: Colors.grey[300],
              color: _timerSeconds > 5 ? Colors.blue : Colors.red,
            ),
            const SizedBox(height: 10),
            Text('Time Left: $_timerSeconds s', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Text(q.question, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const SizedBox(height: 30),
            // Display options as buttons.
            _optionButton(q.option1),
            _optionButton(q.option2),
            _optionButton(q.option3),
            _optionButton(q.option4),
          ],
        ),
      ),
    );
  }

  // Helper widget to create option buttons.
  Widget _optionButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
          onPressed: () => _nextQuestion(selectedOption: text),
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
