import 'package:firebase_database/firebase_database.dart';
import 'package:duitwise_app/data/models/lesson_model.dart';
import 'package:duitwise_app/data/models/quiz_model.dart';

class QuizRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  QuizRepository();

  // Fetch all quiz questions for a specific lesson
  Future<List<QuizQuestion>> getQuestionsByLessonId(String lessonId) async {
    try {
      final snapshot = await _db.child('quiz_questions').get();

      if (!snapshot.exists) {
        return [];
      }

      final data = snapshot.value;
      if (data == null || data is! Map<dynamic, dynamic>) {
        return [];
      }

      final List<QuizQuestion> questions = [];

      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          final questionData = Map<String, dynamic>.from(value);
          questionData['id'] = key.toString();

          // Only include questions for the specified lesson
          if (questionData['lessonId']?.toString() == lessonId) {
            try {
              final question = QuizQuestion.fromJson(questionData);
              questions.add(question);
            } catch (e) {
              // Skip if parsing fails
            }
          }
        }
      });

      // Randomize order
      questions.shuffle();

      return questions;
    } catch (e) {
      return [];
    }
  }

  // Add New Quiz For a Lesson
  Future<String?> addQuiz(QuizQuestion quiz, String lessonId ) async {
    try {
      final newQuizRef = _db.child('quiz_questions').push();
      final String quizId = newQuizRef.key!;

      // build a map manually (no copyWith / toJson needed)
      final quizData = <String, dynamic>{
        'id': quizId,
        'lessonId': lessonId,
        'question': quiz.question,
        'options': quiz.options,
        'correctAnswer': quiz.correctAnswer,
        'points': quiz.points,
        'timePerQuestion': quiz.timePerQuestion,
      };

      await newQuizRef.set(quizData);
      return quizId;
    } catch (_) {
      return null;
    }
  }

  // Calculate total time for a lesson's quiz (sum of all question times)
  Future<int> getTotalQuizTimeForLesson(String lessonId) async {
    final questions = await getQuestionsByLessonId(lessonId);
    int totalTime = 0;
    for (var question in questions) {
      totalTime += question.timePerQuestion;
    }
    return totalTime;
  }

  // Get total question count for a lesson
  Future<int> getQuestionCountForLesson(String lessonId) async {
    final questions = await getQuestionsByLessonId(lessonId);
    return questions.length;
  }

  // Get lesson information
  Future<Lesson?> getLessonForQuiz(String lessonId) async {
    try {
      final snapshot = await _db.child('lessons').get();

      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.value;
      if (data == null || data is! List) {
        return null;
      }

      // Find lesson by ID (handle null entries in array)
      for (var item in data) {
        if (item != null && item is Map<dynamic, dynamic>) {
          final lessonData = Map<String, dynamic>.from(item);
          if (lessonData['id']?.toString() == lessonId) {
            return Lesson.fromJson(lessonData);
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
