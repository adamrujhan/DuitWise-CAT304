import 'package:firebase_database/firebase_database.dart';
import '../models/lesson_model.dart';

class LessonRepository {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final String _lessonsPath = 'lessons';

  // In lesson_repository.dart, modify getAllLessons():
Future<List<Lesson>> getAllLessons() async {
  try {
    print('🔍 Fetching lessons from Firebase...');
    print('📁 Path: $_lessonsPath');
    
    final snapshot = await _databaseRef.child(_lessonsPath).get();
    
    print('📊 Snapshot exists: ${snapshot.exists}');
    
    if (snapshot.exists) {
      final value = snapshot.value;
      print('📦 Snapshot value type: ${value.runtimeType}');
      print('📦 Snapshot value: $value');
      
      final List<Lesson> lessons = [];
      
      if (value is List) {
        print('📦 Processing as LIST (array) structure');
        
        // Process list items (skip null first item)
        for (int i = 0; i < value.length; i++) {
          final item = value[i];
          
          // Skip null items (your data shows first item is null)
          if (item == null) {
            print('⏭️ Skipping null item at index $i');
            continue;
          }
          
          try {
            final lessonData = Map<String, dynamic>.from(item as Map<dynamic, dynamic>);
            
            // Use the 'id' field from data, or generate from index
            // Your data already has 'id' field: "id": "1", "id": "2", etc.
            // So we should use that instead of index
            print('📄 Processing lesson at index $i: $lessonData');
            
            lessons.add(Lesson.fromJson(lessonData));
          } catch (e) {
            print('⚠️ Error processing item at index $i: $e');
          }
        }
        
        print('✅ Successfully loaded ${lessons.length} lessons from LIST');
        
      } else if (value is Map) {
        print('📦 Processing as MAP structure');
        final Map<dynamic, dynamic> lessonsMap = value;
        print('📦 Lessons count: ${lessonsMap.length}');
        print('🔑 Lesson keys: ${lessonsMap.keys.toList()}');
        
        lessonsMap.forEach((key, value) {
          print('📄 Processing lesson $key: $value');
          final lessonData = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
          lessonData['id'] = key.toString();
          lessons.add(Lesson.fromJson(lessonData));
        });
        
        print('✅ Successfully loaded ${lessons.length} lessons from MAP');
        
      } else {
        print('⚠️ Unknown data structure type: ${value.runtimeType}');
        return [];
      }
      
      return lessons;
      
    } else {
      print('⚠️ No lessons found at path: $_lessonsPath');
      return [];
    }
  } catch (e, stackTrace) {
    print('❌ Error fetching lessons: $e');
    print('Stack trace: $stackTrace');
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
      print('Error fetching lesson $lessonId: $e');
      return null;
    }
  }

  // Add new lesson (Admin only)
  Future<String?> addLesson(Lesson lesson) async {
    try {
      final newLessonRef = _databaseRef.child(_lessonsPath).push();
      final String lessonId = newLessonRef.key!;
      
      final lessonData = lesson.copyWith(id: lessonId).toJson();
      await newLessonRef.set(lessonData);
      
      return lessonId;
    } catch (e) {
      print('Error adding lesson: $e');
      return null;
    }
  }

  // Update lesson
  Future<bool> updateLesson(String lessonId, Lesson lesson) async {
    try {
      final lessonData = lesson.toJson();
      await _databaseRef.child('$_lessonsPath/$lessonId').update(lessonData);
      return true;
    } catch (e) {
      print('Error updating lesson: $e');
      return false;
    }
  }

  // Delete lesson (Admin only)
  Future<bool> deleteLesson(String lessonId) async {
    try {
      await _databaseRef.child('$_lessonsPath/$lessonId').remove();
      return true;
    } catch (e) {
      print('Error deleting lesson: $e');
      return false;
    }
  }

  // Get lessons by category
  Future<List<Lesson>> getLessonsByCategory(String category) async {
    try {
      final allLessons = await getAllLessons();
      return allLessons.where((lesson) => lesson.category.toLowerCase() == category.toLowerCase()).toList();
    } catch (e) {
      print('Error fetching lessons by category: $e');
      return [];
    }
  }

  // Get lessons by difficulty
  Future<List<Lesson>> getLessonsByDifficulty(int difficulty) async {
    try {
      final allLessons = await getAllLessons();
      return allLessons.where((lesson) => lesson.difficulty == difficulty).toList();
    } catch (e) {
      print('Error fetching lessons by difficulty: $e');
      return [];
    }
  }
}

Future<bool> testConnection() async {
  try {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    await ref.child('connection_test').set({
      'timestamp': DateTime.now().toIso8601String(),
      'message': 'Connection test from DuitWise'
    });
    
    // Clean up test data
    await ref.child('connection_test').remove();
    
    print('✅ Firebase connection successful');
    return true;
  } catch (e) {
    print('❌ Firebase connection failed: $e');
    return false;
  }
}