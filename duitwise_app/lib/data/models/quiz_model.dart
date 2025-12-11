//////////////////////////////////////////////////////////
//                 QUIZ MODEL                           //
//////////////////////////////////////////////////////////

library;

class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final int points; // Points for correct answer

  QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.points = 10,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? '',
      lessonId: json['lessonId'] ?? '',
      question: json['question'] ?? '',
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : [],
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      points: json['points'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'points': points,
    };
  }
}

class QuizResult {
  final String id;
  final String userId;
  final String lessonId;
  final int score;
  final int totalQuestions;
  final List<bool> answersCorrect;
  final DateTime completedAt;
  final int timeTakenSeconds; // Time taken to complete quiz

  QuizResult({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.score,
    required this.totalQuestions,
    required this.answersCorrect,
    required this.completedAt,
    this.timeTakenSeconds = 0,
  });

  double get percentage => (score / totalQuestions) * 100;

  String get resultText {
    if (percentage >= 80) return 'Excellent!';
    if (percentage >= 60) return 'Good';
    if (percentage >= 40) return 'Satisfactory';
    return 'Try Again';
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      answersCorrect: json['answersCorrect'] != null
          ? List<bool>.from(json['answersCorrect'])
          : [],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
      timeTakenSeconds: json['timeTakenSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'lessonId': lessonId,
      'score': score,
      'totalQuestions': totalQuestions,
      'answersCorrect': answersCorrect,
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTakenSeconds,
    };
  }
}