// This class represents a single question in our quiz app.
class Question {
  final int? id;          // Keep Question ID as int for auto-increment in DB
  final String question;  // The question text
  final String option1;   // First option
  final String option2;   // Second option
  final String option3;   // Third option
  final String option4;   // Fourth option
  final String answer;    // The correct answer

  Question({
    this.id,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.answer,
  });

  // Convert a Question object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'answer': answer,
    };
  }

  // Create a Question object from a Map.
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] is int ? map['id'] : null,
      question: map['question'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['option3'],
      option4: map['option4'],
      answer: map['answer'],
    );
  }
}