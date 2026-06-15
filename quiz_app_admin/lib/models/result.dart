// This class represents a student's quiz result.
class QuizResult {
  final String studentId; // We will use the Student ID entered by the user as the unique key
  final String studentName;
  final int score;
  final int total;
  final double accuracy;
  final String date; 

  QuizResult({
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.total,
    required this.accuracy,
    required this.date,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap(){
    return {
      'studentId' : studentId,
      'studentName' : studentName,
      'score' : score,
      'total' : total,
      'accuracy' : accuracy,
      'date' : date,
    };
  }

  // Create from Map for SQLite
  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      studentId: map['studentId'] as String,
      studentName: map['studentName'] as String,
      score: map['score'] as int,
      total: map['total'] as int,
      accuracy: (map['accuracy'] as num).toDouble(),
      date: map['date'] as String,
    );
  }
}
