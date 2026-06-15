import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/question.dart';

// This screen is used for both adding a new question and updating an existing one.
class ManageQuestionScreen extends StatefulWidget {
  final Question? question; // If this is provided, we are in "Update" mode.

  const ManageQuestionScreen({super.key, this.question});

  @override
  State<ManageQuestionScreen> createState() => _ManageQuestionScreenState();
}

class _ManageQuestionScreenState extends State<ManageQuestionScreen> {
  // Form key to validate that all fields are filled.
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields.
  final _questionController = TextEditingController();
  final _opt1Controller = TextEditingController();
  final _opt2Controller = TextEditingController();
  final _opt3Controller = TextEditingController();
  final _opt4Controller = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If we are editing, pre-fill the fields with the existing question data.
    if (widget.question != null) {
      _questionController.text = widget.question!.question;
      _opt1Controller.text = widget.question!.option1;
      _opt2Controller.text = widget.question!.option2;
      _opt3Controller.text = widget.question!.option3;
      _opt4Controller.text = widget.question!.option4;
      _answerController.text = widget.question!.answer;
    }
  }

  // Saves the question to the database.
  void _saveQuestion() async {
    debugPrint('Save button clicked');
    if (_formKey.currentState!.validate()) {
      try {
        final q = Question(
          id: widget.question?.id,
          question: _questionController.text.trim(),
          option1: _opt1Controller.text.trim(),
          option2: _opt2Controller.text.trim(),
          option3: _opt3Controller.text.trim(),
          option4: _opt4Controller.text.trim(),
          answer: _answerController.text.trim(),
        );

        debugPrint('Attempting to save question: ${q.question}');

        if (widget.question == null) {
          await DatabaseHelper.instance.createQuestion(q);
          debugPrint('Question created successfully');
        } else {
          await DatabaseHelper.instance.updateQuestion(q);
          debugPrint('Question updated successfully');
        }

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint('Error saving question: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Database Error: $e')),
          );
        }
      }
    } else {
      debugPrint('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'Add Question' : 'Update Question'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (val) => val!.isEmpty ? 'Enter question' : null,
              ),
              TextFormField(
                controller: _opt1Controller,
                decoration: const InputDecoration(labelText: 'Option 1'),
                validator: (val) => val!.isEmpty ? 'Enter option 1' : null,
              ),
              TextFormField(
                controller: _opt2Controller,
                decoration: const InputDecoration(labelText: 'Option 2'),
                validator: (val) => val!.isEmpty ? 'Enter option 2' : null,
              ),
              TextFormField(
                controller: _opt3Controller,
                decoration: const InputDecoration(labelText: 'Option 3'),
                validator: (val) => val!.isEmpty ? 'Enter option 3' : null,
              ),
              TextFormField(
                controller: _opt4Controller,
                decoration: const InputDecoration(labelText: 'Option 4'),
                validator: (val) => val!.isEmpty ? 'Enter option 4' : null,
              ),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(labelText: 'Answer (Match one option)'),
                validator: (val) => val!.isEmpty ? 'Enter answer' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveQuestion,
                child: const Text('Save Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
