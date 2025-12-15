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
          questionData['id'] = key.toString(); // Use Firebase key as ID
          
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

  // Save quiz result (for future - optional)
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      await _db.child('quiz_results/${result.userId}/$timestamp').set(result.toJson());
    } catch (e) {
      // Ignore for now
    }
  }
}