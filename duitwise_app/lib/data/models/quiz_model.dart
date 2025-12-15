//////////////////////////////////////////////////////////
//                 QUIZ MODEL                           //
//////////////////////////////////////////////////////////

library;

class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final Map<String, String> options; // Changed from List<String> to Map<String, String>
  final String correctAnswer; // Changed from int to String (A, B, C, D)
  final String explanation;
  final int timePerQuestion; // Time limit in seconds for this question
  final int points; // Points for correct answer

  QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.timePerQuestion,
    this.points = 1, // Default 1 point per question
  });

  // Get options as a list for easy display (A, B, C, D order)
  List<MapEntry<String, String>> get optionsList {
    // Sort options by key (A, B, C, D) to maintain consistent order
    final sortedEntries = options.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries;
  }

  // Check if an answer is correct
  bool isAnswerCorrect(String selectedAnswer) {
    return selectedAnswer == correctAnswer;
  }

  // Get correct answer text
  String get correctAnswerText {
    return options[correctAnswer] ?? '';
  }

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
      id: json['id']?.toString() ?? '',
      lessonId: json['lessonId']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: optionsMap,
      correctAnswer: json['correctAnswer']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? '',
      timePerQuestion: (json['timePerQuestion'] ?? 60) as int,
      points: (json['points'] ?? 1) as int,
    );
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
  final DateTime completedAt;
  final int timeTakenSeconds; // Total time taken to complete quiz
  final int totalTimeAllotted; // Sum of timePerQuestion for all questions

  QuizResult({
    required this.id,
    required this.userId,
    required this.lessonId,
    this.quizId = '',
    required this.score,
    required this.totalQuestions,
    required this.userAnswers,
    required this.answersCorrect,
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
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      lessonId: json['lessonId']?.toString() ?? '',
      quizId: json['quizId']?.toString() ?? '',
      score: (json['score'] ?? 0) as int,
      totalQuestions: (json['totalQuestions'] ?? 0) as int,
      userAnswers: userAnswersMap,
      answersCorrect: json['answersCorrect'] != null
          ? List<bool>.from(json['answersCorrect'])
          : [],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
      timeTakenSeconds: (json['timeTakenSeconds'] ?? 0) as int,
      totalTimeAllotted: (json['totalTimeAllotted'] ?? 0) as int,
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
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTakenSeconds,
      'totalTimeAllotted': totalTimeAllotted,
    };
  }
}

// Additional model for tracking quiz session progress
class QuizSession {
  final String id;
  final String userId;
  final String lessonId;
  final List<QuizQuestion> questions;
  final List<String?> userAnswers; // Parallel array to questions
  final List<int> timeSpentPerQuestion; // Seconds spent on each question
  final int currentQuestionIndex;
  final DateTime startedAt;
  final bool isCompleted;

  QuizSession({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.questions,
    required this.userAnswers,
    required this.timeSpentPerQuestion,
    this.currentQuestionIndex = 0,
    required this.startedAt,
    this.isCompleted = false,
  });

  // Calculate total time allotted for the quiz
  int get totalTimeAllotted {
    return questions.fold(0, (sum, question) => sum + question.timePerQuestion);
  }

  // Calculate remaining time for current question
  int get remainingTimeForCurrentQuestion {
    if (currentQuestionIndex >= questions.length) return 0;
    final timeSpent = timeSpentPerQuestion[currentQuestionIndex];
    final question = questions[currentQuestionIndex];
    return question.timePerQuestion - timeSpent;
  }

  // Calculate total time spent so far
  int get totalTimeSpent {
    return timeSpentPerQuestion.fold(0, (sum, time) => sum + (time));
  }

  // Calculate score based on current answers
  int calculateCurrentScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < userAnswers.length && userAnswers[i] != null) {
        if (questions[i].isAnswerCorrect(userAnswers[i]!)) {
          score += questions[i].points;
        }
      }
    }
    return score;
  }
}