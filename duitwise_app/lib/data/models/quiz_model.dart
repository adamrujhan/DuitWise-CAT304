//////////////////////////////////////////////////////////
//                 QUIZ MODEL                           //
//////////////////////////////////////////////////////////

class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final Map<String, String> options; // {"A": "option text", "B": "option text"}
  final String correctAnswer; // "A", "B", "C", "D"
  final String explanation;
  final int points;
  final int timePerQuestion; // seconds

  QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.points = 1,
    this.timePerQuestion = 60,
  });

  // Convert letter answer to index (A->0, B->1, etc.)
  int get correctAnswerIndex {
    if (correctAnswer.isEmpty) return -1;
    return correctAnswer.codeUnitAt(0) - 'A'.codeUnitAt(0);
  }

  // Get options as List for UI display
  List<String> get optionsList {
    return options.entries
        .map((entry) => '${entry.key}. ${entry.value}')
        .toList();
  }

  // Check if user's answer is correct
  bool isAnswerCorrect(String userAnswer) {
    return userAnswer == correctAnswer;
  }

  // Get option text by letter
  String getOptionText(String letter) {
    return options[letter] ?? '';
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id']?.toString() ?? '',
      lessonId: json['lessonId']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: _parseOptions(json['options']),
      correctAnswer: json['correctAnswer']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? '',
      points: (json['points'] as num?)?.toInt() ?? 1,
      timePerQuestion: (json['timePerQuestion'] as num?)?.toInt() ?? 60,
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
      'points': points,
      'timePerQuestion': timePerQuestion,
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
  final Map<String, String?> userAnswers;
  final DateTime completedAt;
  final int timeTakenSeconds; // Time taken to complete quiz
  final int totalTimeAllotted;

  QuizResult({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.score,
    required this.totalQuestions,
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

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      lessonId: json['lessonId']?.toString() ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
      answersCorrect: json['answersCorrect'] != null
          ? List<bool>.from(json['answersCorrect'])
          : [],
      userAnswers: json['userAnswers'] != null
          ? Map<String, String?>.from(json['userAnswers'])
          : {},
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
      timeTakenSeconds: (json['timeTakenSeconds'] as num?)?.toInt() ?? 0,
      totalTimeAllotted: (json['totalTimeAllotted'] as num?)?.toInt() ?? 0,
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
      'userAnswers': userAnswers,
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTakenSeconds,
      'totalTimeAllotted': totalTimeAllotted,
    };
  }
}