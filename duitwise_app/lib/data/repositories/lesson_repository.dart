import 'package:firebase_database/firebase_database.dart';
import '../models/lesson_model.dart';

class LessonRepository {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final String _lessonsPath = 'lessons';

  /// Watch lessons in realtime (for learning page / admin dashboard)
  Stream<List<Lesson>> watchLessons() {
    final lessonsRef = _databaseRef.child(_lessonsPath);

    return lessonsRef.onValue.map((event) {
      final snapshot = event.snapshot;

      if (!snapshot.exists || snapshot.value == null) {
        return <Lesson>[];
      }

      final value = snapshot.value;
      final List<Lesson> lessons = [];

      // Case 1: data stored as LIST
      if (value is List) {
        for (int i = 0; i < value.length; i++) {
          final item = value[i];
          if (item == null) continue;

          try {
            final lessonData = Map<String, dynamic>.from(
              item as Map<dynamic, dynamic>,
            );

            // If list storage doesn't have id, keep it as-is
            lessons.add(Lesson.fromJson(lessonData));
          } catch (_) {
            // skip invalid entry
          }
        }
      }
      // Case 2: data stored as MAP (most common with push().key)
      else if (value is Map) {
        final Map<dynamic, dynamic> lessonsMap = value;

        lessonsMap.forEach((key, data) {
          if (data == null) return;

          try {
            final lessonData = Map<String, dynamic>.from(
              data as Map<dynamic, dynamic>,
            );

            // Ensure id exists even if not stored
            lessonData['id'] = lessonData['id'] ?? key.toString();

            lessons.add(Lesson.fromJson(lessonData));
          } catch (_) {
            // skip invalid entry
          }
        });
      } else {
        return <Lesson>[];
      }

      return lessons;
    });
  }

  Future<List<Lesson>> getAllLessons() async {
    try {
      final snapshot = await _databaseRef.child(_lessonsPath).get();

      if (snapshot.exists) {
        final value = snapshot.value;
        final List<Lesson> lessons = [];

        if (value is List) {
          for (int i = 0; i < value.length; i++) {
            final item = value[i];
            if (item == null) continue;

            try {
              final lessonData = Map<String, dynamic>.from(
                item as Map<dynamic, dynamic>,
              );
              lessons.add(Lesson.fromJson(lessonData));
            } catch (_) {
              continue;
            }
          }
        } else if (value is Map) {
          final Map<dynamic, dynamic> lessonsMap = value;

          lessonsMap.forEach((key, val) {
            if (val == null) return;
            try {
              final lessonData = Map<String, dynamic>.from(
                val as Map<dynamic, dynamic>,
              );
              lessonData['id'] = lessonData['id'] ?? key.toString();
              lessons.add(Lesson.fromJson(lessonData));
            } catch (_) {
              // skip invalid
            }
          });
        } else {
          return [];
        }

        return lessons;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  // Get lesson by ID
  Future<Lesson?> getLessonById(String lessonId) async {
    try {
      final snapshot = await _databaseRef
          .child('$_lessonsPath/$lessonId')
          .get();

      if (snapshot.exists && snapshot.value != null) {
        final lessonData = Map<String, dynamic>.from(
          snapshot.value as Map<dynamic, dynamic>,
        );
        lessonData['id'] = lessonData['id'] ?? lessonId;
        return Lesson.fromJson(lessonData);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // Add new lesson (Admin only)
  Future<String?> addLesson(Lesson lesson) async {
    try {
      final newLessonRef = _databaseRef.child(_lessonsPath).push();
      final String lessonId = newLessonRef.key!;

      // build a map manually (no copyWith / toJson needed)
      final lessonData = <String, dynamic>{
        'id': lessonId,
        'title': lesson.title,
        'description': lesson.description,
        'videoUrl': lesson.videoUrl,
        'category': lesson.category,
        'difficulty': lesson.difficulty,
        'learningOutcomes': lesson.learningOutcomes,
      };

      await newLessonRef.set(lessonData);
      return lessonId;
    } catch (_) {
      return null;
    }
  }

  // Update lesson
  Future<bool> updateLesson(String lessonId, Lesson lesson) async {
    try {
      final lessonData = <String, dynamic>{
        'id': lessonId,
        'title': lesson.title,
        'description': lesson.description,
        'videoUrl': lesson.videoUrl,
        'category': lesson.category,
        'difficulty': lesson.difficulty,
        'learningOutcomes': lesson.learningOutcomes,
        // update timestamp if you want
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _databaseRef.child('$_lessonsPath/$lessonId').update(lessonData);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Delete lesson (Admin only)
  Future<bool> deleteLesson(String lessonId) async {
    try {
      await _databaseRef.child('$_lessonsPath/$lessonId').remove();
      return true;
    } catch (_) {
      return false;
    }
  }

  // Get lessons by category
  Future<List<Lesson>> getLessonsByCategory(String category) async {
    try {
      final allLessons = await getAllLessons();
      return allLessons
          .where(
            (lesson) => lesson.category.toLowerCase() == category.toLowerCase(),
          )
          .toList();
    } catch (_) {
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
    } catch (_) {
      return [];
    }
  }
}
