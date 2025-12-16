//////////////////////////////////////////////////////////
//                 QUIZ MODEL                           //
//////////////////////////////////////////////////////////

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
    required this.correctAnswer,
    required this.explanation,
    this.points = 10,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // Convert options from Map<dynamic, dynamic> to Map<String, String>
    Map<String, String> optionsMap = {};
    if (json['options'] != null) {
      final optionsJson = json['options'] as Map<dynamic, dynamic>;
      optionsJson.forEach((key, value) {
        optionsMap[key.toString()] = value.toString();
      });
    }

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

  static Map<String, String> _parseOptions(dynamic optionsData) {
    final Map<String, String> options = {};
    
    if (optionsData is Map) {
      optionsData.forEach((key, value) {
        if (key != null && value != null) {
          options[key.toString()] = value.toString();
        }
      });
    }
    
    return options;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'timePerQuestion': timePerQuestion,
      'points': points,
      'timePerQuestion': timePerQuestion,
    };
  }
}

class QuizResult {
  final String id;
  final String userId;
  final String lessonId;
  final String quizId; // Optional: if you have separate quiz metadata
  final int score;
  final int totalQuestions;
  final Map<String, String?> userAnswers; // questionId -> selectedAnswer
  final List<bool> answersCorrect;
  final Map<String, String?> userAnswers;
  final DateTime completedAt;
  final int timeTakenSeconds; // Time taken to complete quiz

  QuizResult({
    required this.id,
    required this.userId,
    required this.lessonId,
    this.quizId = '',
    required this.score,
    required this.totalQuestions,
    required this.userAnswers,
    required this.answersCorrect,
    required this.userAnswers,
    required this.completedAt,
    this.timeTakenSeconds = 0,
    this.totalTimeAllotted = 0,
  });

  double get percentage => totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;

  String get resultText {
    if (percentage >= 80) return 'Excellent!';
    if (percentage >= 60) return 'Good';
    if (percentage >= 40) return 'Satisfactory';
    return 'Try Again';
  }

  bool get passed => percentage >= 60; // 60% passing score

  // Calculate time efficiency (percentage of time used vs allotted)
  double get timeEfficiency {
    if (totalTimeAllotted == 0) return 0;
    return ((totalTimeAllotted - timeTakenSeconds) / totalTimeAllotted) * 100;
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    // Convert userAnswers from Map<dynamic, dynamic> to Map<String, String?>
    Map<String, String?> userAnswersMap = {};
    if (json['userAnswers'] != null) {
      final answersJson = json['userAnswers'] as Map<dynamic, dynamic>;
      answersJson.forEach((key, value) {
        userAnswersMap[key.toString()] = value?.toString();
      });
    }

    return QuizResult(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      answersCorrect: json['answersCorrect'] != null
          ? List<bool>.from(json['answersCorrect'])
          : [],
      userAnswers: json['userAnswers'] != null
          ? Map<String, String?>.from(json['userAnswers'])
          : {},
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
      'quizId': quizId,
      'score': score,
      'totalQuestions': totalQuestions,
      'userAnswers': userAnswers,
      'answersCorrect': answersCorrect,
      'userAnswers': userAnswers,
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTakenSeconds,
    };
  }
}