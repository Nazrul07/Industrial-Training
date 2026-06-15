import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/question.dart';
import 'manage_question.dart';
import 'view_results.dart'; // Import the new results screen

// This screen shows all questions currently in the database.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _refreshQuestions(); // Load questions when the screen starts.
  }

  // Fetches all questions from the SQLite database.
  Future<void> _refreshQuestions() async {
    final data = await DatabaseHelper.instance.readAllQuestions();
    setState(() {
      _questions = data;
    });
  }

  // Deletes a question and refreshes the list.
  void _deleteQuestion(int id) async {
    await DatabaseHelper.instance.deleteQuestion(id);
    _refreshQuestions();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question Deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          // NEW: Button to navigate to the Results screen
          IconButton(
            tooltip: 'View Student Results',
            icon: const Icon(Icons.analytics, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewResultsScreen()),
              );
            },
          ),
          // Refresh button to manually reload data.
          IconButton(onPressed: _refreshQuestions, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _questions.isEmpty
          ? const Center(child: Text('No Questions Found!'))
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(q.question),
                    subtitle: Text('Ans: ${q.answer}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageQuestionScreen(question: q),
                              ),
                            );
                            _refreshQuestions(); // Refresh after coming back from edit.
                          },
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteQuestion(q.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      // Floating button to add a new question.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManageQuestionScreen()),
          );
          _refreshQuestions(); // Refresh after coming back from add.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
