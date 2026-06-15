import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/result.dart';

// This screen allows the Admin to see who participated and what they scored.
class ViewResultsScreen extends StatefulWidget {
  const ViewResultsScreen({super.key});

  @override
  State<ViewResultsScreen> createState() => _ViewResultsScreenState();
}

class _ViewResultsScreenState extends State<ViewResultsScreen> {
  List<QuizResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  // Get the results from the database
  Future<void> _fetchResults() async {
    final data = await DatabaseHelper.instance.readAllResults();
    setState(() {
      _results = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Results'),
        actions: [
          IconButton(onPressed: _fetchResults, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No participants yet.'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final res = _results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            res.studentName[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('${res.studentName} (ID: ${res.studentId})',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Score: ${res.score} / ${res.total}'),
                            Text('Accuracy: ${res.accuracy.toStringAsFixed(1)}%'),
                            Text('Date: ${res.date}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
