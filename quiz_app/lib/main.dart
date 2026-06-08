import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

/// The root widget of the application.
class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C++ Technical Quiz',
      theme: ThemeData(
        // We use a Seed Color to automatically generate a matching color scheme
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// --- Data Models ---

/// A simple class to hold Question data.
class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

// --- Screens ---

/// 1. Login Screen
/// This is a StatefulWidget because we need to handle text input.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller to get text from the TextField (like 'document.getElementById' in JS)
  final TextEditingController _nameController = TextEditingController();

  void _startQuiz() {
    String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      // Navigator is used to switch between screens
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen(userName: name)),
      );
    } else {
      // Show a snackbar if the name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name to begin!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a Container with a Gradient for a "stylish" look
      body: Container(
        width: double
            .infinity,        // fill full width  -> take all available horizontal space
        alignment:
            Alignment.center, // center the content vertically and horizontally
        decoration: const BoxDecoration(
          // background styling with a purple gradient
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.indigo],
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.code,
              size: 100,
              color: Colors.white,
            ), // app logo icon
            const SizedBox(height: 20), // used for spacing
            const Text(
              'C++ MASTER QUIZ',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40), // spacing before the login card
            // A Card makes the login area look neat
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ), // spacing on left and right
              child: Card(
                // white card for the input form
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  // internal spacing for the card
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        // input field for the user's name
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Your Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // gap between input and button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          // button to trigger the quiz start
                          onPressed: _startQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'START QUIZ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. Quiz Screen
class QuizScreen extends StatefulWidget {
  final String userName;
  const QuizScreen({super.key, required this.userName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // 10 C++ Technical Questions
  final List<Question> _questions = [
    Question(
      questionText:
          'Which operator is used to access members of a class through a pointer?',
      options: ['.', '->', '*', '&'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What is the correct way to declare a pointer in C++?',
      options: ['int p;', 'int &p;', 'int *p;', 'pointer p;'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'Which header file is required for using cin and cout?',
      options: ['<stdio.h>', '<iostream>', '<conio.h>', '<iomanip>'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What is the size of "char" in C++ (typically)?',
      options: ['1 byte', '2 bytes', '4 bytes', '8 bytes'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          'Which keyword is used to prevent a variable from being modified?',
      options: ['static', 'final', 'immutable', 'const'],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText:
          'In C++, which of the following is used for dynamic memory allocation?',
      options: ['malloc()', 'new', 'create', 'alloc'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          'Which of the following is the correct syntax for a "for" loop?',
      options: [
        'for(i=0; i<10)',
        'for(int i=0; i<10; i++)',
        'for i in range(10):',
        'foreach(i to 10)',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What does "STL" stand for in C++?',
      options: [
        'System Test Language',
        'Standard Template Library',
        'Simple Tool Language',
        'Static Type Library',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          'Which access specifier makes members accessible only within the class?',
      options: ['public', 'protected', 'private', 'internal'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'What is a "destructor" used for?',
      options: [
        'To initialize an object',
        'To copy an object',
        'To free memory when an object is destroyed',
        'To create a new class',
      ],
      correctAnswerIndex: 2,
    ),
  ];

  int _currentIndex = 0;
  int _score = 0;
  int _timeLeft = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();     // Stop any existing timer
    _timeLeft = 15;       // Reset to 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--); // Update the UI every second
      } else {
        _goToNextQuestion(); // Move to next question if time is up
      }
    });
  }

  void _answerQuestion(int index) {
    if (index == _questions[_currentIndex].correctAnswerIndex) {
      _score++;
    }
    _goToNextQuestion();
  }

  void _goToNextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
      _startTimer();
    } else {
      _timer?.cancel();
      // Show results when quiz is finished
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            total: _questions.length,
            userName: widget.userName,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1} of ${_questions.length}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Timer and User Info
            Row(
              // header row showing user name and countdown timer
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User: ${widget.userName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: _timeLeft < 5
                      ? Colors.red
                      : Colors.deepPurple,
                  child: Text(
                    '$_timeLeft',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // spacing
            LinearProgressIndicator(
              value: _timeLeft / 15,
              color: _timeLeft < 5 ? Colors.red : Colors.deepPurple,
            ),
            const SizedBox(height: 40),
            // Question Text
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Options (mapped using a simple loop)
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: OutlinedButton(
                      onPressed: () => _answerQuestion(index),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        side: const BorderSide(color: Colors.deepPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        currentQuestion.options[index],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. Result Screen
class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String userName;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.indigo],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              'Congrats, $userName!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Your Score: $score / $total',
              style: const TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'TRY AGAIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
