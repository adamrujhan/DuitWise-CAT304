import 'package:firebase_database/firebase_database.dart';
import '../models/lesson_model.dart';

class LessonRepository {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final String _lessonsPath = 'lessons';

  Future<List<Lesson>> getAllLessons() async {
    try {
      final snapshot = await _databaseRef.child(_lessonsPath).get();
      
      if (snapshot.exists) {
        final value = snapshot.value;
        final List<Lesson> lessons = [];
        
        if (value is List) {
          // Process list items (skip null first item)
          for (int i = 0; i < value.length; i++) {
            final item = value[i];
            
            // Skip null items
            if (item == null) {
              continue;
            }
            
            try {
              final lessonData = Map<String, dynamic>.from(item as Map<dynamic, dynamic>);
              lessons.add(Lesson.fromJson(lessonData));
            } catch (e) {
              // Skip item on error
              continue;
            }
          }
          
        } else if (value is Map) {
          final Map<dynamic, dynamic> lessonsMap = value;
          
          lessonsMap.forEach((key, value) {
            final lessonData = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
            lessonData['id'] = key.toString();
            lessons.add(Lesson.fromJson(lessonData));
          });
          
        } else {
          return [];
        }
        
        return lessons;
        
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Get lesson by ID
  Future<Lesson?> getLessonById(String lessonId) async {
    try {
      final snapshot = await _databaseRef.child('$_lessonsPath/$lessonId').get();
      
      if (snapshot.exists) {
        final lessonData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        lessonData['id'] = lessonId;
        return Lesson.fromJson(lessonData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get lessons by category
  Future<List<Lesson>> getLessonsByCategory(String category) async {
    try {
      final allLessons = await getAllLessons();
      return allLessons
          .where((lesson) => lesson.category.toLowerCase() == category.toLowerCase())
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get lessons by difficulty
  Future<List<Lesson>> getLessonsByDifficulty(int difficulty) async {
    try {
      final allLessons = await getAllLessons();
      return allLessons
          .where((lesson) => lesson.difficulty == difficulty)
          .toList();
    } catch (e) {
      return [];
    }
  }
}