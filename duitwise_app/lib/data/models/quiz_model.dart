/////////////////////////////////////////////////////////
//                 QUIZ MODEL 
//////////////////////////////////////////////////////////
library;

class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final Map<String, String> options;
  final String correctAnswer; 
  final String explanation;
  final int points;
  final int timePerQuestion; 

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