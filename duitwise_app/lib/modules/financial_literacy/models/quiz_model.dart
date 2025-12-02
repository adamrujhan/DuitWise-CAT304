// lib/modules/financial_literacy/models/quiz_model.dart
class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  // Add constructor for QuizQuestion too (might have same error)
  QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class QuizResult {
  final String quizId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final List<bool> answersCorrect;

  // Constructor - FIXES THE ERROR
  QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.answersCorrect,
  });

  double get percentage => (score / totalQuestions) * 100;
  
  String get resultText {
    if (percentage >= 80) return 'Cemerlang!';
    if (percentage >= 60) return 'Baik';
    if (percentage >= 40) return 'Memuaskan';
    return 'Perlu cuba lagi';
  }

  // Helper method to create from JSON (for Firebase/Firestore)
  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'score': score,
      'totalQuestions': totalQuestions,
      'completedAt': completedAt.toIso8601String(),
      'answersCorrect': answersCorrect,
    };
  }

  // Helper method to create from JSON
  static QuizResult fromMap(Map<String, dynamic> map) {
    return QuizResult(
      quizId: map['quizId'],
      score: map['score'],
      totalQuestions: map['totalQuestions'],
      completedAt: DateTime.parse(map['completedAt']),
      answersCorrect: List<bool>.from(map['answersCorrect']),
    );
  }
}